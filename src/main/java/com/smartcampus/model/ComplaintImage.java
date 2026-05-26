package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * ComplaintImage model class represents uploaded attachments in the 'complaint_images' table.
 * It links specific file upload paths back to their parent complaints.
 */
public class ComplaintImage implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int complaintId;
    private String imagePath;
    private Timestamp uploadedAt;

    // No-arg constructor
    public ComplaintImage() {}

    // Parameterized constructor
    public ComplaintImage(int id, int complaintId, String imagePath, Timestamp uploadedAt) {
        this.id = id;
        this.complaintId = complaintId;
        this.imagePath = imagePath;
        this.uploadedAt = uploadedAt;
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

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    @Override
    public String toString() {
        return "ComplaintImage{" +
                "id=" + id +
                ", complaintId=" + complaintId +
                ", imagePath='" + imagePath + '\'' +
                ", uploadedAt=" + uploadedAt +
                '}';
    }
}
