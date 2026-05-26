package com.smartcampus.controller;

import com.smartcampus.dao.ComplaintDAO;
import com.smartcampus.dao.UserDAO;
import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.model.Complaint;
import com.smartcampus.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AdminServlet manages administrative tasks such as user moderation, resource allocation, 
 * assigning complaints to workers, and accessing system-wide metrics.
 */
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminServlet.class.getName());

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
            LOGGER.warning("Unauthorized GET attempt to AdminServlet.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        LOGGER.info("AdminServlet doGet received PathInfo: " + pathInfo);
        
        if (pathInfo == null || "/".equals(pathInfo) || "/dashboard".equals(pathInfo)) {
            LOGGER.info("Fetching admin dashboard analytics metrics...");
            
            // 1. Fetch data from DAOs
            Map<String, Integer> stats = complaintDAO.getComplaintStats();
            Map<String, Integer> categoryCounts = complaintDAO.getComplaintsByCategory();
            List<Map<String, Object>> monthlyTrend = complaintDAO.getMonthlyComplaintTrend(6);
            int workerCount = userDAO.getUserCount("worker");
            
            List<Complaint> allComplaints = complaintDAO.getAllComplaints();
            List<Complaint> recentComplaints = allComplaints.subList(0, Math.min(10, allComplaints.size()));

            // 2. Perform manual JSON string conversion for Chart.js variables in JSP
            String statusCountsJson = convertMapToJson(stats);
            String categoryCountsJson = convertMapToJson(categoryCounts);
            String monthlyTrendJson = convertTrendListToJson(monthlyTrend);

            // 3. Set attributes for JSTL and JS rendering
            request.setAttribute("stats", stats);
            request.setAttribute("statusCountsJson", statusCountsJson);
            request.setAttribute("categoryCountsJson", categoryCountsJson);
            request.setAttribute("monthlyTrendJson", monthlyTrendJson);
            request.setAttribute("workerCount", workerCount);
            request.setAttribute("recentComplaints", recentComplaints);

            LOGGER.info("Successfully bound dashboard variables. Forwarding to /WEB-INF/admin/dashboard.jsp");
            request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
        } else if ("/manageComplaints".equals(pathInfo)) {
            LOGGER.info("Fetching complaints and workers list...");
            List<Complaint> complaints = complaintDAO.getAllComplaints();
            List<User> workers = userDAO.getAllWorkers();
            
            request.setAttribute("complaints", complaints);
            request.setAttribute("workerList", workers);
            
            LOGGER.info("Forwarding to /WEB-INF/admin/manageComplaints.jsp");
            request.getRequestDispatcher("/WEB-INF/admin/manageComplaints.jsp").forward(request, response);
        } else {
            LOGGER.warning("PathInfo '" + pathInfo + "' did not match any GET handler!");
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
            LOGGER.warning("Unauthorized POST attempt to AdminServlet.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized admin access.");
            return;
        }

        int adminId = (Integer) session.getAttribute("userId");
        String pathInfo = request.getPathInfo();
        LOGGER.info("AdminServlet doPost received PathInfo: " + pathInfo);

        if ("/assignWorker".equals(pathInfo)) {
            // Read JSON body manually from request
            StringBuilder buffer = new StringBuilder();
            String line;
            java.io.BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
            }
            String body = buffer.toString();
            LOGGER.info("Received assignWorker request body: " + body);

            try {
                // Parse JSON manually using String search operations
                String complaintIdStr = extractJsonValue(body, "complaintId");
                String workerIdStr = extractJsonValue(body, "workerId");
                String deadline = extractJsonValue(body, "deadline");
                String priority = extractJsonValue(body, "priority");
                String newStatus = extractJsonValue(body, "newStatus");
                String remark = extractJsonValue(body, "remark");

                if (complaintIdStr == null || newStatus == null) {
                    sendJsonResponse(response, false, "Missing required parameters.");
                    return;
                }

                int complaintId = Integer.parseInt(complaintIdStr);
                Optional<Complaint> compOpt = complaintDAO.getComplaintById(complaintId);
                if (compOpt.isEmpty()) {
                    sendJsonResponse(response, false, "Complaint not found.");
                    return;
                }
                Complaint comp = compOpt.get();

                // 1. Update Priority if changed
                if (priority != null && !priority.isEmpty()) {
                    complaintDAO.updateComplaintPriority(complaintId, priority);
                }

                // 2. Perform Worker Assignment inside the DAO transaction if workerId is provided
                boolean assignSuccess = true;
                Integer parsedWorkerId = null;
                if (workerIdStr != null && !workerIdStr.isEmpty() && !"null".equalsIgnoreCase(workerIdStr)) {
                    int workerId = Integer.parseInt(workerIdStr);
                    parsedWorkerId = workerId;
                    java.sql.Date sqlDate = null;
                    if (deadline != null && !deadline.isEmpty()) {
                        sqlDate = java.sql.Date.valueOf(deadline);
                    }
                    assignSuccess = complaintDAO.assignWorker(complaintId, workerId, sqlDate);
                }

                // 3. Update Status and Remark log inside the DAO transaction
                boolean statusSuccess = complaintDAO.updateComplaintStatus(complaintId, newStatus, remark, adminId);

                if (assignSuccess && statusSuccess) {
                    // 4. Create Notifications for worker and student
                    if (parsedWorkerId != null) {
                        notificationDAO.createNotification(
                            parsedWorkerId, 
                            "You have been assigned complaint #" + complaintId + ": " + comp.getTitle(), 
                            "complaint", 
                            complaintId
                        );
                    }
                    notificationDAO.createNotification(
                        comp.getStudentId(), 
                        "Your complaint #" + complaintId + " status updated to " + newStatus, 
                        "complaint", 
                        complaintId
                    );

                    sendJsonResponse(response, true, "Updated successfully");
                } else {
                    sendJsonResponse(response, false, "Failed to update database records.");
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error in assignWorker API", e);
                sendJsonResponse(response, false, "Server error: " + e.getMessage());
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Manually extracts string values for small JSON payloads.
     * 
     * WHY: Manually parsing JSON via String indexing is chosen to avoid adding heavy runtime libraries. 
     * For larger enterprise environments, incorporating industry standards like Gson or Jackson is 
     * strongly recommended because they support full schema validation, type safety, nesting, 
     * complex serialization, and prevent vulnerabilities.
     */
    private String extractJsonValue(String json, String key) {
        int keyIndex = json.indexOf("\"" + key + "\"");
        if (keyIndex == -1) return null;
        
        int colonIndex = json.indexOf(":", keyIndex);
        if (colonIndex == -1) return null;
        
        int startVal = colonIndex + 1;
        while (startVal < json.length() && Character.isWhitespace(json.charAt(startVal))) {
            startVal++;
        }
        
        if (startVal >= json.length()) return null;
        
        if (json.charAt(startVal) == '"') {
            int endVal = json.indexOf('"', startVal + 1);
            if (endVal == -1) return null;
            return json.substring(startVal + 1, endVal);
        } else {
            int endVal = startVal;
            while (endVal < json.length() && json.charAt(endVal) != ',' && json.charAt(endVal) != '}' && !Character.isWhitespace(json.charAt(endVal))) {
                endVal++;
            }
            String rawVal = json.substring(startVal, endVal).trim();
            if ("null".equalsIgnoreCase(rawVal)) {
                return null;
            }
            return rawVal;
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.format("{\"success\":%b, \"message\":\"%s\"}", success, message));
    }

    /**
     * Converts a Java Map<String, Integer> into a standard JSON object string.
     * 
     * WHY: Manually building JSON via StringBuilder avoids adding heavy runtime library 
     * dependencies like Gson or Jackson. For enterprise development, Gson/Jackson are 
     * strongly recommended due to type safety, recursive serialization, and safety against 
     * injection vulnerabilities.
     */
    private String convertMapToJson(Map<String, Integer> map) {
        if (map == null || map.isEmpty()) {
            return "{}";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        boolean first = true;
        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            if (!first) {
                sb.append(",");
            }
            sb.append("\"").append(escapeJson(entry.getKey())).append("\":").append(entry.getValue());
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }

    /**
     * Converts a Java List of Map<String, Object> (monthly trends) into a JSON array string.
     */
    private String convertTrendListToJson(List<Map<String, Object>> list) {
        if (list == null || list.isEmpty()) {
            return "[]";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        boolean firstObj = true;
        for (Map<String, Object> map : list) {
            if (!firstObj) {
                sb.append(",");
            }
            sb.append("{");
            boolean firstKey = true;
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                if (!firstKey) {
                    sb.append(",");
                }
                sb.append("\"").append(escapeJson(entry.getKey())).append("\":");
                Object val = entry.getValue();
                if (val instanceof Number) {
                    sb.append(val);
                } else {
                    sb.append("\"").append(escapeJson(val.toString())).append("\"");
                }
                firstKey = false;
            }
            sb.append("}");
            firstObj = false;
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * Escapes critical characters for standard-compliant JSON structures.
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
