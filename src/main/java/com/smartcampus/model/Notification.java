package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Notification model class represents data entries in the 'notifications' table.
 * It carries user alerts, category tags, foreign links, and display flag states (read/unread).
 */
public class Notification implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String message;
    private String type; // 'complaint', 'booking', 'general'
    private Integer relatedId;
    private boolean isRead;
    private Timestamp createdAt;

    public Notification() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Integer relatedId) {
        this.relatedId = relatedId;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Notification{" +
                "id=" + id +
                ", userId=" + userId +
                ", type='" + type + '\'' +
                ", isRead=" + isRead +
                '}';
    }
}
