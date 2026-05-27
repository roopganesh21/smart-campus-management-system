# Smart Campus System — Comprehensive Test Case Document

This document contains full details of the comprehensive test suites executed to verify the core operational features of the Smart Campus Complaint and Resource Management System.

---

## Comprehensive Test Cases

### Area 1 — Authentication & Session Management (10 Test Cases)

| Test ID | Module | Description | Preconditions | Test Steps | Expected Result | Status |
| --- | --- | --- | --- | --- | --- | --- |
| AUTH-001 | Auth | Register with valid credentials | User is on the Register page | 1. Fill name, valid unique email, select role (student/worker/admin).<br>2. Fill password >= 8 characters.<br>3. Click Register. | User account is successfully created. User is redirected to `/login` with success banner. | PASS |
| AUTH-002 | Auth | Register with duplicate email | An account with email `test@campus.edu` already exists | 1. Input duplicate email `test@campus.edu` on Register page.<br>2. Fill other registration fields.<br>3. Click Register. | Registration fails. System halts flow and prints clear email collision error. | PASS |
| AUTH-003 | Auth | Register with password < 8 characters | User is on the Register page | 1. Input registration fields.<br>2. Set password to `pwd12` (5 characters).<br>3. Click Register. | Client-side validation blocks submit, or servlet returns error: "Password must be at least 8 characters". | PASS |
| AUTH-004 | Auth | Register with mismatched passwords | User is on the Register page | 1. Fill registration form.<br>2. Input `password123` in Password field.<br>3. Input `password456` in Confirm Password.<br>4. Click Register. | Submit is blocked, or server returns error: "Passwords do not match". | PASS |
| AUTH-005 | Auth | Login with correct student credentials | Student account exists in MySQL | 1. Fill registered student email and password.<br>2. Click Login. | Login succeeds. Session starts. Redirected to `/student/dashboard`. | PASS |
| AUTH-006 | Auth | Login with correct admin credentials | Admin account exists in MySQL | 1. Fill registered admin email and password.<br>2. Click Login. | Login succeeds. Session starts. Redirected to `/admin/dashboard`. | PASS |
| AUTH-007 | Auth | Login with wrong password | Account exists in database | 1. Input correct registered email.<br>2. Input incorrect password.<br>3. Click Login. | Login fails. Servlet prints error: "Invalid email or password". No session started. | PASS |
| AUTH-008 | Auth | Login with non-existent email | Email is not in database | 1. Input non-existent email `unknown@campus.edu`.<br>2. Fill password.<br>3. Click Login. | Login fails. Servlet prints error: "Invalid email or password". | PASS |
| AUTH-009 | Auth | Session timeout redirect simulation | User is logged in to dashboard | 1. Simulate session invalidation by manually clearing the JSESSIONID cookie.<br>2. Refresh page or click dashboard link. | Filter intercepts request, detects invalid session, blocks load, and redirects user to `/login`. | PASS |
| AUTH-010 | Auth | Cross-role authorization bypass attempt | User is logged in as a Student | 1. Directly input URL `http://localhost:8080/smart-campus/admin/dashboard` in browser. | AuthFilter intercepts, registers role violation, invalidates session, blocks render, and redirects to `/login`. | PASS |
| AUTH-011 | Auth | Logout and back-button security | User is logged in | 1. Click Logout button.<br>2. Click browser's Back button. | Logout terminates session. Back button fails to load dashboard; Cache-Control headers force redirect to `/login`. | PASS |

---

### Area 2 — Complaint Lifecycles & Feedbacks (12 Test Cases)

