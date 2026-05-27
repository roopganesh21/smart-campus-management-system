package com.smartcampus.controller;

import com.smartcampus.dao.BookingDAO;
import com.smartcampus.dao.ResourceDAO;
import com.smartcampus.dao.UserDAO;
import com.smartcampus.dao.NotificationDAO;
import com.smartcampus.model.Booking;
import com.smartcampus.model.Resource;
import com.smartcampus.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * BookingServlet handles booking requests for campus resources (e.g., seminar halls, labs, equipment).
 * It processes student requests, checks resource availability, and allows admins to approve/reject bookings.
 * 
 * NOTE: Mapped in web.xml, so we omit @WebServlet here to prevent namespace duplicate collisions in Tomcat.
 */
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());

    private final BookingDAO bookingDAO = new BookingDAO();
    private final ResourceDAO resourceDAO = new ResourceDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthenticated GET attempt to BookingServlet. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String studentRole = (String) session.getAttribute("userRole");
        String servletPath = request.getServletPath();
        LOGGER.info(String.format("BookingServlet doGet - Path: %s, Role: %s", servletPath, studentRole));

        if ("/student/bookResource".equals(servletPath)) {
            if (!"student".equalsIgnoreCase(studentRole)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Students only.");
                return;
            }

            int studentId = (Integer) session.getAttribute("userId");
            
            // 1. Fetch all resources
            List<Resource> resources = resourceDAO.getAllResources();
            
            // 2. Count student's active bookings
            List<Booking> bookings = bookingDAO.getBookingsByStudent(studentId);
            int activeBookingsCount = 0;
            for (Booking b : bookings) {
                if (b.isActive()) {
                    activeBookingsCount++;
                }
            }

            request.setAttribute("resources", resources);
            request.setAttribute("activeBookingsCount", activeBookingsCount);

            LOGGER.info("Forwarding to /WEB-INF/student/bookResource.jsp");
            request.getRequestDispatcher("/WEB-INF/student/bookResource.jsp").forward(request, response);

        } else if ("/student/myBookings".equals(servletPath)) {
            if (!"student".equalsIgnoreCase(studentRole)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Students only.");
                return;
            }

            int studentId = (Integer) session.getAttribute("userId");
            List<Booking> bookings = bookingDAO.getBookingsByStudent(studentId);

            request.setAttribute("bookings", bookings);

            LOGGER.info("Forwarding to /WEB-INF/student/myBookings.jsp");
            request.getRequestDispatcher("/WEB-INF/student/myBookings.jsp").forward(request, response);

        } else if ("/admin/manageBookings".equals(servletPath)) {
            if (!"admin".equalsIgnoreCase(studentRole)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Administrators only.");
                return;
            }

            List<Booking> bookings = bookingDAO.getAllBookings();
            request.setAttribute("bookings", bookings);

            LOGGER.info("Forwarding to /WEB-INF/admin/manageBookings.jsp");
            request.getRequestDispatcher("/WEB-INF/admin/manageBookings.jsp").forward(request, response);

        } else if ("/student/checkAvailability".equals(servletPath)) {
            if (!"student".equalsIgnoreCase(studentRole)) {
                sendJsonResponse(response, false, "Access Denied.");
                return;
            }

            try {
                String resourceIdStr = request.getParameter("resourceId");
                String dateStr = request.getParameter("date");
                String startStr = request.getParameter("start");
                String endStr = request.getParameter("end");

                if (resourceIdStr == null || dateStr == null || startStr == null || endStr == null) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"available\":false, \"message\":\"Missing parameters.\"}");
                    return;
                }

                int resourceId = Integer.parseInt(resourceIdStr);
                Date date = Date.valueOf(dateStr);
                Time start = Time.valueOf(startStr);
                Time end = Time.valueOf(endStr);

                boolean conflict = bookingDAO.hasConflict(resourceId, date, start, end);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(String.format("{\"available\":%b}", !conflict));

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error checking resource availability", e);
                response.setContentType("application/json");
                response.getWriter().write("{\"available\":false, \"message\":\"Internal server parsing error.\"}");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthenticated POST attempt to BookingServlet.");
            sendJsonResponse(response, false, "Session expired or unauthorized.");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        String servletPath = request.getServletPath();
        LOGGER.info(String.format("BookingServlet doPost - Path: %s, Role: %s", servletPath, userRole));

        if ("/student/book".equals(servletPath)) {
            if (!"student".equalsIgnoreCase(userRole)) {
                sendJsonResponse(response, false, "Access denied: Students only.");
                return;
            }

            int studentId = (Integer) session.getAttribute("userId");

            try {
                String resourceIdStr = request.getParameter("resourceId");
                String dateStr = request.getParameter("bookingDate");
                String startStr = request.getParameter("startTime");
                String endStr = request.getParameter("endTime");
                String purpose = request.getParameter("purpose");

                if (resourceIdStr == null || dateStr == null || startStr == null || endStr == null || purpose == null) {
                    sendJsonResponse(response, false, "Missing required booking details.");
                    return;
                }

                int resourceId = Integer.parseInt(resourceIdStr);
                Date date = Date.valueOf(dateStr);
                Time start = Time.valueOf(startStr);
                Time end = Time.valueOf(endStr);
                purpose = purpose.trim();

                // Server-side validation
                if (purpose.length() < 20) {
                    sendJsonResponse(response, false, "Booking purpose must be at least 20 characters long.");
                    return;
                }

                if (!start.before(end)) {
                    sendJsonResponse(response, false, "Booking start time must be strictly before end time.");
                    return;
                }

                // Check dates boundaries (allow today or future dates)
                Date today = new Date(System.currentTimeMillis() - 24 * 60 * 60 * 1000L);
                if (date.before(today)) {
                    sendJsonResponse(response, false, "Booking date cannot be in the past.");
                    return;
                }

                // Double check conflicts for strict transaction safety
                boolean conflict = bookingDAO.hasConflict(resourceId, date, start, end);
                if (conflict) {
                    sendJsonResponse(response, false, "Conflict detected: This slot is already reserved by another request.");
                    return;
                }

                // Populate and create booking
                Booking b = new Booking();
                b.setStudentId(studentId);
                b.setResourceId(resourceId);
                b.setBookingDate(date);
                b.setStartTime(start);
                b.setEndTime(end);
                b.setPurpose(purpose);
                b.setStatus("pending");

                int bookingId = bookingDAO.createBooking(b);
                if (bookingId > 0) {
                    // Create notification for all admins
                    List<User> admins = userDAO.getAllAdmins();
                    for (User admin : admins) {
                        notificationDAO.createNotification(
                            admin.getId(),
                            "New booking request #" + bookingId + " pending review.",
                            "booking",
                            bookingId
                        );
                    }

                    sendJsonResponse(response, true, "Booking request successfully submitted.");
                } else {
                    sendJsonResponse(response, false, "Database error: Failed to submit booking request.");
                }

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error creating booking request", e);
                sendJsonResponse(response, false, "Server error: " + e.getMessage());
            }

        } else if ("/admin/approveBooking".equals(servletPath)) {
            if (!"admin".equalsIgnoreCase(userRole)) {
                sendJsonResponse(response, false, "Access denied: Administrators only.");
                return;
            }

            try {
                String bookingIdStr = request.getParameter("bookingId");
                String remark = request.getParameter("adminRemark");

                if (bookingIdStr == null) {
                    sendJsonResponse(response, false, "Missing booking reference.");
                    return;
                }

                int bookingId = Integer.parseInt(bookingIdStr);
                Optional<Booking> bookingOpt = bookingDAO.getBookingById(bookingId);

                if (bookingOpt.isEmpty()) {
                    sendJsonResponse(response, false, "Booking request not found.");
                    return;
                }

                Booking booking = bookingOpt.get();
                boolean success = bookingDAO.updateBookingStatus(bookingId, "approved", remark != null ? remark.trim() : "Approved by administrator");
                
                if (success) {
                    // Notify student
                    notificationDAO.createNotification(
                        booking.getStudentId(),
                        "Your booking request #" + bookingId + " for '" + booking.getResourceName() + "' has been APPROVED.",
                        "booking",
                        bookingId
                    );

                    sendJsonResponse(response, true, "Booking request successfully approved.");
                } else {
                    sendJsonResponse(response, false, "Failed to update booking status in database.");
                }

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error approving booking", e);
                sendJsonResponse(response, false, "Server error: " + e.getMessage());
            }

        } else if ("/admin/rejectBooking".equals(servletPath)) {
            if (!"admin".equalsIgnoreCase(userRole)) {
                sendJsonResponse(response, false, "Access denied: Administrators only.");
                return;
            }

            try {
                String bookingIdStr = request.getParameter("bookingId");
                String remark = request.getParameter("adminRemark");

                if (bookingIdStr == null) {
                    sendJsonResponse(response, false, "Missing booking reference.");
                    return;
                }

                int bookingId = Integer.parseInt(bookingIdStr);
                Optional<Booking> bookingOpt = bookingDAO.getBookingById(bookingId);

                if (bookingOpt.isEmpty()) {
                    sendJsonResponse(response, false, "Booking request not found.");
                    return;
                }

                Booking booking = bookingOpt.get();
                boolean success = bookingDAO.updateBookingStatus(bookingId, "rejected", remark != null ? remark.trim() : "Rejected by administrator");
                
                if (success) {
                    // Notify student
                    notificationDAO.createNotification(
                        booking.getStudentId(),
                        "Your booking request #" + bookingId + " for '" + booking.getResourceName() + "' has been REJECTED. Remark: " + remark,
                        "booking",
                        bookingId
                    );

                    sendJsonResponse(response, true, "Booking request successfully rejected.");
                } else {
                    sendJsonResponse(response, false, "Failed to update booking status in database.");
                }

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error rejecting booking", e);
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
