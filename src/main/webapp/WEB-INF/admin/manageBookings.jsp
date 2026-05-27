<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DataTables Bootstrap 5 CSS -->
    <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
            min-height: 100vh;
        }
        .sidebar {
            background-color: #0f172a;
            color: #94a3b8;
            min-height: 100vh;
            border-right: 1px solid #1e293b;
        }
        .sidebar-brand {
            font-weight: 700;
            color: #ffffff !important;
            font-size: 1.25rem;
            letter-spacing: -0.5px;
        }
        .sidebar-link {
            color: #94a3b8;
            text-decoration: none;
            padding: 0.75rem 1.25rem;
            display: flex;
            align-items: center;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.2s ease;
            margin-bottom: 0.25rem;
        }
        .sidebar-link:hover {
            color: #ffffff;
            background-color: #1e293b;
        }
        .sidebar-link.active {
            color: #ffffff;
            background-color: #4f46e5;
        }
        .sidebar-link svg {
            margin-right: 0.75rem;
            opacity: 0.8;
        }
        .main-content {
            padding: 2rem;
        }
        .card-custom {
            background-color: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.02);
            border: none;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .table-custom thead th {
            font-weight: 600;
            color: #475569;
            background-color: #f8fafc;
            border-bottom: 1.5px solid #e2e8f0;
            padding: 1rem;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .table-custom tbody td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.95rem;
        }
        .badge-custom {
            font-weight: 500;
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
        }
        .form-select, .form-control {
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.6rem 0.8rem;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }
        .form-select:focus, .form-control:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }
        .modal-custom .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }
        .modal-custom .modal-header {
            border-bottom: 1px solid #f1f5f9;
            padding: 1.5rem 2rem;
        }
        .modal-custom .modal-body {
            padding: 2rem;
        }
        .modal-custom .modal-footer {
            border-top: 1px solid #f1f5f9;
            padding: 1.5rem 2rem;
        }
    </style>
