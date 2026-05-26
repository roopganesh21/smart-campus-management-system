package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * ComplaintLog model class maps to database entries in the 'complaint_logs' table.
 * It tracks status change lifecycles, capturing transitions, modifiers, comments, and audit dates.
 */
public class ComplaintLog implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int complaintId;
    private int changedBy;
    private String changedByName; // Populated by JOIN
    private String oldStatus;
    private String newStatus;
    private String remark;
    private Timestamp changedAt;

    // No-arg constructor
    public ComplaintLog() {}

    // Parameterized constructor
    public ComplaintLog(int id, int complaintId, int changedBy, String changedByName, 
                        String oldStatus, String newStatus, String remark, Timestamp changedAt) {
        this.id = id;
        this.complaintId = complaintId;
        this.changedBy = changedBy;
        this.changedByName = changedByName;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.remark = remark;
        this.changedAt = changedAt;
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

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public String getChangedByName() {
        return changedByName;
    }

    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }

    @Override
    public String toString() {
        return "ComplaintLog{" +
                "id=" + id +
                ", complaintId=" + complaintId +
                ", changedBy=" + changedBy +
                ", changedByName='" + changedByName + '\'' +
                ", oldStatus='" + oldStatus + '\'' +
                ", newStatus='" + newStatus + '\'' +
                ", remark='" + remark + '\'' +
                ", changedAt=" + changedAt +
                '}';
    }
}
