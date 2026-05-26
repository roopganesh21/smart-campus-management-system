package com.smartcampus.dao;

import com.smartcampus.model.User;
import com.smartcampus.utility.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * UserDAO implements database queries and operations for the 'users' table.
 * It manages registrations, lookups (by ID and Email), role filters, profile modifications,
 * security updates, deactivations, and dashboard metrics.
 * 
 * Each method obtains an independent connection from DBConnection.getConnection()
 * and guarantees release of all SQL assets in a finally block using DBConnection.close().
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    /**
     * Registers a new user in the database.
     * Note: Password hashing (BCrypt) must be executed in the calling service or servlet layer
     * before passing the User object to this DAO.
     * 
     * @param user User entity containing values to persist, passwordHash must already be hashed.
     * @return true if insertion succeeds, false if email already exists (duplicate key) or failure occurs.
     */
    public boolean registerUser(User user) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO users (name, email, password_hash, role, department, phone, profile_image, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getDepartment());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getProfileImage());
            ps.setInt(8, user.isActive() ? 1 : 0);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                LOGGER.info("User registered successfully: " + user.getEmail());
                return true;
            }
            return false;
        } catch (SQLException e) {
            // MySQL error code 1062 represents DUPLICATE KEY (e.g., unique email violation)
            if (e.getErrorCode() == 1062) {
                LOGGER.log(Level.WARNING, "Registration failed: Email address already registered: " + user.getEmail());
            } else {
                LOGGER.log(Level.SEVERE, "Database error during user registration.", e);
            }
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Retrieves a User entity based on their unique email address (login identifier).
     * 
     * @param email login email address
     * @return Optional containing the User if found, or Optional.empty() if no matches occur
     */
    public Optional<User> getUserByEmail(String email) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM users WHERE email = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                return Optional.of(user);
            }
            return Optional.empty();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error locating user by email: " + email, e);
            return Optional.empty();
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves a User entity based on their auto-incremented primary key.
     * 
     * @param id primary key identifier of the user
     * @return Optional containing the User if found, or Optional.empty() if no matches occur
     */
    public Optional<User> getUserById(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                return Optional.of(user);
            }
            return Optional.empty();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error locating user by ID: " + id, e);
            return Optional.empty();
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all active users registered with the 'worker' role, ordered by name alphabetically.
     * 
     * @return List of active worker Users
     */
    public List<User> getAllWorkers() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> workers = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'worker' AND is_active = 1 ORDER BY name ASC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                workers.add(mapResultSetToUser(rs));
            }
            return workers;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing active workers.", e);
            return workers;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all active users registered with the 'student' role, ordered by name alphabetically.
     * 
     * @return List of active student Users
     */
    public List<User> getAllStudents() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> students = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'student' AND is_active = 1 ORDER BY name ASC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                students.add(mapResultSetToUser(rs));
            }
            return students;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing active students.", e);
            return students;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all active users registered with the 'admin' role, ordered by name alphabetically.
     * 
     * @return List of active admin Users
     */
    public List<User> getAllAdmins() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> admins = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'admin' AND is_active = 1 ORDER BY name ASC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                admins.add(mapResultSetToUser(rs));
            }
            return admins;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing active admins.", e);
            return admins;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Updates mutable profile details for an existing user.
     * Does NOT touch secure email credentials or password hashes to ensure safety.
     * 
     * @param user User object containing updated details
     * @return true if update is successful (rows modified > 0), false otherwise
     */
    public boolean updateUser(User user) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE users SET name = ?, department = ?, phone = ?, profile_image = ?, is_active = ? " +
                     "WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getDepartment());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getProfileImage());
            ps.setInt(5, user.isActive() ? 1 : 0);
            ps.setInt(6, user.getId());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                LOGGER.info("User details updated successfully for ID: " + user.getId());
                return true;
            }
            return false;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating details for user ID: " + user.getId(), e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Updates only the secure password hash value of a user.
     * Used for credentials changes or administrative resets.
     * 
     * @param userId            database key of target user
     * @param newHashedPassword secure BCrypt pre-hashed password string
     * @return true if modification succeeds, false otherwise
     */
    public boolean updatePassword(int userId, String newHashedPassword) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                LOGGER.info("Password hash updated successfully for user ID: " + userId);
                return true;
            }
            return false;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating password hash for user ID: " + userId, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Soft-deactivates an active user profile, locking out login permissions.
     * Retains audit trails by setting is_active = 0 instead of running standard hard SQL deletes.
     * 
     * @param id database key of user profile to suspend
     * @return true if suspension succeeds, false otherwise
     */
    public boolean deactivateUser(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE users SET is_active = 0 WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                LOGGER.info("User soft-deactivated successfully for ID: " + id);
                return true;
            }
            return false;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error soft-deactivating user ID: " + id, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Retrieves the quantitative count of all registered users holding a specific role.
     * Used heavily in administrative dashboards and performance analytics panels.
     * 
     * @param role ENUM filter string ('student', 'admin', 'worker')
     * @return integer total counts of matches, or 0 if exceptions occur
     */
    public int getUserCount(String role) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error retrieving user count for role: " + role, e);
            return 0;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Private mapping utility to read and translate a single SQL row pointer
     * back into a domain User object.
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setDepartment(rs.getString("department"));
        user.setPhone(rs.getString("phone"));
        user.setProfileImage(rs.getString("profile_image"));
        user.setActive(rs.getInt("is_active") == 1);
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