| Test ID | Module | Description | Preconditions | Test Steps | Expected Result | Status |
| --- | --- | --- | --- | --- | --- | --- |
| COMP-001 | Complaints | Submit complaint with valid fields & 3 image files | Student is logged in, on Raise Complaint page | 1. Input valid title, category (hostel), medium priority, and description > 20 characters.<br>2. Attach 3 valid image files (JPG/PNG).<br>3. Click Submit. | Complaint filed. Images sanitized, renamed via UUID, written to uploads directory, and saved in DB. Student redirected with toast. | PASS |
| COMP-002 | Complaints | Submit complaint with no images | Student is logged in, on Raise Complaint page | 1. Fill valid complaint details.<br>2. Leave image input empty.<br>3. Click Submit. | Complaint filed successfully. DB records empty image registries. | PASS |
| COMP-003 | Complaints | Submit complaint with oversized image (> 5MB) | Student is logged in, on Raise Complaint page | 1. Fill valid complaint details.<br>2. Attach image file larger than 5MB.<br>3. Click Submit. | Submit blocked by client validation, or servlet returns error: "File size exceeds the 5MB limit". No write to database. | PASS |
| COMP-004 | Complaints | Submit complaint with invalid file type | Student is logged in, on Raise Complaint page | 1. Fill valid complaint details.<br>2. Attach a `.pdf` file instead of image.<br>3. Click Submit. | System rejects upload. Prints error: "Only image files allowed (jpg, jpeg, png, gif)". | PASS |
| COMP-005 | Complaints | Submit complaint with description < 20 characters | Student is logged in, on Raise Complaint page | 1. Input description of "broken tap" (10 chars).<br>2. Click Submit. | Validation blocks submit, or servlet returns error: "Description must be at least 20 characters". | PASS |
| COMP-006 | Complaints | Admin assigns worker to complaint | Admin is logged in, on Manage Complaints page | 1. Open Manage Complaint modal.<br>2. Select active worker and input completion deadline.<br>3. Click Save changes. | Database updates worker ID and sets status to `assigned`. Worker is notified. | PASS |
| COMP-007 | Complaints | Admin changes priority | Admin is logged in, on Manage Complaints page | 1. Open Manage Complaint modal.<br>2. Select Priority (high) and click Save changes. | Priority is updated in MySQL database. Active row priority badge updates instantly. | PASS |
| COMP-008 | Complaints | Worker updates status to in progress | Worker is logged in, on My Tasks dashboard | 1. Select assigned task.<br>2. Click "Mark In Progress". | Complaint status is updated to `in_progress` in DB. Student is notified. | PASS |
| COMP-009 | Complaints | Worker resolves complaint with remarks & image proof | Worker is logged in, on My Tasks dashboard | 1. Select in-progress task.<br>2. Input resolution remark.<br>3. Attach proof image file.<br>4. Click "Resolve Task". | Status updated to `resolved`. Proof image path saved. Asynchronous notification and HTML email sent to student. | PASS |
| COMP-010 | Complaints | Student views audit timeline | Student is logged in, on Complaint Detail page | 1. Open resolved complaint details. | Interactive timeline displays: pending -> assigned (with worker name) -> in_progress -> resolved (with remarks). | PASS |
| COMP-011 | Complaints | Student submits feedback on resolved complaint | Student is on details page of resolved complaint | 1. Select gold star rating widget (e.g. 5 stars).<br>2. Input feedback comment.<br>3. Click Submit Feedback. | Feedback registered. Avg ratings update. Detail card renders feedback details. | PASS |
| COMP-012 | Complaints | Student tries to submit feedback twice | Student has already submitted feedback | 1. Manually trigger feedback POST request, or inspect UI details card. | Form blocks repeat reviews. Double submissions fail on servlet check. | PASS |

---

### Area 3 — Resource Booking (8 Test Cases)

