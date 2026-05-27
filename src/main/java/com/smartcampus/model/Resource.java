package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Resource model class represents rows in the 'resources' table.
 * It contains properties for storing resource availability details (e.g., halls, equipment, labs), capacities, 
 * and scheduling properties.
 */
public class Resource implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String type; // 'hall', 'lab', 'equipment'
    private int capacity;
    private String location;
    private String description;
    private String status; // 'available', 'maintenance'
    private Timestamp createdAt;

    public Resource() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Resource{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", capacity=" + capacity +
                ", location='" + location + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
