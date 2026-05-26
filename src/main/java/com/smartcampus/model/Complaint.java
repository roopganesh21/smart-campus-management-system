package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Complaint model class represents records in the 'complaints' table.
 * It tracks issue details, classification category, assignment details (student and worker), 
 * priority, status state, and processing deadlines.
 */
public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int studentId;
    private Integer workerId; // Nullable, mapped to Integer
    private String title;
    private String category;
    private String description;
    private String priority;
    private String status;
    private Date deadline;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Not a DB column — populated by JOIN
    private String studentName;
    private String workerName;

    // Default No-Arg Constructor
    public Complaint() {}

    // Full Parameterized Constructor
    public Complaint(int id, int studentId, Integer workerId, String title, String category, 
                     String description, String priority, String status, Date deadline, 
                     Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.studentId = studentId;
        this.workerId = workerId;
        this.title = title;
        this.category = category;
        this.description = description;
        this.priority = priority;
        this.status = status;
        this.deadline = deadline;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
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

    public Integer getWorkerId() {
        return workerId;
    }

    public void setWorkerId(Integer workerId) {
        this.workerId = workerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getWorkerName() {
        return workerName;
    }

    public void setWorkerName(String workerName) {
        this.workerName = workerName;
    }

    /**
     * Helper check evaluating if the complaint resolution has exceeded its deadline.
     * Returns true if deadline is not null AND deadline is strictly before today AND status != "resolved".
     */
    public boolean isOverdue() {
        if (deadline == null || "resolved".equalsIgnoreCase(status)) {
            return false;
        }
        Date today = new Date(System.currentTimeMillis());
        return deadline.before(today);
    }

    @Override
    public String toString() {
        return "Complaint{" +
                "id=" + id +
                ", studentId=" + studentId +
                ", workerId=" + workerId +
                ", title='" + title + '\'' +
                ", category='" + category + '\'' +
                ", priority='" + priority + '\'' +
                ", status='" + status + '\'' +
                ", deadline=" + deadline +
                ", studentName='" + studentName + '\'' +
                ", workerName='" + workerName + '\'' +
                '}';
    }
}
