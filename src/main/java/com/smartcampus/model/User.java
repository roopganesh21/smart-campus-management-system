package com.smartcampus.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * User model class represents entries in the 'users' table.
 * It contains properties for storing account details, role assignments (student, worker, admin),
 * and registration details.
 */
public class User implements Serializable {
    
    private static final long serialVersionUID = 1L;

    // Private fields matching the database schema columns
    private int id;
    private String name;
    private String email;
    private String passwordHash;
    private String role;
    private String department;
    private String phone;
    private String profileImage;
    private boolean isActive;
    private Timestamp createdAt;

    /**
     * Default no-arg constructor required for JavaBeans specification
     * and framework compatibility.
     */
    public User() {
    }

    /**
     * Full constructor initializing all fields of the User entity.
     * 
     * @param id           unique database identifier
     * @param name         full name of the user
     * @param email        unique email address (used as login username)
     * @param passwordHash secure BCrypt password hash string
     * @param role         access role ('student', 'admin', 'worker')
     * @param department   academic or professional department affiliation
     * @param phone        contact telephone number
     * @param profileImage path string for avatar pictures
     * @param isActive     flag indicating account state status
     * @param createdAt    timestamp of user registration
     */
    public User(int id, String name, String email, String passwordHash, String role, 
                String department, String phone, String profileImage, boolean isActive, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.department = department;
        this.phone = phone;
        this.profileImage = profileImage;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // ==========================================
    // GETTERS AND SETTERS
    // ==========================================

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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // ==========================================
    // CONVENIENCE ROLE HELPER METHODS
    // ==========================================

    /**
     * Checks if the user has Administrative privileges.
     * @return true if the role is 'admin'
     */
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }

    /**
     * Checks if the user is registered as a maintenance worker.
     * @return true if the role is 'worker'
     */
    public boolean isWorker() {
        return "worker".equalsIgnoreCase(this.role);
    }

    /**
     * Checks if the user is registered as a student.
     * @return true if the role is 'student'
     */
    public boolean isStudent() {
        return "student".equalsIgnoreCase(this.role);
    }

    // ==========================================
    // TO STRING METHOD FOR SAFE LOGGING
    // ==========================================

    /**
     * Returns a string representation of the User.
     * EXCLUDES the passwordHash field to prevent accidental leakage in console/log traces.
     */
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", department='" + department + '\'' +
                ", phone='" + phone + '\'' +
                ", profileImage='" + profileImage + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}
