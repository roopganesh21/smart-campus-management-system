package com.smartcampus.dao;

import com.smartcampus.model.Notification;
import com.smartcampus.utility.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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



    /**
     * Inserts notifications for ALL active users with the given role.
     */
    public boolean createNotificationsForRole(String role, String message, String type, int relatedId) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO notifications (user_id, message, type, related_id, is_read) " +
                     "SELECT id, ?, ?, ?, 0 FROM users WHERE role = ? AND is_active = 1";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, message);
            ps.setString(2, type);
            ps.setInt(3, relatedId);
            ps.setString(4, role);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error creating batch notifications for role: " + role, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Retrieves recent notifications for a user up to a specified limit, ordered by creation date descending.
     */
    public List<Notification> getNotificationsForUser(int userId, int limit) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setId(rs.getInt("id"));
                n.setUserId(rs.getInt("user_id"));
                n.setMessage(rs.getString("message"));
                n.setType(rs.getString("type"));
                
                int relId = rs.getInt("related_id");
                n.setRelatedId(rs.wasNull() ? null : relId);
                
                n.setRead(rs.getInt("is_read") == 1);
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error retrieving notifications list for user ID: " + userId, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Fetches count of unread notifications for a user.
     */
    public int getUnreadCount(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS count FROM notifications WHERE user_id = ? AND is_read = 0";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error loading unread notifications count for user ID: " + userId, e);
            return 0;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Marks a specific notification as read. Validates userId for security verification.
     */
    public boolean markAsRead(int notificationId, int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error marking notification as read for ID: " + notificationId, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Marks all unread notifications of a user as read.
     */
    public boolean markAllAsRead(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error marking all notifications as read for user ID: " + userId, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }
}