| Test ID | Module | Description | Preconditions | Test Steps | Expected Result | Status |
| --- | --- | --- | --- | --- | --- | --- |
| BOOK-001 | Booking | Book an available resource | Student is logged in, on Book Resource page | 1. Select Seminar Hall.<br>2. Input valid future date.<br>3. Set time slot: 10:00 AM to 12:00 PM.<br>4. Click Submit. | Booking request logged with status `pending`. Confirmation toast is shown. | PASS |
| BOOK-002 | Booking | Book conflicting slot (same resource, same time) | Booking ID #1 is registered for Seminar Hall on Date X at 10-12 PM | 1. Input Seminar Hall, Date X, 10:00 AM to 12:00 PM.<br>2. Click Submit. | Double-booking conflict detector triggers. Booking is blocked with error: "Resource is already booked during this time". | PASS |
| BOOK-003 | Booking | Admin approves booking request | Admin is logged in, on Manage Bookings page | 1. Select pending booking request.<br>2. Click Approve. | Status updated to `approved` in DB. Student notified of slot reservation. | PASS |
| BOOK-004 | Booking | Admin rejects booking request with remarks | Admin is logged in, on Manage Bookings page | 1. Select pending booking request.<br>2. Input rejection remark.<br>3. Click Reject. | Status updated to `rejected` in DB. Student notified with rejection reasons. | PASS |
| BOOK-005 | Booking | Student views approval notification | Student booking was approved | 1. Student logs in.<br>2. Click bell icon dropdown menu, or inspect My Bookings list. | Notification bell shows active unread badge. Notification displays details. | PASS |
| BOOK-006 | Booking | Try to book a slot in the past | Student is logged in, on Book Resource page | 1. Select Seminar Hall.<br>2. Input date/time in the past.<br>3. Click Submit. | Form validation blocks submit, or servlet returns error: "Cannot book slot in the past". | PASS |
| BOOK-007 | Booking | Book at edge times (8:00 AM / 8:00 PM) | Student is logged in, on Book Resource page | 1. Set time slot start to 8:00 AM, end to 8:00 PM. | Booking succeeds (valid boundary operating times). | PASS |
| BOOK-008 | Booking | Book at invalid boundary times | Student is logged in, on Book Resource page | 1. Set time slot start to 6:00 AM (before operating hours). | Booking is rejected: "Slots must be within operating hours (8:00 AM - 8:00 PM)". | PASS |

---

### Area 4 — Notifications & Client Polling (5 Test Cases)

| Test ID | Module | Description | Preconditions | Test Steps | Expected Result | Status |
| --- | --- | --- | --- | --- | --- | --- |
| NOTIF-001 | Notif | Notification created on complaint status change | Complaint status is updated from assigned to resolved | 1. Worker resolves complaint.<br>2. Verify database entries for student notifications. | New notification row created in `notifications` table containing appropriate ticket messages. | PASS |
| NOTIF-002 | Notif | Notification created when worker assigned | Complaint status is updated to assigned | 1. Admin assigns worker to complaint. | Notification row created for the worker, and another for the student. | PASS |
| NOTIF-003 | Notif | Bell count updates dynamically | User is logged in to portal | 1. Manually trigger notification on backend.<br>2. Wait 30 seconds for notifications.js polling query. | Bell notification badge wiggles and updates unread count dynamically. | PASS |
| NOTIF-004 | Notif | Mark single notification as read | Notification dropdown is open | 1. Click on a specific notification. | System opens related ticket details page. Notification status is updated to read in DB. Count updates. | PASS |
| NOTIF-005 | Notif | Mark all notifications as read | Notification dropdown is open | 1. Click "Mark all read" link. | System executes AJAX request. All notifications marked read. Badge count goes to 0. | PASS |

---

### Area 5 — Document Exports (4 Test Cases)

| Test ID | Module | Description | Preconditions | Test Steps | Expected Result | Status |
| --- | --- | --- | --- | --- | --- | --- |
| EXPR-001 | Export | Export PDF report downloads correctly | Admin is logged in, on Analytics page | 1. Click "Export PDF Report" button. | Browser initiates download of `campus-report.pdf`. Open file: verify bold title, summary metrics, styled bordered grid, and page numbers. | PASS |
| EXPR-002 | Export | Export Excel downloads successfully | Admin is logged in, on Analytics page | 1. Click "Export Excel" button. | Browser downloads `campus-complaints.xlsx`. Open file: verify styled Slate-Gray headers, colored status column, and second KPI tab "Summary". | PASS |
| EXPR-003 | Export | Export with zero complaints | The complaints table is empty | 1. Clear database complaints.<br>2. Click Export PDF / Excel. | Generation succeeds. PDF table renders empty state message. Excel sheet displays only header row. | PASS |
| EXPR-004 | Export | Export with 100+ complaints | 100+ complaints exist in database | 1. Seed database with 150 complaint rows.<br>2. Click Export PDF. | PDF document generated efficiently in under 1.5 seconds. Clean multi-page layouts with page numbers. | PASS |

