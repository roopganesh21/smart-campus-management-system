<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Global Style Theme Sheet -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    
    <!-- Custom CSS for Premium Design -->
    <style>
        .card-custom {
            background-color: #ffffff;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            border: none;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .btn-primary-custom {
            background-color: #4f46e5;
            border: none;
            border-radius: 10px;
            padding: 0.6rem 1.2rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .btn-primary-custom:hover {
            background-color: #4338ca;
            transform: translateY(-1px);
        }
        .breadcrumb-item a {
            color: #64748b;
            text-decoration: none;
            font-size: 0.9rem;
        }
        .breadcrumb-item.active {
            color: #4f46e5;
            font-weight: 500;
            font-size: 0.9rem;
        }
        .filter-btn {
            border-radius: 10px !important;
            font-weight: 500;
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
            transition: all 0.2s ease;
            border: 1.5px solid #e2e8f0;
            background-color: white;
            color: #64748b;
        }
        .filter-btn:hover {
            background-color: #f1f5f9;
            color: #334155;
            border-color: #cbd5e1;
        }
        .filter-btn.active {
            background-color: #4f46e5 !important;
            border-color: #4f46e5 !important;
            color: white !important;
        }
        .table-custom {
            vertical-align: middle;
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
        .table-custom tbody tr {
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .table-custom tbody tr:hover {
            background-color: #f8fafc;
        }
        .table-custom tbody td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.95rem;
            color: #334155;
        }
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }
        .empty-state svg {
            color: #cbd5e1;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

    <!-- Loading Spinner Overlay -->
    <div id="loadingOverlay" class="position-fixed top-0 start-0 w-100 h-100 d-none justify-content-center align-items-center" style="background: rgba(15, 23, 42, 0.6); z-index: 9999;">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <!-- Include Toast Javascript helper -->
    <script><%@ include file="/WEB-INF/includes/toast.js" %></script>

    <div class="d-flex">
        <!-- SIDEBAR -->
        <jsp:include page="/WEB-INF/includes/sidebar-student.jsp" />
        
        <!-- MAIN CONTENT AREA -->
        <div class="main-content flex-grow-1 p-4 fade-in">
            <!-- Premium Top Navigation Bar -->
            <jsp:include page="/WEB-INF/includes/navbar-student.jsp" />
            
            <!-- Main Content Container -->
            <div class="container-fluid pb-5">
        
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark mb-0">My Complaints</h2>
                <nav aria-label="breadcrumb" class="mt-2">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Complaints</li>
                    </ol>
                </nav>
            </div>
            <a href="${pageContext.request.contextPath}/student/raiseComplaint" class="btn btn-primary btn-primary-custom d-flex align-items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-plus-lg me-2" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2"/>
                </svg>
                Raise New Complaint
            </a>
        </div>

        <!-- Filter Bar -->
        <div class="mb-4">
            <div class="btn-group flex-wrap gap-2" role="group" aria-label="Complaint Status Filters">
                <button type="button" class="btn filter-btn active" data-filter="all">All <span class="badge bg-secondary ms-1" id="count-all">0</span></button>
                <button type="button" class="btn filter-btn" data-filter="pending">Pending <span class="badge bg-secondary ms-1" id="count-pending">0</span></button>
                <button type="button" class="btn filter-btn" data-filter="assigned">Assigned <span class="badge bg-secondary ms-1" id="count-assigned">0</span></button>
                <button type="button" class="btn filter-btn" data-filter="in_progress">In Progress <span class="badge bg-secondary ms-1" id="count-in_progress">0</span></button>
                <button type="button" class="btn filter-btn" data-filter="resolved">Resolved <span class="badge bg-secondary ms-1" id="count-resolved">0</span></button>
            </div>
        </div>

        <!-- Complaints Table Card -->
        <div class="card card-custom">
            
            <c:choose>
                <c:when test="${empty complaints}">
                    <div class="empty-state">
                        <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-folder-x" viewBox="0 0 16 16">
                            <path d="M.54 3.87.5 3a2 2 0 0 1 2-2h3.672a2 2 0 0 1 1.414.586l.828.828A2 2 0 0 0 9.828 3h3.982a2 2 0 0 1 1.992 2.181L15.546 8H14.54l.265-2.91A1 1 0 0 0 13.81 4H9.828a3 3 0 0 1-2.12-.879l-.83-.828A1 1 0 0 0 6.172 2H2.5a1 1 0 0 0-1 .981L1.55 6h12.038l.265 2.91a.48.48 0 0 1-.013.2L15 9.66V13a2 2 0 0 1-2 2H1.5a2 2 0 0 1-2-2V4.87zM1.46 6.32a.48.48 0 0 0-.048.18v.03h12.164a.5.5 0 0 0 .048-.18l-.265-2.91h-.007a.5.5 0 0 0-.048.18L1.46 6.32zM11.146 9.146a.5.5 0 0 1 .708 0L13 10.293l1.146-1.147a.5.5 0 0 1 .708.708L13.707 11l1.147 1.146a.5.5 0 0 1-.708.708L13 11.707l-1.146 1.147a.5.5 0 0 1-.708-.708L12.293 11l-1.147-1.146a.5.5 0 0 1 0-.708"/>
                        </svg>
                        <h4 class="fw-bold text-dark">No complaints yet</h4>
                        <p class="text-secondary small">Raise your first complaint by clicking the "Raise New Complaint" button above.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle mb-0" id="complaintsTable">
                            <thead>
                                <tr>
                                    <th style="width: 50px;">#</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Assigned To</th>
                                    <th>Date Raised</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="complaint" items="${complaints}" varStatus="status">
                                    <tr data-status="${complaint.status}" onclick="window.location.href='${pageContext.request.contextPath}/student/complaintDetail?id=${complaint.id}'">
                                        <td class="text-secondary fw-semibold">${status.index + 1}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/student/complaintDetail?id=${complaint.id}" class="text-dark fw-bold text-decoration-none hover-primary">
                                                <c:out value="${complaint.title}"/>
                                            </a>
                                        </td>
                                        <td>
                                            <span class="badge badge-custom 
                                                <c:choose>
                                                    <c:when test="${complaint.category == 'hostel'}">bg-info-subtle text-info</c:when>
                                                    <c:when test="${complaint.category == 'classroom'}">bg-primary-subtle text-primary</c:when>
                                                    <c:when test="${complaint.category == 'electricity'}">bg-warning-subtle text-warning</c:when>
                                                    <c:when test="${complaint.category == 'water'}">bg-teal-subtle text-teal</c:when>
                                                    <c:when test="${complaint.category == 'lab'}">bg-secondary-subtle text-secondary</c:when>
                                                    <c:otherwise>bg-dark-subtle text-dark</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${complaint.category}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge badge-custom 
                                                <c:choose>
                                                    <c:when test="${complaint.priority == 'low'}">bg-secondary text-white</c:when>
                                                    <c:when test="${complaint.priority == 'medium'}">bg-warning text-dark</c:when>
                                                    <c:when test="${complaint.priority == 'high'}">bg-danger text-white</c:when>
                                                    <c:otherwise>bg-secondary text-white</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${complaint.priority}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge badge-custom 
                                                <c:choose>
                                                    <c:when test="${complaint.status == 'pending'}">bg-secondary text-white</c:when>
                                                    <c:when test="${complaint.status == 'assigned'}">bg-primary text-white</c:when>
                                                    <c:when test="${complaint.status == 'in_progress'}">bg-warning text-dark</c:when>
                                                    <c:when test="${complaint.status == 'resolved'}">bg-success text-white</c:when>
                                                    <c:otherwise>bg-secondary text-white</c:otherwise>
                                                </c:choose>">
                                                <c:choose>
                                                    <c:when test="${complaint.status == 'in_progress'}">In Progress</c:when>
                                                    <c:otherwise><c:out value="${complaint.status}"/></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="text-secondary small">
                                            <c:choose>
                                                <c:when test="${not empty complaint.workerName}">
                                                    <c:out value="${complaint.workerName}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted italic">Unassigned</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-secondary small">
                                            <fmt:formatDate value="${complaint.createdAt}" pattern="MMM dd, yyyy"/>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/student/complaintDetail?id=${complaint.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                View
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div> <!-- card card-custom closed -->

    </div> <!-- container-fluid closed -->
    </div> <!-- main-content closed -->
    </div> <!-- d-flex closed -->

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side Filter Logic and Counters -->
    <script>
        (() => {
            'use strict';

            // 1. Toast Notification on successful submit using dynamic showToast
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('submitted') === 'true') {
                showToast('Your complaint has been submitted successfully!', 'success');
                
                // Clean URL query parameter cleanly without reloading
                const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
            }

            // 2. Count calculator for Filter Badges
            const rows = document.querySelectorAll('#complaintsTable tbody tr');
            const counts = {
                all: 0,
                pending: 0,
                assigned: 0,
                in_progress: 0,
                resolved: 0
            };

            rows.forEach(row => {
                counts.all++;
                const status = row.getAttribute('data-status');
                if (counts.hasOwnProperty(status)) {
                    counts[status]++;
                }
            });

            // Update badge text values
            document.getElementById('count-all').textContent = counts.all;
            document.getElementById('count-pending').textContent = counts.pending;
            document.getElementById('count-assigned').textContent = counts.assigned;
            document.getElementById('count-in_progress').textContent = counts.in_progress;
            document.getElementById('count-resolved').textContent = counts.resolved;

            // 3. Tab filter actions (show/hide tr)
            const filterButtons = document.querySelectorAll('.filter-btn');
            filterButtons.forEach(btn => {
                btn.addEventListener('click', (e) => {
                    // Prevent button click propagation issues
                    e.preventDefault();
                    
                    // Toggle active classes
                    filterButtons.forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');

                    const filterValue = btn.getAttribute('data-filter');
                    rows.forEach(row => {
                        const status = row.getAttribute('data-status');
                        if (filterValue === 'all' || status === filterValue) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            });
        })();
    </script>
</body>
</html>
