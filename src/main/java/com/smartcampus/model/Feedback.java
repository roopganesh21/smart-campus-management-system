package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Feedback model class represents student feedback entries in the 'feedback' table.
 * It encapsulates individual complaint rating metrics and commentary logs.
 */
public class Feedback implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int complaintId;
    private int studentId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    // Constructors
    public Feedback() {}

    public Feedback(int complaintId, int studentId, int rating, String comment) {
        this.complaintId = complaintId;
        this.studentId = studentId;
        this.rating = rating;
        this.comment = comment;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", complaintId=" + complaintId +
                ", studentId=" + studentId +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