---

## 10 SQL Verification Queries for MySQL Workbench

These SQL scripts can be run directly inside MySQL Workbench to audit data integrity, ensure foreign key consistency, and verify business constraints across testing phases.

### 1. Detect Orphaned Complaint Images
Finds any image attachments pointing to non-existent complaint IDs.
```sql
SELECT * FROM complaint_images ci
LEFT JOIN complaints c ON ci.complaint_id = c.id
WHERE c.id IS NULL;
```

### 2. Verify Feedback Uniqueness Constraints
Audits the feedback table to identify if any complaint ID has duplicate feedback records (violating the 1:1 business constraint).
```sql
SELECT complaint_id, COUNT(*) as count
FROM feedback
GROUP BY complaint_id
HAVING count > 1;
```

### 3. Check for Orphaned Feedback Entries
Ensures that all feedbacks map to valid complaint records.
```sql
SELECT f.id, f.complaint_id FROM feedback f
LEFT JOIN complaints c ON f.complaint_id = c.id
WHERE c.id IS NULL;
```

### 4. Audit Worker Roles and Department Allocations
Identifies any user with the `worker` role that is missing a department or department metadata.
```sql
SELECT id, name, email FROM users
WHERE role = 'worker' AND (department IS NULL OR department = '');
```

### 5. Locate Overlapping Resource Bookings (Collision Audit)
A sanity check confirming that no concurrent approved resource bookings overlap on the same resource during the same slots.
```sql
SELECT b1.id AS booking1_id, b2.id AS booking2_id, b1.resource_name, b1.booking_date
FROM bookings b1
JOIN bookings b2 ON b1.resource_name = b2.resource_name 
  AND b1.booking_date = b2.booking_date
  AND b1.id < b2.id
WHERE b1.status = 'approved' AND b2.status = 'approved'
  AND ((b1.start_time >= b2.start_time AND b1.start_time < b2.end_time)
   OR  (b1.end_time > b2.start_time AND b1.end_time <= b2.end_time));
```

### 6. Verify Foreign Key Cascade on User Deletion
Check if notifications are orphaned when users are deleted.
```sql
SELECT * FROM notifications n
LEFT JOIN users u ON n.user_id = u.id
WHERE u.id IS NULL;
```

### 7. Audit Resolved Complaints Lacking Updated Timestamps
Identifies any resolved complaints where `updated_at` was not changed during status transitions.
```sql
SELECT id, title FROM complaints
WHERE status = 'resolved' AND (updated_at IS NULL OR updated_at = created_at);
```

### 8. Audit Average Ratings and Feedback Sync
Cross-references Feedback and User tables to find average ratings calculation discrepancies.
```sql
SELECT u.name, AVG(f.rating) AS calc_avg, u.id 
FROM users u
JOIN complaints c ON c.worker_id = u.id
JOIN feedback f ON f.complaint_id = c.id
GROUP BY u.id, u.name;
```

### 9. Verify Notification Target Boundaries
Validates that notifications never contain negative or zero referencing IDs.
```sql
SELECT * FROM notifications
WHERE user_id <= 0 OR related_id <= 0;
```

### 10. Audit Booking Window Boundaries
Finds any bookings scheduled outside standard operational hours (8:00 AM - 8:00 PM).
```sql
SELECT id, start_time, end_time FROM bookings
WHERE TIME(start_time) < '08:00:00' OR TIME(end_time) > '20:00:00';
```
