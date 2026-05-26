package com.smartcampus.controller;

import com.smartcampus.dao.ComplaintDAO;
import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.Complaint;
import com.smartcampus.model.User;
import com.smartcampus.utility.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ComplaintServlet handles students filing complaints, including file uploads.
 * Maps to "/student/raiseComplaint" and coordinates with ComplaintDAO and FileUploadUtil.
 */
@WebServlet(name = "ComplaintServletWeb", urlPatterns = {"/student/raiseComplaint"})
@MultipartConfig(
    maxFileSize = 5242880,      // 5MB per file
    maxRequestSize = 26214400   // 25MB total request size (5 files * 5MB)
)
public class ComplaintServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ComplaintServlet.class.getName());
    
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();

    // Valid category enums
    private static final List<String> VALID_CATEGORIES = Arrays.asList(
        "hostel", "classroom", "electricity", "water", "lab", "other"
    );

    // Valid priority enums
    private static final List<String> VALID_PRIORITIES = Arrays.asList(
        "low", "medium", "high"
    );

    /**
     * Handles HTTP GET requests.
     * Guarantees session checks and forwards to raiseComplaint.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Access blocked: Unauthenticated student attempt to access raiseComplaint.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/student/raiseComplaint.jsp").forward(request, response);
    }

    /**
     * Handles HTTP POST requests for complaint submission.
     * Manages parameters validation, calls FileUploadUtil to save images, persists complaint
     * records, logs the transition state, and redirects.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session verification and extract studentId
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Submission blocked: Unauthenticated attempt.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");

        // 2. Extract form parameters
        String title = trimParameter(request.getParameter("title"));
        String category = trimParameter(request.getParameter("category"));
        String priority = trimParameter(request.getParameter("priority"));
        String description = trimParameter(request.getParameter("description"));

        // 3. Server-side validations
        String validationError = validateInputs(title, category, priority, description);
        if (validationError != null) {
            LOGGER.log(Level.WARNING, "Complaint submission failed validation: " + validationError);
            forwardWithError(request, response, validationError, title, category, priority, description);
            return;
        }

        List<String> imagePaths = null;
        try {
            // 4. File uploads parsing and storage
            if (FileUploadUtil.isMultipartContent(request)) {
                // Returns paths like: "uploads/complaint-images/uuid_name.jpg"
                imagePaths = FileUploadUtil.uploadFiles(request, "complaint-images", "images");
            }
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "File upload rejected: " + e.getMessage());
            forwardWithError(request, response, e.getMessage(), title, category, priority, description);
            return;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error processing file uploads.", e);
            forwardWithError(request, response, "Failed to upload supporting images. Please try again.", title, category, priority, description);
            return;
        }

        try {
            // 5. Instantiate and populate Complaint model
            Complaint complaint = new Complaint();
            complaint.setStudentId(studentId);
            complaint.setTitle(title);
            complaint.setCategory(category);
            complaint.setPriority(priority);
            complaint.setDescription(description);
            complaint.setStatus("pending");

            // 6. DB Insertion - Create Complaint
            int complaintId = complaintDAO.createComplaint(complaint);
            if (complaintId <= 0) {
                throw new SQLException("Failed to retrieve generated key for complaint registration.");
            }

            // 7. DB Insertion - Save Images
            if (imagePaths != null && !imagePaths.isEmpty()) {
                for (String path : imagePaths) {
                    boolean imgAdded = complaintDAO.addComplaintImage(complaintId, path);
                    if (!imgAdded) {
                        LOGGER.warning("Could not associate image path in database: " + path);
                    }
                }
            }

            // 8. DB Insertion - Save Initial Status Log (Transaction integrated in DAO)
            boolean logSuccess = complaintDAO.updateComplaintStatus(
                complaintId, "pending", "Complaint submitted.", studentId
            );
            if (!logSuccess) {
                LOGGER.warning("Failed to record initial status transition log for ID: " + complaintId);
            }

            // 9. Admin Notifications Structure
            // TODO Phase 4: Integrate robust NotificationDAO structures.
            try {
                List<User> admins = userDAO.getAllAdmins();
                LOGGER.info("Creating notifications for " + admins.size() + " administrators regarding complaint ID: " + complaintId);
                for (User admin : admins) {
                    // TODO: notificationDAO.createNotification(
                    //     admin.getId(), 
                    //     "New complaint filed: " + title, 
                    //     "complaint", 
                    //     complaintId
                    // );
                }
            } catch (Exception nEx) {
                LOGGER.log(Level.WARNING, "Non-blocking error spawning admin notifications.", nEx);
            }

            LOGGER.info("Complaint submitted successfully by student " + studentId + " with ID " + complaintId);
            
            // 10. Redirect to Track Complaints page with success flag
            response.sendRedirect(request.getContextPath() + "/student/trackComplaints?submitted=true");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected database error persisting complaint data.", e);
            // Clean up any written files on DB insertion failure to prevent orphan files
            if (imagePaths != null && !imagePaths.isEmpty()) {
                for (String path : imagePaths) {
                    FileUploadUtil.deleteFile(path, request);
                }
            }
            forwardWithError(request, response, "An internal system error occurred. Please try again.", title, category, priority, description);
        }
    }

    /**
     * Runs server-side validations on input parameters.
     */
    private String validateInputs(String title, String category, String priority, String description) {
        if (isEmpty(title) || isEmpty(category) || isEmpty(priority) || isEmpty(description)) {
            return "All fields are required.";
        }
        if (title.length() < 5) {
            return "Title must be at least 5 characters long.";
        }
        if (!VALID_CATEGORIES.contains(category)) {
            return "Please select a valid complaint category.";
        }
        if (!VALID_PRIORITIES.contains(priority)) {
            return "Please select a valid priority level.";
        }
        if (description.length() < 20) {
            return "Description must contain at least 20 characters.";
        }
        return null; // Passes all validation criteria
    }

    /**
     * Forwards request back to raiseComplaint.jsp preserving form parameters and printing errors.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error,
                                  String title, String category, String priority, String description) 
            throws ServletException, IOException {
        
        request.setAttribute("errorMessage", error);
        
        // Preserve values for form pre-fills
        request.setAttribute("title", title);
        request.setAttribute("category", category);
        request.setAttribute("priority", priority);
        request.setAttribute("description", description);

        request.getRequestDispatcher("/student/raiseComplaint.jsp").forward(request, response);
    }

    private boolean isEmpty(String str) {
        return str == null || str.isEmpty();
    }

    private String trimParameter(String param) {
        return param == null ? "" : param.trim();
    }
}
