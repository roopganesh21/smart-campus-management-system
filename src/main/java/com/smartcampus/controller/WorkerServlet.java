package com.smartcampus.controller;

import com.smartcampus.dao.ComplaintDAO;
import com.smartcampus.dao.UserDAO;
import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.model.Complaint;
import com.smartcampus.model.User;
import com.smartcampus.utility.FileUploadUtil;
import com.smartcampus.utility.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * WorkerServlet manages activities related to workers, including showing assigned tickets
 * on the Worker Dashboard, transitioning status codes, and uploading resolution proof.
 * 
 * NOTE: As mapped in web.xml (/worker/*), we do not add the @WebServlet annotation here 
 * to prevent Tomcat registration collisions.
 */
@MultipartConfig(
    maxFileSize = 5242880,      // 5MB per file
    maxRequestSize = 26214400   // 25MB total request size
)
public class WorkerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(WorkerServlet.class.getName());

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"worker".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
            LOGGER.warning("Unauthorized GET attempt to WorkerServlet.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        LOGGER.info("WorkerServlet doGet pathInfo: " + pathInfo);

        if (pathInfo == null || "/".equals(pathInfo) || "/dashboard".equals(pathInfo)) {
            int workerId = (Integer) session.getAttribute("userId");
            
            // 1. Fetch complaints assigned to this worker
            List<Complaint> complaints = complaintDAO.getComplaintsByWorker(workerId);
            
            // 2. Calculate summary counts
            int assignedCount = 0;
            int inProgressCount = 0;
            int completedCount = 0;

            for (Complaint c : complaints) {
                String status = c.getStatus().toLowerCase();
                if ("assigned".equals(status)) {
                    assignedCount++;
                } else if ("in_progress".equals(status) || "in progress".equals(status)) {
                    inProgressCount++;
                } else if ("resolved".equals(status)) {
                    completedCount++;
                }
            }

            // Set attributes
            request.setAttribute("complaints", complaints);
            request.setAttribute("assignedCount", assignedCount);
            request.setAttribute("inProgressCount", inProgressCount);
            request.setAttribute("completedCount", completedCount);

            LOGGER.info(String.format("Worker stats - Assigned: %d, In Progress: %d, Completed: %d", assignedCount, inProgressCount, completedCount));
            
            // Forward to secure WEB-INF JSP template
            request.getRequestDispatcher("/WEB-INF/worker/dashboard.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"worker".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
            LOGGER.warning("Unauthorized POST attempt to WorkerServlet.");
            sendJsonResponse(response, false, "Unauthorized worker access.");
            return;
        }

        int workerId = (Integer) session.getAttribute("userId");
        String pathInfo = request.getPathInfo();
        LOGGER.info("WorkerServlet doPost pathInfo: " + pathInfo);

        if ("/updateStatus".equals(pathInfo)) {
            try {
                // Get form params (MultipartConfig parses them natively in Tomcat 10)
                String complaintIdStr = request.getParameter("complaintId");
                String newStatus = request.getParameter("newStatus");
                String remark = request.getParameter("remark");

                if (complaintIdStr == null || newStatus == null) {
                    sendJsonResponse(response, false, "Missing required parameters.");
                    return;
                }

                int complaintId = Integer.parseInt(complaintIdStr);
                
                // 1. Security Check: Validate assignment ownership
                Optional<Complaint> compOpt = complaintDAO.getComplaintById(complaintId);
                if (compOpt.isEmpty()) {
                    sendJsonResponse(response, false, "Complaint ticket not found.");
                    return;
                }
                
                Complaint complaint = compOpt.get();
                if (complaint.getWorkerId() == null || complaint.getWorkerId() != workerId) {
                    LOGGER.warning(String.format("Security breach! Worker %d tried to modify complaint %d assigned to worker %s", 
                            workerId, complaintId, complaint.getWorkerId()));
                    sendJsonResponse(response, false, "Access denied: This complaint is not assigned to you.");
                    return;
                }

                // 2. Handle Image Upload Proof if provided
                List<String> uploadedProofPaths = null;
                if (FileUploadUtil.isMultipartContent(request)) {
                    try {
                        uploadedProofPaths = FileUploadUtil.uploadFiles(request, "complaint-images", "proofImage");
                    } catch (IllegalArgumentException e) {
                        sendJsonResponse(response, false, e.getMessage());
                        return;
                    }
                }

                // Save paths to database
                if (uploadedProofPaths != null && !uploadedProofPaths.isEmpty()) {
                    for (String path : uploadedProofPaths) {
                        complaintDAO.addComplaintImage(complaintId, path);
                    }
                }

                // 3. Update status in Database
                boolean success = complaintDAO.updateComplaintStatus(complaintId, newStatus, remark, workerId);
                if (success) {
                    // 4. Create notification for student
                    notificationDAO.createNotification(
                        complaint.getStudentId(),
                        "Your complaint #" + complaintId + " ('" + complaint.getTitle() + "') was marked " + newStatus + " by the worker.",
                        "complaint",
                        complaintId
                    );

                    // 5. Send SMTP email simulation if status is resolved
                    if ("resolved".equalsIgnoreCase(newStatus)) {
                        Optional<User> studentOpt = userDAO.getUserById(complaint.getStudentId());
                        if (studentOpt.isPresent()) {
                            User student = studentOpt.get();
                            String emailBody = String.format("Dear %s,\n\nYour complaint regarding '%s' has been marked as RESOLVED by the assigned maintenance worker.\n\nRemarks:\n%s\n\nPlease log in to the Smart Campus portal to verify and provide feedback.\n\nBest regards,\nSmart Campus Maintenance Team", 
                                    student.getName(), complaint.getTitle(), remark);
                            EmailUtil.sendEmail(student.getEmail(), "Complaint Resolved: #" + complaintId, emailBody);
                        }
                    }

                    sendJsonResponse(response, true, "Complaint status successfully updated.");
                } else {
                    sendJsonResponse(response, false, "Failed to update complaint status in database.");
                }

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error updating status", e);
                sendJsonResponse(response, false, "Server error: " + e.getMessage());
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format("{\"success\":%b, \"message\":\"%s\"}", success, message));
    }
}
