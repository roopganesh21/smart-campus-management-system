package com.smartcampus.dao;

import com.smartcampus.model.Booking;
import com.smartcampus.utility.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * BookingDAO processes data operations for the 'bookings' table.
 * It manages resource reservations, conflict check lookups, student booking history, 
 * and status updates (approved, rejected).
 */
public class BookingDAO {
    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());

    /**
     * Inserts a new booking record into the database and returns its generated auto-increment primary key ID.
     */
    public int createBooking(Booking b) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet gKeys = null;
        String sql = "INSERT INTO bookings (student_id, resource_id, booking_date, start_time, end_time, purpose, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, b.getStudentId());
            ps.setInt(2, b.getResourceId());
            ps.setDate(3, b.getBookingDate());
            ps.setTime(4, b.getStartTime());
            ps.setTime(5, b.getEndTime());
            ps.setString(6, b.getPurpose());
            ps.setString(7, b.getStatus() != null ? b.getStatus() : "pending");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                gKeys = ps.getGeneratedKeys();
                if (gKeys.next()) {
                    return gKeys.getInt(1);
                }
            }
            return -1;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error creating booking record", e);
            return -1;
        } finally {
            DBConnection.close(null, ps, gKeys);
            DBConnection.close(conn, null, null);
        }
    }

    /**
     * Locates a booking by its primary key ID, joining user name and resource details.
     */
    public Optional<Booking> getBookingById(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT b.*, r.name AS resource_name, r.type AS resource_type, r.location AS resource_location, u.name AS student_name " +
                     "FROM bookings b " +
                     "JOIN resources r ON b.resource_id = r.id " +
                     "JOIN users u ON b.student_id = u.id " +
                     "WHERE b.id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToBooking(rs));
            }
            return Optional.empty();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error loading booking for ID: " + id, e);
            return Optional.empty();
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all bookings submitted by a particular student, joining resource details.
     */
    public List<Booking> getBookingsByStudent(int studentId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, r.name AS resource_name, r.type AS resource_type, r.location AS resource_location, u.name AS student_name " +
                     "FROM bookings b " +
                     "JOIN resources r ON b.resource_id = r.id " +
                     "JOIN users u ON b.student_id = u.id " +
                     "WHERE b.student_id = ? " +
                     "ORDER BY b.booking_date DESC, b.start_time DESC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBooking(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing student bookings for student ID: " + studentId, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all system bookings, joining student name and resource details.
     */
    public List<Booking> getAllBookings() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, r.name AS resource_name, r.type AS resource_type, r.location AS resource_location, u.name AS student_name " +
                     "FROM bookings b " +
                     "JOIN resources r ON b.resource_id = r.id " +
                     "JOIN users u ON b.student_id = u.id " +
                     "ORDER BY b.booking_date DESC, b.start_time DESC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBooking(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing all bookings", e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all pending bookings, sorted chronologically.
     */
    public List<Booking> getPendingBookings() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, r.name AS resource_name, r.type AS resource_type, r.location AS resource_location, u.name AS student_name " +
                     "FROM bookings b " +
                     "JOIN resources r ON b.resource_id = r.id " +
                     "JOIN users u ON b.student_id = u.id " +
                     "WHERE b.status = 'pending' " +
                     "ORDER BY b.booking_date ASC, b.start_time ASC";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBooking(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing pending bookings", e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Modifies the reservation confirmation status and appends optional administration comments.
     */
    public boolean updateBookingStatus(int bookingId, String status, String adminRemark) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE bookings SET status = ?, admin_remark = ? WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, adminRemark);
            ps.setInt(3, bookingId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error modifying booking status for ID: " + bookingId, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Checks if an approved booking already overlaps the requested slot.
     * Returns true if there is conflict, false otherwise.
     */
    public boolean hasConflict(int resourceId, Date date, Time start, Time end) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) AS count FROM bookings " +
                     "WHERE resource_id = ? " +
                     "  AND booking_date = ? " +
                     "  AND status = 'approved' " +
                     "  AND NOT (end_time <= ? OR start_time >= ?)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, resourceId);
            ps.setDate(2, date);
            ps.setTime(3, start);
            ps.setTime(4, end);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            return false;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error validating conflict check for resource ID: " + resourceId, e);
            return true; // Assume conflict on database errors for safety
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Helper mapper translating database records into Booking models.
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setStudentId(rs.getInt("student_id"));
        b.setResourceId(rs.getInt("resource_id"));
        b.setBookingDate(rs.getDate("booking_date"));
        b.setStartTime(rs.getTime("start_time"));
        b.setEndTime(rs.getTime("end_time"));
        b.setPurpose(rs.getString("purpose"));
        b.setStatus(rs.getString("status"));
        b.setAdminRemark(rs.getString("admin_remark"));
        b.setCreatedAt(rs.getTimestamp("created_at"));

        // Join fields
        b.setStudentName(rs.getString("student_name"));
        b.setResourceName(rs.getString("resource_name"));
        b.setResourceType(rs.getString("resource_type"));
        b.setResourceLocation(rs.getString("resource_location"));
        return b;
    }
}
