-- Smart Campus Complaint and Resource Management System
-- Database Schema Script

CREATE DATABASE IF NOT EXISTS smart_campus CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_campus;

-- Drop tables if they exist in reverse order of dependencies
DROP TABLE IF EXISTS complaint_logs;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS resources;
DROP TABLE IF EXISTS complaint_images;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS users;

-- 1. Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'admin', 'worker') NOT NULL DEFAULT 'student',
    department VARCHAR(100),
    phone VARCHAR(15),
    profile_image VARCHAR(255),
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_role (role),
    INDEX idx_user_email (email)
) ENGINE=InnoDB;

-- 2. Complaints Table
CREATE TABLE complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    worker_id INT,
    title VARCHAR(200) NOT NULL,
    category ENUM('hostel', 'classroom', 'electricity', 'water', 'lab', 'other') NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    status ENUM('pending', 'assigned', 'in_progress', 'resolved') DEFAULT 'pending',
    deadline DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_complaint_student FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_complaint_worker FOREIGN KEY (worker_id) REFERENCES users (id) ON DELETE SET NULL,
    INDEX idx_complaint_student (student_id),
    INDEX idx_complaint_worker (worker_id),
    INDEX idx_complaint_status (status),
    INDEX idx_complaint_category (category)
) ENGINE=InnoDB;

-- 3. Complaint Images Table
CREATE TABLE complaint_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    image_path VARCHAR(500) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_image_complaint FOREIGN KEY (complaint_id) REFERENCES complaints (id) ON DELETE CASCADE,
    INDEX idx_image_complaint (complaint_id)
) ENGINE=InnoDB;

-- 4. Resources Table
CREATE TABLE resources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type ENUM('hall', 'lab', 'equipment') NOT NULL,
    capacity INT,
    location VARCHAR(200),
    description TEXT,
    status ENUM('available', 'maintenance') DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_resource_type (type),
    INDEX idx_resource_status (status)
) ENGINE=InnoDB;

-- 5. Bookings Table
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    resource_id INT NOT NULL,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    purpose TEXT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    admin_remark VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_student FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_resource FOREIGN KEY (resource_id) REFERENCES resources (id) ON DELETE CASCADE,
    INDEX idx_booking_student (student_id),
    INDEX idx_booking_resource (resource_id),
    INDEX idx_booking_date (booking_date),
    INDEX idx_booking_status (status)
) ENGINE=InnoDB;

-- 6. Feedback Table
CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL UNIQUE,
    student_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_complaint FOREIGN KEY (complaint_id) REFERENCES complaints (id) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_student FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_feedback_complaint (complaint_id),
    INDEX idx_feedback_student (student_id)
) ENGINE=InnoDB;

-- 7. Notifications Table
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message VARCHAR(500) NOT NULL,
    type ENUM('complaint', 'booking', 'general') DEFAULT 'general',
    related_id INT,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_notification_user (user_id),
    INDEX idx_notification_read (is_read)
) ENGINE=InnoDB;

-- 8. Complaint Logs Table
CREATE TABLE complaint_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    changed_by INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    remark TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_complaint FOREIGN KEY (complaint_id) REFERENCES complaints (id) ON DELETE CASCADE,
    CONSTRAINT fk_log_user FOREIGN KEY (changed_by) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_log_complaint (complaint_id),
    INDEX idx_log_user (changed_by)
) ENGINE=InnoDB;


-- ==========================================
-- TEST DATA INSERTIONS
-- ==========================================

