package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;

/**
 * Booking model class represents records in the 'bookings' table.
 * It tracks student reservations, booking date and times, reservation purposes, status confirmations, 
 * and optional administration feedback messages.
 */
public class Booking implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int studentId;
    private int resourceId;
    private Date bookingDate;
    private Time startTime;
    private Time endTime;
    private String purpose;
    private String status; // 'pending', 'approved', 'rejected'
    private String adminRemark;
    private Timestamp createdAt;

    // // Not a DB column — populated by JOIN
    private String studentName;
    private String resourceName;
    private String resourceType;
    private String resourceLocation;

    public Booking() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getResourceId() {
        return resourceId;
    }

    public void setResourceId(int resourceId) {
        this.resourceId = resourceId;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminRemark() {
        return adminRemark;
    }

    public void setAdminRemark(String adminRemark) {
        this.adminRemark = adminRemark;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Joined fields getters and setters
    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getResourceName() {
        return resourceName;
    }

    public void setResourceName(String resourceName) {
        this.resourceName = resourceName;
    }

    public String getResourceType() {
        return resourceType;
    }

    public void setResourceType(String resourceType) {
        this.resourceType = resourceType;
    }

    public String getResourceLocation() {
        return resourceLocation;
    }

    public void setResourceLocation(String resourceLocation) {
        this.resourceLocation = resourceLocation;
    }

    /**
     * Evaluates if the booking is currently active.
     * Returns true if status is 'approved' AND booking date is today or in the future.
     */
    public boolean isActive() {
        if (!"approved".equalsIgnoreCase(status)) {
            return false;
        }
        if (bookingDate == null) {
            return false;
        }
        LocalDate booking = bookingDate.toLocalDate();
        LocalDate today = LocalDate.now();
        return !booking.isBefore(today);
    }

    @Override
    public String toString() {
        return "Booking{" +
                "id=" + id +
                ", studentId=" + studentId +
                ", resourceId=" + resourceId +
                ", bookingDate=" + bookingDate +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", status='" + status + '\'' +
                ", resourceName='" + resourceName + '\'' +
                '}';
    }
}
