package com.smartcampus.dao;

import com.smartcampus.model.Feedback;
import com.smartcampus.utility.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * FeedbackDAO executes database queries targeting the 'feedback' table.
 * It manages filing feedback reviews for resolved complaints and retrieving statistics of average ratings.
 */
public class FeedbackDAO {

    private static final Logger LOGGER = Logger.getLogger(FeedbackDAO.class.getName());

    /**
     * Retrieves feedback details associated with a specific complaint ID.
     * 
     * @param complaintId target complaint ID
     * @return Feedback entity if exists, null otherwise
     */
    public Feedback getFeedbackByComplaintId(int complaintId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM feedback WHERE complaint_id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("id"));
                feedback.setComplaintId(rs.getInt("complaint_id"));
                feedback.setStudentId(rs.getInt("student_id"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setComment(rs.getString("comment"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));
                return feedback;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error retrieving feedback for complaint ID: " + complaintId, e);
        } finally {
            DBConnection.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * Adds a new feedback record for a resolved complaint.
     * 
     * @param feedback feedback entry containing rating and comment
     * @return true if insertion succeeds, false otherwise
     */
    public boolean addFeedback(Feedback feedback) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO feedback (complaint_id, student_id, rating, comment) VALUES (?, ?, ?, ?)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, feedback.getComplaintId());
            ps.setInt(2, feedback.getStudentId());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error adding feedback for complaint ID: " + feedback.getComplaintId(), e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }
}