</head>
<body>

    <div class="container-fluid p-0">
        <div class="row g-0">
            
            <!-- SIDEBAR -->
            <div class="col-md-3 col-lg-2 sidebar p-4 d-flex flex-column">
                <div class="mb-4 pb-3 border-bottom border-secondary">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand text-decoration-none">Smart Campus</a>
                </div>
                
                <nav class="flex-grow-1">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-speedometer2" viewBox="0 0 16 16">
                            <path d="M8 4a.5.5 0 0 1 .5.5V6a.5.5 0 0 1-1 0V4.5A.5.5 0 0 1 8 4M3.732 5.732a.5.5 0 0 1 .707 0l.915.914a.5.5 0 1 1-.708.708l-.914-.915a.5.5 0 0 1 0-.707M2 10a.5.5 0 0 1 .5-.5h1.586a.5.5 0 0 1 0 1H2.5A.5.5 0 0 1 2 10m9.5 0a.5.5 0 0 1 .5-.5h1.586a.5.5 0 0 1 0 1H12a.5.5 0 0 1-.5-.5m-7-5.354A1.5 1.5 0 1 1 5 3.5a1.5 1.5 0 0 1-1.5 1.146"/>
                        </svg>
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/manageComplaints" class="sidebar-link">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-card-checklist" viewBox="0 0 16 16">
                            <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2z"/>
                        </svg>
                        Complaints
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/manageBookings" class="sidebar-link active">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-calendar-event" viewBox="0 0 16 16">
                            <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5z"/>
                        </svg>
                        Bookings
                    </a>
                    <a href="#" class="sidebar-link" onclick="alert('Detailed analytics page coming soon!')">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-bar-chart-line" viewBox="0 0 16 16">
                            <path d="M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h-4zm-4 5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7H7zm-4 3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v4H3z"/>
                        </svg>
                        Analytics
                    </a>
                    <a href="#" class="sidebar-link" onclick="alert('User moderation section coming soon!')">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-people" viewBox="0 0 16 16">
                            <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.047 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724C2.345 10.63 3.32 10 5 10q.47 0 .92.08"/>
                        </svg>
                        Users
                    </a>
                </nav>
                
                <div class="pt-3 border-top border-secondary">
                    <div class="text-white small fw-medium mb-3">Admin: <strong>${userName}</strong></div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm w-100 rounded-pill">Logout</a>
                </div>
            </div>
            
            <!-- MAIN CONTENT AREA -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Premium Admin Top Navbar -->
                <jsp:include page="/WEB-INF/includes/navbar-admin.jsp" />
                
                <!-- Page Header -->
                <div class="mb-4">
                    <h2 class="fw-bold text-dark">Resource Booking Moderation</h2>
                    <p class="text-secondary small">Review student booking requests, manage slot conflicts, and approve reservations.</p>
                </div>
                
                <!-- Filter Card -->
                <div class="card card-custom py-3 px-4 mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-4">
                            <label for="filterStatus" class="form-label small text-secondary fw-semibold">Filter by Status</label>
                            <select class="form-select" id="filterStatus">
                                <option value="">All Statuses</option>
                                <option value="pending">Pending</option>
                                <option value="approved">Approved</option>
                                <option value="rejected">Rejected</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Bookings Table Card -->
                <div class="card card-custom">
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle mb-0 w-100" id="bookingsTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Student</th>
                                    <th>Resource Name</th>
                                    <th>Date</th>
                                    <th>Time Frame</th>
                                    <th>Purpose</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${bookings}">
                                    <tr id="row-${book.id}"
                                        data-id="${book.id}"
                                        data-student="<c:out value="${book.studentName}"/>"
                                        data-resource="<c:out value="${book.resourceName}"/>"
                                        data-date="<fmt:formatDate value="${book.bookingDate}" pattern="MMM dd, yyyy"/>"
                                        data-time="<fmt:formatDate value="${book.startTime}" pattern="hh:mm a"/> - <fmt:formatDate value="${book.endTime}" pattern="hh:mm a"/>"
                                        data-purpose="<c:out value="${book.purpose}"/>"
                                        data-status="${book.status}">
                                        <td class="fw-semibold text-secondary">#${book.id}</td>
                                        <td class="fw-bold"><c:out value="${book.studentName}"/></td>
                                        <td class="fw-semibold"><c:out value="${book.resourceName}"/></td>
                                        <td class="fw-medium text-secondary">
                                            <fmt:formatDate value="${book.bookingDate}" pattern="MMM dd, yyyy"/>
                                        </td>
                                        <td class="text-secondary small">
                                            <fmt:formatDate value="${book.startTime}" pattern="hh:mm a"/> - 
                                            <fmt:formatDate value="${book.endTime}" pattern="hh:mm a"/>
                                        </td>
                                        <td class="text-truncate small" style="max-width: 180px;" title="<c:out value="${book.purpose}"/>">
                                            <c:out value="${book.purpose}"/>
                                        </td>
                                        <td>
                                            <span class="badge badge-custom status-badge
                                                <c:choose>
                                                    <c:when test="${book.status == 'pending'}">bg-warning text-dark</c:when>
                                                    <c:when test="${book.status == 'approved'}">bg-success text-white</c:when>
                                                    <c:when test="${book.status == 'rejected'}">bg-danger text-white</c:when>
                                                    <c:otherwise>bg-secondary text-white</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${book.status}"/>
                                            </span>
                                        </td>
                                        <td class="text-end action-buttons-td">
                                            <c:choose>
                                                <c:when test="${book.status == 'pending'}">
                                                    <div class="d-flex justify-content-end gap-2">
                                                        <button type="button" class="btn btn-sm btn-success rounded-pill px-3" 
                                                                onclick="approveBooking(${book.id})">
                                                            Approve
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3" 
                                                                onclick="openRejectModal(${book.id})">
                                                            Reject
                                                        </button>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small italic">Processed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- REJECTION REMARK MODAL -->
    <div class="modal fade modal-custom" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="rejectModalLabel">Reject Booking Request</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    
                    <!-- Quick Info Header -->
                    <div class="mb-4 bg-light p-3 rounded-3">
                        <div class="small text-secondary fw-semibold">Booking Reference</div>
                        <h6 class="fw-bold text-dark mb-1" id="rejectModalTitle">#ID - Resource</h6>
                        <div class="small text-secondary">Student: <span id="rejectModalStudent">Name</span></div>
                    </div>

                    <form id="rejectForm">
                        <input type="hidden" id="rejectBookingId">
                        
                        <!-- Remarks Textarea -->
                        <div class="mb-3">
                            <label for="rejectRemark" class="form-label small text-secondary fw-semibold">Rejection Reason / Remarks (Optional)</label>
                            <textarea class="form-control" id="rejectRemark" rows="3" 
                                      placeholder="Describe why this reservation is rejected (e.g. conflict, maintenance schedule)..."></textarea>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger rounded-pill px-4" onclick="submitRejection()">Confirm Rejection</button>
                </div>
            </div>
        </div>
    </div>

    <!-- CDNs JQuery and Datatables -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side Datatable and AJAX Bookings Moderation Actions -->
    <script>
        let table;
        let activeRow;

        $(document).ready(function() {
            // Initialize Datatable
            table = $('#bookingsTable').DataTable({
                "pageLength": 10,
                "order": [[0, "desc"]],
                "dom": "tp", // Simplify DOM elements showing only table and pagination
                "columnDefs": [
                    { "orderable": false, "targets": [5, 7] }
                ]
            });

            // Status custom filtering
            $('#filterStatus').on('change', function() {
                table.column(6).search(this.value).draw();
            });
        });

        function approveBooking(id) {
            if (!confirm("Are you sure you want to APPROVE this booking request?")) return;
            
            activeRow = document.getElementById(`row-${id}`);

            fetch(`${pageContext.request.contextPath}/admin/approveBooking`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `bookingId=${id}&adminRemark=Approved by administrator`
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Update table row status dynamically without reload
                    activeRow.setAttribute('data-status', 'approved');
                    
                    const statBadge = activeRow.querySelector('.status-badge');
                    statBadge.textContent = 'approved';
                    statBadge.className = 'badge badge-custom status-badge bg-success text-white';

                    // Update action buttons column
                    const actionsTd = activeRow.querySelector('.action-buttons-td');
                    actionsTd.innerHTML = '<span class="text-muted small italic">Processed</span>';

                    // Re-draw Datatable rows to preserve clean indexing and sort orders
                    table.row(activeRow).invalidate().draw(false);
                } else {
                    alert("Failed to approve booking: " + data.message);
                }
            })
            .catch(err => {
                console.error("Error approving booking request via AJAX:", err);
                alert("A server error occurred. Please try again.");
            });
        }

        function openRejectModal(id) {
            activeRow = document.getElementById(`row-${id}`);
            
            const student = activeRow.getAttribute('data-student');
            const resource = activeRow.getAttribute('data-resource');

            document.getElementById('rejectBookingId').value = id;
            document.getElementById('rejectModalTitle').textContent = `Booking #${id} - ${resource}`;
            document.getElementById('rejectModalStudent').textContent = student;
            document.getElementById('rejectRemark').value = '';

            const modal = new bootstrap.Modal(document.getElementById('rejectModal'));
            modal.show();
        }

        function submitRejection() {
            const id = document.getElementById('rejectBookingId').value;
            const remark = document.getElementById('rejectRemark').value.trim() || "Rejected by administrator";

            fetch(`${pageContext.request.contextPath}/admin/rejectBooking`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `bookingId=${id}&adminRemark=${encodeURIComponent(remark)}`
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Update table row status dynamically without reload
                    activeRow.setAttribute('data-status', 'rejected');
                    
                    const statBadge = activeRow.querySelector('.status-badge');
                    statBadge.textContent = 'rejected';
                    statBadge.className = 'badge badge-custom status-badge bg-danger text-white';

                    // Update action buttons column
                    const actionsTd = activeRow.querySelector('.action-buttons-td');
                    actionsTd.innerHTML = '<span class="text-muted small italic">Processed</span>';

                    // Re-draw Datatable rows
                    table.row(activeRow).invalidate().draw(false);

                    // Close Modal
                    bootstrap.Modal.getInstance(document.getElementById('rejectModal')).hide();
                } else {
                    alert("Failed to reject booking: " + data.message);
                }
            })
            .catch(err => {
                console.error("Error rejecting booking request via AJAX:", err);
                alert("A server error occurred. Please try again.");
            });
        }
    </script>
</body>
</html>
