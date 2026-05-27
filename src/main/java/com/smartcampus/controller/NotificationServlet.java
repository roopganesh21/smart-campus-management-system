package com.smartcampus.controller;

import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.model.Notification;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * NotificationServlet manages system notifications for users.
 * It will handle fetching notifications via AJAX (for real-time dashboard updates) and marking notifications as read.
 * 
 * NOTE: Mapped in web.xml, so we omit @WebServlet here to prevent duplicate container mapping conflicts.
 */
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(NotificationServlet.class.getName());

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            sendJsonResponse(response, "{\"error\": \"Unauthorized session.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        LOGGER.info(String.format("NotificationServlet doGet action: %s for user: %d", action, userId));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if ("count".equalsIgnoreCase(action)) {
            int unreadCount = notificationDAO.getUnreadCount(userId);
            response.getWriter().write(String.format("{\"unread\": %d}", unreadCount));
        } else if ("list".equalsIgnoreCase(action)) {
            // Retrieve recent 15 notifications
            List<Notification> list = notificationDAO.getNotificationsForUser(userId, 15);
            String json = convertNotificationsToJson(list);
            response.getWriter().write(json);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid action query.\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            sendJsonResponse(response, "{\"success\": false, \"message\": \"Unauthorized session.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        LOGGER.info(String.format("NotificationServlet doPost action: %s for user: %d", action, userId));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if ("markRead".equalsIgnoreCase(action)) {
            try {
                String idStr = request.getParameter("id");
                if (idStr == null) {
                    sendJsonResponse(response, "{\"success\": false, \"message\": \"Missing notification reference.\"}");
                    return;
                }
                int notificationId = Integer.parseInt(idStr);
                boolean success = notificationDAO.markAsRead(notificationId, userId);
                sendJsonResponse(response, String.format("{\"success\": %b}", success));
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error marking notification as read", e);
                sendJsonResponse(response, "{\"success\": false, \"message\": \"Internal server error.\"}");
            }
        } else if ("markAll".equalsIgnoreCase(action)) {
            boolean success = notificationDAO.markAllAsRead(userId);
            sendJsonResponse(response, String.format("{\"success\": %b}", success));
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonResponse(response, "{\"success\": false, \"message\": \"Invalid action parameter.\"}");
        }
    }

    /**
     * Helper to send exact JSON string payloads.
     */
    private void sendJsonResponse(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }

    /**
     * Converts List of Notification models into a JSON string manually.
     */
    private String convertNotificationsToJson(List<Notification> list) {
        if (list == null || list.isEmpty()) {
            return "[]";
        }
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        boolean first = true;
        for (Notification n : list) {
            if (!first) {
                sb.append(",");
            }
            String relativeTime = convertToRelativeTime(n.getCreatedAt().getTime());
            sb.append("{")
              .append("\"id\":").append(n.getId()).append(",")
              .append("\"message\":\"").append(escapeJson(n.getMessage())).append("\",")
              .append("\"type\":\"").append(escapeJson(n.getType())).append("\",")
              .append("\"relatedId\":").append(n.getRelatedId() != null ? n.getRelatedId() : "null").append(",")
              .append("\"isRead\":").append(n.isRead()).append(",")
              .append("\"createdAt\":\"").append(escapeJson(relativeTime)).append("\"")
              .append("}");
            first = false;
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * Formats database Timestamp millisecond values into human relative strings.
     */
    private String convertToRelativeTime(long timestampMs) {
        long now = System.currentTimeMillis();
        long diff = now - timestampMs;
        if (diff < 0) {
            return "Just now";
        }
        long diffSeconds = diff / 1000;
        if (diffSeconds < 60) {
            return "Just now";
        }
        long diffMinutes = diffSeconds / 60;
        if (diffMinutes < 60) {
            return diffMinutes + " minute" + (diffMinutes > 1 ? "s" : "") + " ago";
        }
        long diffHours = diffMinutes / 60;
        if (diffHours < 24) {
            return diffHours + " hour" + (diffHours > 1 ? "s" : "") + " ago";
        }
        long diffDays = diffHours / 24;
        if (diffDays == 1) {
            return "Yesterday";
        }
        if (diffDays < 7) {
            return diffDays + " day" + (diffDays > 1 ? "s" : "") + " ago";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
        return sdf.format(new java.util.Date(timestampMs));
    }

    /**
     * Escapes standard JSON text parameters.
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
