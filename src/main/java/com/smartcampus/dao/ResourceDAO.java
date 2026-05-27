package com.smartcampus.dao;

import com.smartcampus.model.Resource;
import com.smartcampus.utility.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ResourceDAO performs database actions for the 'resources' table.
 * Operations include adding, modifying, and disabling campus resources (seminar halls, labs, equipment) 
 * as well as tracking their maintenance status.
 */
public class ResourceDAO {
    private static final Logger LOGGER = Logger.getLogger(ResourceDAO.class.getName());

    /**
     * Retrieves all registered resources ordered by type and then by name.
     */
    public List<Resource> getAllResources() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT * FROM resources ORDER BY type, name";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToResource(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error listing all campus resources", e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves a resource by its unique identifier.
     */
    public Optional<Resource> getResourceById(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM resources WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToResource(rs));
            }
            return Optional.empty();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error locating resource for ID: " + id, e);
            return Optional.empty();
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Retrieves all available resources that are status='available' AND do NOT have an
     * approved booking on the same date that overlaps the requested time.
     *
     * TIME OVERLAP SUBQUERY:
     * -------------------------------------------------------------
     * SELECT b.resource_id FROM bookings b 
     * WHERE b.booking_date = ? 
     *   AND b.status = 'approved' 
     *   AND NOT (b.end_time <= ? OR b.start_time >= ?)
     * -------------------------------------------------------------
     */
    public List<Resource> getAvailableResources(Date date, Time startTime, Time endTime) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.* FROM resources r " +
                     "WHERE r.status = 'available' " +
                     "  AND r.id NOT IN ( " +
                     "      SELECT b.resource_id FROM bookings b " +
                     "      WHERE b.booking_date = ? " +
                     "        AND b.status = 'approved' " +
                     "        AND NOT (b.end_time <= ? OR b.start_time >= ?) " +
                     "  ) " +
                     "ORDER BY r.type, r.name";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setDate(1, date);
            ps.setTime(2, startTime);
            ps.setTime(3, endTime);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToResource(rs));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error gathering available resources for date: " + date, e);
            return list;
        } finally {
            DBConnection.close(conn, ps, rs);
        }
    }

    /**
     * Inserts a new resource record.
     */
    public boolean addResource(Resource r) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO resources (name, type, capacity, location, description, status) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, r.getName());
            ps.setString(2, r.getType());
            ps.setInt(3, r.getCapacity());
            ps.setString(4, r.getLocation());
            ps.setString(5, r.getDescription());
            ps.setString(6, r.getStatus());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error registering resource", e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Updates an existing resource record.
     */
    public boolean updateResource(Resource r) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE resources SET name = ?, type = ?, capacity = ?, location = ?, description = ?, status = ? WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, r.getName());
            ps.setString(2, r.getType());
            ps.setInt(3, r.getCapacity());
            ps.setString(4, r.getLocation());
            ps.setString(5, r.getDescription());
            ps.setString(6, r.getStatus());
            ps.setInt(7, r.getId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error updating resource details for ID: " + r.getId(), e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Updates only the availability status of a resource (e.g. maintenance status changes).
     */
    public boolean updateResourceStatus(int id, String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE resources SET status = ? WHERE id = ?";
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error modifying resource status for ID: " + id, e);
            return false;
        } finally {
            DBConnection.close(conn, ps, null);
        }
    }

    /**
     * Helper mapper translating database records into Resource models.
     */
    private Resource mapResultSetToResource(ResultSet rs) throws SQLException {
        Resource r = new Resource();
        r.setId(rs.getInt("id"));
        r.setName(rs.getString("name"));
        r.setType(rs.getString("type"));
        r.setCapacity(rs.getInt("capacity"));
        r.setLocation(rs.getString("location"));
        r.setDescription(rs.getString("description"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
