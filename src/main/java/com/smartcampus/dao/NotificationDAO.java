package com.smartcampus.dao;

import com.smartcampus.utility.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * NotificationDAO performs data queries for the 'notifications' table.
 * Operations include adding alerts for individual users, fetching active alerts, and marking notices as read.
 */
public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    /**
     * Creates and stores a new notification in the database.
     * 
     * @param userId target user ID
     * @param message notification message text
     * @param type ENUM type ('complaint', 'booking', 'general')
     * @param relatedId nullable related identifier
     * @return true if insertion succeeds, false otherwise
     */
    public boolean createNotification(int userId, String message, String type, Integer relatedId) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO notifications (user_id, message, type, related_id, is_read) VALUES (?, ?, ?, ?, 0)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.setString(3, type);
            if (relatedId != null) {
                ps.setInt(4, relatedId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error creating notification for user ID: " + userId, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }
}
