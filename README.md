# Smart Campus Complaint & Resource Management System

[![Java Version](https://img.shields.io/badge/Java-17-oracle.svg?style=flat-square&logo=java&logoColor=white&color=007396)](https://www.oracle.com/java/)
[![Build Tool](https://img.shields.io/badge/Maven-3.8%2B-blue.svg?style=flat-square&logo=apache-maven&logoColor=white&color=C71A36)](https://maven.apache.org/)
[![Database](https://img.shields.io/badge/MySQL-8.0-blue.svg?style=flat-square&logo=mysql&logoColor=white&color=4479A1)](https://www.mysql.com/)
[![Application Server](https://img.shields.io/badge/Tomcat-10.1-orange.svg?style=flat-square&logo=apache-tomcat&logoColor=white&color=F8DC75)](https://tomcat.apache.org/)
[![Styling UI](https://img.shields.io/badge/Bootstrap-5.3-blue.svg?style=flat-square&logo=bootstrap&logoColor=white&color=7952B3)](https://getbootstrap.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square&color=green)](LICENSE)

An enterprise-grade, secure, and modern web application designed for higher education institutions. The portal streamlines the reporting, assignment, and resolution of campus maintenance grievances while providing conflict-free real-time facility scheduling for seminar halls, computer labs, and academic equipment. By utilizing role-based access control, transaction audits, and automated notifications, the system eliminates manual paper trail friction and enhances operational efficiency on campus.

---

## Technical Mockups & User Interfaces

Below are placeholder references for key views across the portal:
* **Student Dashboard & Ticket Form:** Responsive metrics, unread notification bells, and multipart media attachments.
* **Worker Tasks Panel:** Direct access to category tickets, status controls (In Progress / Resolved), and remark logging.
* **Admin Analytics Panel:** Resolution rate dials, Chart.js resolution time bar charts, and category radar grids.
* **Facility Booking Panel:** Dynamic calendar grids with conflict alerts and operating time limits.

---

## Core Technical Features

- [x] **Secure Session Administration:** BCrypt one-way password hashing and pre-login session invalidation protection.
- [x] **Global Filter Security:** WebFilter (`AuthFilter.java`) validating role privileges, blocking URL access bypasses, and injecting clickjacking protection.
- [x] **Dynamic Media Uploading:** Commons FileUpload processing files, checking file size boundaries (max 5MB), and performing physical MIME double-checks.
- [x] **Conflict-Free Facility Booking:** SQL overlapping window queries blocking double-bookings and operational time restrictions.
- [x] **Asynchronous Alerts:** Dynamic client polling for unread notifications and background SMTP HTML email notifications.
- [x] **Analytical Graphics:** Resolution ratios, monthly trends, and categories workload metrics rendered using Chart.js.
- [x] **One-Click Document Export:** Generation of professional reports in PDF (via iText 5) and styled multi-sheet spreadsheet files (via Apache POI).

---

## Directory Structure & Folder Layout

The project follows a standard Maven web application structure:

```text
Campus-Complaint-and-Resource-Management-System/
├── database/
│   └── campus.sql                       # Database schema and initial tables seed
├── docs/
│   ├── project-report.md                # Comprehensive 7-chapter academic project report
│   ├── test-cases.md                    # Comprehensive 39 test cases and verification queries
│   └── security-audit.md                # 8-point manual security review and fixes report
├── pom.xml                              # Maven project dependency configuration
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── smartcampus/
        │           ├── controller/      # Jakarta Servlets and AuthFilter routing
        │           ├── dao/             # Data Access Objects (parameterized JDBC transactions)
        │           ├── model/           # POJO Data Models (User, Complaint, Booking, etc.)
        │           └── utility/         # Encryption, File IO, and SMTP Email Utilities
        └── webapp/
            ├── css/                     # Styling custom sheets
            ├── js/                      # Dynamic AJAX javascripts
            ├── WEB-INF/                 # Enclosed configuration directory (Browser-Protected)
            │   ├── admin/               # Administrative JSP dashboards
            │   ├── student/             # Student tracking and booking JSPs
            │   ├── worker/              # Technician JSP dashboards
            │   ├── db.properties        # Database connection pool config [GIT-IGNORED]
            │   ├── db.properties.template
            │   ├── mail.properties      # SMTP credentials and parameters [GIT-IGNORED]
            │   ├── mail.properties.template
            │   └── web.xml              # Deployment Descriptor (Filters, Context Listeners)
            ├── login.jsp                # Central Authentication UI
            └── register.jsp             # User registration form UI
```

---

## Developer Prerequisites

Before installing the application, ensure you have the following resources configured:
* **Java Development Kit (JDK):** Version 17
* **Build Tool:** Apache Maven 3.8+
* **Database Server:** MySQL Community Server 8.0 (running on default port 3306 or custom port 3307)
* **Application Container:** Apache Tomcat 10.1 (supporting Jakarta EE 10 specifications)

---

## Step-by-Step Installation & Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/roopganesh21/smart-campus-management-system.git
cd smart-campus-management-system
```

### 2. Configure Database Schema
Start your MySQL command line or MySQL Workbench and run:
```sql
CREATE DATABASE smart_campus;
USE smart_campus;
SOURCE database/campus.sql;
```

### 3. Setup Configuration Properties
1. Navigate to the `src/main/webapp/WEB-INF/` folder.
2. Copy `db.properties.template` to create `db.properties`:
   ```bash
   cp src/main/webapp/WEB-INF/db.properties.template src/main/webapp/WEB-INF/db.properties
   ```
   Open `db.properties` and enter your MySQL host, port, username, and password.
3. Copy `mail.properties.template` to create `mail.properties`:
   ```bash
   cp src/main/webapp/WEB-INF/mail.properties.template src/main/webapp/WEB-INF/mail.properties
   ```
   Open `mail.properties` and add your Gmail account and **Gmail App Password**.

### 4. Build and Compile Package
Execute the Maven build script to compile dependencies and assemble the deployment `.war` package:
```bash
mvn clean package
```
This will generate `smart-campus.war` in the `target/` directory.

### 5. Deploy on Apache Tomcat 10
1. Copy the compiled `target/smart-campus.war` file.
2. Paste it into the `webapps/` folder of your local Apache Tomcat 10 installation directory.
3. Start the Tomcat application server using `bin/startup.bat` (Windows) or `bin/startup.sh` (Linux/Mac).

### 6. Access the Application Portal
Open your web browser and navigate to:
```text
http://localhost:8080/smart-campus/login
```

---

## Default Role Login Credentials

The SQL database seeding scripts configure the following pre-registered administrative, technician, and student credentials:

| Role | Default Username (Email) | Default Password | Department Allocation |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin1@campus.edu` | `admin123` | Campus General Operations |
| **Maintenance Worker** | `worker1@campus.edu` | `worker123` | Hostel Maintenance |
| **Maintenance Worker** | `worker2@campus.edu` | `worker123` | Classroom Maintenance |
| **Student** | `student1@campus.edu` | `student123` | Computer Science |

---

## Contributing & Development

Contributions are welcome! Please follow these steps to propose improvements:
1. Fork the Project Repository.
2. Create a Feature Branch (`git checkout -b feature/NewSecuredAudit`).
3. Commit your changes (`git commit -m "Add new dynamic scheduling locks"`).
4. Push to the Branch (`git push origin feature/NewSecuredAudit`).
5. Open a Pull Request.

---

## License

Distributed under the **MIT License**. See `LICENSE` for more information.