-- 1. Insert Users (Password is 'admin123' hashed using BCrypt)
-- Hash: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa
INSERT INTO users (name, email, password_hash, role, department, phone, profile_image) VALUES
('Super Admin', 'admin1@smartcampus.edu', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa', 'admin', 'Administration', '9876543210', 'admin1.jpg'),
('Co Admin', 'admin2@smartcampus.edu', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa', 'admin', 'Facilities', '9876543211', 'admin2.jpg'),
('John Doe', 'john.student@smartcampus.edu', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa', 'student', 'Computer Science', '9876543212', 'student1.jpg'),
('Jane Smith', 'jane.student@smartcampus.edu', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa', 'student', 'Electrical Engineering', '9876543213', 'student2.jpg'),
('Bob Johnson', 'bob.student@smartcampus.edu', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa', 'student', 'Mechanical Engineering', '9876543214', 'student3.jpg'),
('Dave Carpenter', 'dave.worker@smartcampus.edu', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa', 'worker', 'Carpentry', '9876543215', 'worker1.jpg'),
('Elsa Spark', 'elsa.worker@smartcampus.edu', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LPVKKlyWAFa', 'worker', 'Electrical', '9876543216', 'worker2.jpg');

-- 2. Insert Resources
INSERT INTO resources (name, type, capacity, location, description, status) VALUES
('Main Seminar Hall', 'hall', 150, 'Administrative Block, 2nd Floor', 'Spacious seminar hall equipped with modern projector and sound system.', 'available'),
('Auditorium B', 'hall', 80, 'Science Block, Ground Floor', 'Perfect for small events and guest lectures.', 'available'),
('IoT Lab', 'lab', 40, 'IT Block, 3rd Floor', 'Advanced laboratory for internet-of-things projects and testing.', 'available'),
('High-Resolution DSLR Camera', 'equipment', 1, 'Media Center, Room 104', 'Professional Nikon DSLR camera for official department shoots.', 'available');

-- 3. Insert Complaints
INSERT INTO complaints (student_id, worker_id, title, category, description, priority, status, deadline) VALUES
(3, NULL, 'Broken Chair in LH-201', 'classroom', 'One of the writing desks has a broken chair and needs immediate repairs.', 'low', 'pending', NULL),
(3, 6, 'Hostel Room Fan Not Working', 'hostel', 'The ceiling fan in room 302 of Hostel Block A makes excessive noise and does not rotate at high speed.', 'medium', 'assigned', '2026-06-01'),
(4, 7, 'Short Circuit in Physics Lab', 'electricity', 'Power outlets on bench 4 of the lab are sparking and showing signs of short circuit.', 'high', 'in_progress', '2026-05-28'),
(5, 6, 'Leaking Pipe under Water Cooler', 'water', 'Water is pooling around the ground floor water cooler due to a leaking supply pipe.', 'medium', 'resolved', '2026-05-25'),
(4, NULL, 'Projector Not Projecting in CR-12', 'classroom', 'Projector turns on but displays no signal even when connected correctly.', 'medium', 'pending', NULL);

-- 4. Insert Complaint Images
INSERT INTO complaint_images (complaint_id, image_path) VALUES
(2, 'uploads/complaints/fan_issue.jpg'),
(4, 'uploads/complaints/leaky_pipe.jpg');

-- 5. Insert Feedback for Resolved Complaint
INSERT INTO feedback (complaint_id, student_id, rating, comment) VALUES
(4, 5, 5, 'Dave fixed the leaking pipe very quickly and cleaned up the area afterwards. Excellent work!');

-- 6. Insert Notifications
INSERT INTO notifications (user_id, message, type, related_id, is_read) VALUES
(3, 'Your complaint "Broken Chair in LH-201" has been registered.', 'complaint', 1, 0),
(3, 'Your complaint "Hostel Room Fan Not Working" has been assigned to Dave Carpenter.', 'complaint', 2, 0),
(6, 'You have been assigned a new complaint: "Hostel Room Fan Not Working".', 'complaint', 2, 1),
(5, 'Your complaint "Leaking Pipe under Water Cooler" has been resolved.', 'complaint', 4, 1),
(5, 'Please provide feedback for complaint "Leaking Pipe under Water Cooler".', 'complaint', 4, 0);

-- 7. Insert Complaint Logs
INSERT INTO complaint_logs (complaint_id, changed_by, old_status, new_status, remark) VALUES
(2, 1, 'pending', 'assigned', 'Assigned to Dave Carpenter for immediate carpentry inspection.'),
(3, 1, 'pending', 'assigned', 'Assigned to Elsa Spark due to electrical electrical safety risks.'),
(3, 7, 'assigned', 'in_progress', 'Investigating power outlets; spare sockets ordered.'),
(4, 1, 'pending', 'assigned', 'Assigned to Dave Carpenter.'),
(4, 6, 'assigned', 'in_progress', 'Replacing the main copper elbow pipe.'),
(4, 6, 'in_progress', 'resolved', 'Replaced leaking copper pipeline and secured connection fittings.');

SELECT 'campus.sql executed successfully' AS status;
