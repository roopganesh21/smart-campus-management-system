package com.smartcampus.dao;

import com.smartcampus.model.Complaint;
import com.smartcampus.model.ComplaintImage;
import com.smartcampus.model.ComplaintLog;
import com.smartcampus.utility.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ComplaintDAO handles database queries and operations for the 'complaints', 
 * 'complaint_images', and 'complaint_logs' tables.
 * This includes filing complaints, assigning workers, logging status transitions, and listing complaints based on roles.
 */
public class ComplaintDAO {

    private static final Logger LOGGER = Logger.getLogger(ComplaintDAO.class.getName());

    /**
     * -- SQL Query:
     * -- INSERT INTO complaints (student_id, title, category, description, priority, status)
     * -- VALUES (?, ?, ?, ?, ?, ?)
     * 
     * Registers a new student complaint in the system and returns the generated primary key.
     */
    public int createComplaint(Complaint complaint) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "INSERT INTO complaints (student_id, title, category, description, priority, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, complaint.getStudentId());
            ps.setString(2, complaint.getTitle());
            ps.setString(3, complaint.getCategory());
            ps.setString(4, complaint.getDescription());
            ps.setString(5, complaint.getPriority() != null ? complaint.getPriority() : "medium");
            ps.setString(6, complaint.getStatus() != null ? complaint.getStatus() : "pending");

            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int generatedId = rs.getInt(1);
                LOGGER.info("Complaint created successfully with ID: " + generatedId);
                return generatedId;
            }
            return -1;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during complaint registration.", e);
            return -1;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT c.*, s.name AS student_name, w.name AS worker_name 
     * -- FROM complaints c 
     * -- JOIN users s ON c.student_id = s.id 
     * -- LEFT JOIN users w ON c.worker_id = w.id 
     * -- WHERE c.id = ?
     * 
     * Retrieves a single complaint details by primary key, joining names to prevent N+1 queries.
     */
    public Optional<Complaint> getComplaintById(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT c.*, s.name AS student_name, w.name AS worker_name " +
                     "FROM complaints c " +
                     "JOIN users s ON c.student_id = s.id " +
                     "LEFT JOIN users w ON c.worker_id = w.id " +
                     "WHERE c.id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToComplaint(rs));
            }
            return Optional.empty();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error locating complaint by ID: " + id, e);
            return Optional.empty();
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT c.*, s.name AS student_name, w.name AS worker_name 
     * -- FROM complaints c 
     * -- JOIN users s ON c.student_id = s.id 
     * -- LEFT JOIN users w ON c.worker_id = w.id 
     * -- WHERE c.student_id = ? 
     * -- ORDER BY c.created_at DESC
     * 
     * Lists all complaints filed by a particular student, ordered from newest to oldest.
     */
    public List<Complaint> getComplaintsByStudentId(int studentId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name AS student_name, w.name AS worker_name " +
                     "FROM complaints c " +
                     "JOIN users s ON c.student_id = s.id " +
                     "LEFT JOIN users w ON c.worker_id = w.id " +
                     "WHERE c.student_id = ? " +
                     "ORDER BY c.created_at DESC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing student complaints for ID: " + studentId, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT c.*, s.name AS student_name, w.name AS worker_name 
     * -- FROM complaints c 
     * -- JOIN users s ON c.student_id = s.id 
     * -- LEFT JOIN users w ON c.worker_id = w.id 
     * -- ORDER BY c.created_at DESC
     * 
     * Retrieves all system-wide complaints for the administrative control panel.
     */
    public List<Complaint> getAllComplaints() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name AS student_name, w.name AS worker_name " +
                     "FROM complaints c " +
                     "JOIN users s ON c.student_id = s.id " +
                     "LEFT JOIN users w ON c.worker_id = w.id " +
                     "ORDER BY c.created_at DESC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing all system complaints.", e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT c.*, s.name AS student_name, w.name AS worker_name 
     * -- FROM complaints c 
     * -- JOIN users s ON c.student_id = s.id 
     * -- LEFT JOIN users w ON c.worker_id = w.id 
     * -- WHERE c.status = ? 
     * -- ORDER BY c.created_at DESC
     * 
     * Filters complaints across the system matching a specific status lifecycle state.
     */
    public List<Complaint> getComplaintsByStatus(String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name AS student_name, w.name AS worker_name " +
                     "FROM complaints c " +
                     "JOIN users s ON c.student_id = s.id " +
                     "LEFT JOIN users w ON c.worker_id = w.id " +
                     "WHERE c.status = ? " +
                     "ORDER BY c.created_at DESC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing complaints by status: " + status, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT c.*, s.name AS student_name, w.name AS worker_name 
     * -- FROM complaints c 
     * -- JOIN users s ON c.student_id = s.id 
     * -- LEFT JOIN users w ON c.worker_id = w.id 
     * -- WHERE c.worker_id = ? 
     * -- ORDER BY c.created_at DESC
     * 
     * Retrieves complaints assigned to a specific maintenance worker.
     */
    public List<Complaint> getComplaintsByWorker(int workerId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.name AS student_name, w.name AS worker_name " +
                     "FROM complaints c " +
                     "JOIN users s ON c.student_id = s.id " +
                     "LEFT JOIN users w ON c.worker_id = w.id " +
                     "WHERE c.worker_id = ? " +
                     "ORDER BY c.created_at DESC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, workerId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing worker complaints for ID: " + workerId, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT * FROM complaint_images WHERE complaint_id = ? ORDER BY uploaded_at ASC
     * 
     * Locates all image path attachments linked to a particular complaint record.
     */
    public List<ComplaintImage> getImagesByComplaintId(int complaintId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<ComplaintImage> list = new ArrayList<>();
        String sql = "SELECT * FROM complaint_images WHERE complaint_id = ? ORDER BY uploaded_at ASC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ComplaintImage img = new ComplaintImage();
                img.setId(rs.getInt("id"));
                img.setComplaintId(rs.getInt("complaint_id"));
                img.setImagePath(rs.getString("image_path"));
                img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(img);
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error fetching images for complaint ID: " + complaintId, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT l.*, u.name AS changed_by_name 
     * -- FROM complaint_logs l 
     * -- JOIN users u ON l.changed_by = u.id 
     * -- WHERE l.complaint_id = ? 
     * -- ORDER BY l.changed_at ASC
     * 
     * Fetches audit status transition logs mapped for a complaint, joining user modifier names.
     */
    public List<ComplaintLog> getLogsByComplaintId(int complaintId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<ComplaintLog> list = new ArrayList<>();
        String sql = "SELECT l.*, u.name AS changed_by_name " +
                     "FROM complaint_logs l " +
                     "JOIN users u ON l.changed_by = u.id " +
                     "WHERE l.complaint_id = ? " +
                     "ORDER BY l.changed_at ASC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ComplaintLog log = new ComplaintLog();
                log.setId(rs.getInt("id"));
                log.setComplaintId(rs.getInt("complaint_id"));
                log.setChangedBy(rs.getInt("changed_by"));
                log.setChangedByName(rs.getString("changed_by_name"));
                log.setOldStatus(rs.getString("old_status"));
                log.setNewStatus(rs.getString("new_status"));
                log.setRemark(rs.getString("remark"));
                log.setChangedAt(rs.getTimestamp("changed_at"));
                list.add(log);
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error loading logs for complaint ID: " + complaintId, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- INSERT INTO complaint_images (complaint_id, image_path) VALUES (?, ?)
     * 
     * Attaches a new image record to an existing complaint.
     */
    public boolean addComplaintImage(int complaintId, String imagePath) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO complaint_images (complaint_id, image_path) VALUES (?, ?)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            ps.setString(2, imagePath);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error adding complaint image path.", e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * -- SQL Query 1 (Inside transaction):
     * -- SELECT status FROM complaints WHERE id = ?
     * -- SQL Query 2 (Inside transaction):
     * -- UPDATE complaints SET status = ?, updated_at = NOW() WHERE id = ?
     * -- SQL Query 3 (Inside transaction):
     * -- INSERT INTO complaint_logs (complaint_id, changed_by, old_status, new_status, remark) 
     * -- VALUES (?, ?, ?, ?, ?)
     * 
     * Atomically executes status changes and audit log entries inside a single MySQL transaction.
     */
    public boolean updateComplaintStatus(int complaintId, String newStatus, String remark, int changedBy) {
        Connection conn = null;
        PreparedStatement selectPs = null;
        PreparedStatement updatePs = null;
        PreparedStatement logPs = null;
        ResultSet rs = null;
        
        String selectSql = "SELECT status FROM complaints WHERE id = ?";
        String updateSql = "UPDATE complaints SET status = ?, updated_at = NOW() WHERE id = ?";
        String logSql = "INSERT INTO complaint_logs (complaint_id, changed_by, old_status, new_status, remark) " +
                       "VALUES (?, ?, ?, ?, ?)";
        try {
            conn = DBConnection.getConnection();
            // Start transaction
            conn.setAutoCommit(false);

            // 1. Fetch current status to set as oldStatus
            String oldStatus = null;
            selectPs = conn.prepareStatement(selectSql);
            selectPs.setInt(1, complaintId);
            rs = selectPs.executeQuery();
            if (rs.next()) {
                oldStatus = rs.getString("status");
            } else {
                LOGGER.warning("Could not update complaint status: Record ID not found: " + complaintId);
                conn.rollback();
                return false;
            }

            // 2. Perform Complaint Table Update
            updatePs = conn.prepareStatement(updateSql);
            updatePs.setString(1, newStatus);
            updatePs.setInt(2, complaintId);
            int rowsUpdated = updatePs.executeUpdate();
            if (rowsUpdated <= 0) {
                conn.rollback();
                return false;
            }

            // 3. Create Audit Log Record
            logPs = conn.prepareStatement(logSql);
            logPs.setInt(1, complaintId);
            logPs.setInt(2, changedBy);
            logPs.setString(3, oldStatus);
            logPs.setString(4, newStatus);
            logPs.setString(5, remark);
            logPs.executeUpdate();

            // Commit atomic transaction
            conn.commit();
            LOGGER.info("Successfully updated status to " + newStatus + " for complaint: " + complaintId);
            
            // Trigger asynchronous email alert to student
            triggerComplaintStatusEmail(complaintId, newStatus, remark);
            
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating complaint status. Rolling back transaction.", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Failed to rollback transaction.", ex);
                }
            }
            return false;
        } finally {
            // Restore autocommit state and release resources safely
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error restoring autocommit state.", ex);
                }
            }
            DBConnection.close(null, selectPs, rs);
            DBConnection.close(null, updatePs, null);
            DBConnection.close(conn, logPs, null);
        }
    }

    /**
     * -- SQL Query 1 (Inside transaction):
     * -- SELECT status FROM complaints WHERE id = ?
     * -- SQL Query 2 (Inside transaction):
     * -- UPDATE complaints SET worker_id = ?, deadline = ?, status = 'assigned', updated_at = NOW() 
     * -- WHERE id = ?
     * -- SQL Query 3 (Inside transaction):
     * -- INSERT INTO complaint_logs (complaint_id, changed_by, old_status, new_status, remark) 
     * -- VALUES (?, ?, ?, 'assigned', ?)
     * 
    /**
     * Updates only the priority of a complaint.
     */
    public boolean updateComplaintPriority(int complaintId, String priority) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE complaints SET priority = ?, updated_at = NOW() WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, priority);
            ps.setInt(2, complaintId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating priority for complaint ID: " + complaintId, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Atomically executes worker assignment, deadline settings, status upgrades, and audit logs.
     */
    public boolean assignWorker(int complaintId, int workerId, Date deadline) {
        Connection conn = null;
        PreparedStatement selectPs = null;
        PreparedStatement updatePs = null;
        PreparedStatement logPs = null;
        ResultSet rs = null;

        String selectSql = "SELECT status FROM complaints WHERE id = ?";
        String updateSql = "UPDATE complaints SET worker_id = ?, deadline = ?, status = 'assigned', updated_at = NOW() " +
                           "WHERE id = ?";
        String logSql = "INSERT INTO complaint_logs (complaint_id, changed_by, old_status, new_status, remark) " +
                       "VALUES (?, ?, ?, 'assigned', ?)";
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Fetch current status
            String oldStatus = null;
            selectPs = conn.prepareStatement(selectSql);
            selectPs.setInt(1, complaintId);
            rs = selectPs.executeQuery();
            if (rs.next()) {
                oldStatus = rs.getString("status");
            } else {
                LOGGER.warning("Could not assign worker: Record ID not found: " + complaintId);
                conn.rollback();
                return false;
            }

            // 2. Perform Complaint Table Worker & Deadline & Status Updates
            updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, workerId);
            psSetNullableDate(updatePs, 2, deadline);
            updatePs.setInt(3, complaintId);
            int rowsUpdated = updatePs.executeUpdate();
            if (rowsUpdated <= 0) {
                conn.rollback();
                return false;
            }

            // 3. Find administrative user for the log changed_by (Seed Super Admin is ID 1)
            int adminId = 1;

            // 4. Create Audit Log Record
            logPs = conn.prepareStatement(logSql);
            logPs.setInt(1, complaintId);
            logPs.setInt(2, adminId);
            logPs.setString(3, oldStatus);
            logPs.setString(4, "Worker assigned. Deadline scheduled: " + (deadline != null ? deadline.toString() : "Not specified"));
            logPs.executeUpdate();

            conn.commit();
            LOGGER.info("Successfully assigned worker " + workerId + " to complaint " + complaintId);
            
            // Trigger asynchronous email alert to student
            triggerComplaintStatusEmail(complaintId, "assigned", "A campus service worker has been assigned to address your complaint.");
            
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error assigning worker. Rolling back transaction.", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Failed to rollback transaction.", ex);
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error restoring autocommit state.", ex);
                }
            }
            DBConnection.close(null, selectPs, rs);
            DBConnection.close(null, updatePs, null);
            DBConnection.close(conn, logPs, null);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT status, COUNT(*) FROM complaints GROUP BY status
     * 
     * Compiles quantitative totals of all complaints categorized by status for dashboards.
     */
    public Map<String, Integer> getComplaintStats() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        // Initialize map with default zeros to prevent frontend NPEs
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("pending", 0);
        stats.put("assigned", 0);
        stats.put("in_progress", 0);
        stats.put("resolved", 0);

        String sql = "SELECT status, COUNT(*) AS count FROM complaints GROUP BY status";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            int total = 0;
            while (rs.next()) {
                String status = rs.getString("status").toLowerCase();
                int count = rs.getInt("count");
                stats.put(status, count);
                total += count;
            }
            stats.put("total", total);
            return stats;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error retrieving complaint stats metrics.", e);
            return stats;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT category, COUNT(*) FROM complaints GROUP BY category
     * 
     * Summarizes counts per classification category, mapped for Chart.js graphing.
     */
    public Map<String, Integer> getComplaintsByCategory() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT category, COUNT(*) AS count FROM complaints GROUP BY category ORDER BY count DESC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("category"), rs.getInt("count"));
            }
            return map;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error gathering category distributions.", e);
            return map;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * -- SQL Query:
     * -- SELECT DATE_FORMAT(created_at, '%b %Y') AS month_name, 
     * --        COUNT(*) AS complaint_count, 
     * --        MIN(created_at) AS sort_date 
     * -- FROM complaints 
     * -- WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? MONTH) 
     * -- GROUP BY DATE_FORMAT(created_at, '%b %Y') 
     * -- ORDER BY sort_date ASC
     * 
     * Builds a chronological history of registered complaints for trend graphing charts.
     */
    public List<Map<String, Object>> getMonthlyComplaintTrend(int months) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String, Object>> trend = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(created_at, '%b %Y') AS month_name, " +
                     "COUNT(*) AS complaint_count, " +
                     "MIN(created_at) AS sort_date " +
                     "FROM complaints " +
                     "WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? MONTH) " +
                     "GROUP BY DATE_FORMAT(created_at, '%b %Y') " +
                     "ORDER BY sort_date ASC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, months);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("month", rs.getString("month_name"));
                data.put("count", rs.getInt("complaint_count"));
                trend.add(data);
            }
            return trend;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error building monthly trend counts.", e);
            return trend;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Private mapping utility translating a ResultSet row into a domain Complaint entity.
     */
    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getInt("id"));
        c.setStudentId(rs.getInt("student_id"));
        
        int workerIdVal = rs.getInt("worker_id");
        if (rs.wasNull()) {
            c.setWorkerId(null);
        } else {
            c.setWorkerId(workerIdVal);
        }
        
        c.setTitle(rs.getString("title"));
        c.setCategory(rs.getString("category"));
        c.setDescription(rs.getString("description"));
        c.setPriority(rs.getString("priority"));
        c.setStatus(rs.getString("status"));
        c.setDeadline(rs.getDate("deadline"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Load Joined columns (mapped conditionally from the queries)
        try {
            c.setStudentName(rs.getString("student_name"));
        } catch (SQLException e) {
            // Column may not be present in selective queries
        }
        try {
            c.setWorkerName(rs.getString("worker_name"));
        } catch (SQLException e) {
            // Column may not be present in selective queries
        }
        
        return c;
    }

    /**
     * Safely assigns nullable SQL Date parameters.
     */
    private void psSetNullableDate(PreparedStatement ps, int paramIndex, Date date) throws SQLException {
        if (date == null) {
            ps.setNull(paramIndex, java.sql.Types.DATE);
        } else {
            ps.setDate(paramIndex, date);
        }
    }

    /**
     * Localized helper method to resolve the student's email, name, and complaint title, 
     * then trigger a beautifully formatted asynchronous SMTP status update email.
     */
    private void triggerComplaintStatusEmail(int complaintId, String newStatus, String remark) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT u.email, u.name AS student_name, c.title, w.name AS worker_name " +
                     "FROM complaints c " +
                     "JOIN users u ON c.student_id = u.id " +
                     "LEFT JOIN users w ON c.worker_id = w.id " +
                     "WHERE c.id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            if (rs.next()) {
                String toEmail = rs.getString("email");
                String studentName = rs.getString("student_name");
                String title = rs.getString("title");
                String workerName = rs.getString("worker_name");
                
                String subject = "Complaint Status Update - Ticket #" + complaintId;
                String htmlBody = com.smartcampus.utility.EmailUtil.buildStatusUpdateEmail(
                    studentName, title, newStatus, workerName, remark
                );
                
                com.smartcampus.utility.EmailUtil.sendEmailAsync(toEmail, subject, htmlBody);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to resolve and trigger status update email for complaint " + complaintId, e);
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }
}
