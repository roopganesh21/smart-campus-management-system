package com.smartcampus.controller;

import com.smartcampus.dao.ComplaintDAO;
import com.smartcampus.dao.FeedbackDAO;
import com.smartcampus.model.Complaint;
import com.smartcampus.model.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * FeedbackServlet processes satisfaction ratings and textual reviews submitted by students
 * after a complaint is resolved, mapping to Feedback DAO.
 * 
 * NOTE: Mapped in web.xml to prevent Tomcat namespace duplicate annotation collisions.
 */
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(FeedbackServlet.class.getName());

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirection block: feedback forms are directly embedded inside complaintDetail.jsp
        response.sendRedirect(request.getContextPath() + "/student/trackComplaints");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthenticated POST attempt to FeedbackServlet.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");

        try {
            String complaintIdStr = request.getParameter("complaintId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (complaintIdStr == null || ratingStr == null) {
                LOGGER.warning("Feedback submission rejected: Missing required fields.");
                response.sendRedirect(request.getContextPath() + "/student/trackComplaints");
                return;
            }

            int complaintId = Integer.parseInt(complaintIdStr);
            int rating = Integer.parseInt(ratingStr);
            comment = comment != null ? comment.trim() : "";

            // 1. Security check: verify complaint owner & resolved status
            Optional<Complaint> compOpt = complaintDAO.getComplaintById(complaintId);
            if (compOpt.isEmpty()) {
                LOGGER.warning("Feedback rejected: Complaint not found ID: " + complaintId);
                response.sendRedirect(request.getContextPath() + "/student/trackComplaints");
                return;
            }

            Complaint complaint = compOpt.get();
            if (complaint.getStudentId() != studentId) {
                LOGGER.severe(String.format("Security violation: Student %d tried to review complaint owned by student %d", 
                        studentId, complaint.getStudentId()));
                response.sendRedirect(request.getContextPath() + "/student/trackComplaints");
                return;
            }

            if (!"resolved".equalsIgnoreCase(complaint.getStatus())) {
                LOGGER.warning(String.format("Feedback rejected: Complaint %d is not resolved.", complaintId));
                response.sendRedirect(request.getContextPath() + "/student/complaintDetail?id=" + complaintId);
                return;
            }

            // 2. Prevent Double Submissions: Verify no feedback exists yet
            Feedback existingFeedback = feedbackDAO.getFeedbackByComplaintId(complaintId);
            if (existingFeedback != null) {
                LOGGER.warning("Feedback rejected: Review already submitted for complaint: " + complaintId);
                response.sendRedirect(request.getContextPath() + "/student/complaintDetail?id=" + complaintId + "&error=feedback_exists");
                return;
            }

            // 3. Create and populate Feedback entity
            Feedback feedback = new Feedback();
            feedback.setComplaintId(complaintId);
            feedback.setStudentId(studentId);
            feedback.setRating(rating);
            feedback.setComment(comment);

            // 4. Save to Database
            boolean success = feedbackDAO.submitFeedback(feedback);
            if (success) {
                LOGGER.info("Feedback successfully submitted for complaint: " + complaintId);
                response.sendRedirect(request.getContextPath() + "/student/complaintDetail?id=" + complaintId + "&feedbackSubmitted=true");
            } else {
                LOGGER.severe("Failed to insert feedback in database.");
                response.sendRedirect(request.getContextPath() + "/student/complaintDetail?id=" + complaintId + "&error=db_failure");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error submitting student feedback", e);
            response.sendRedirect(request.getContextPath() + "/student/trackComplaints");
        }
    }
}
