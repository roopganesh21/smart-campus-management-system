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
    <!-- Custom CSS for Premium Design -->
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
            min-height: 100vh;
        }
        .navbar-brand {
            font-weight: 700;
            color: #4f46e5 !important;
            letter-spacing: -0.5px;
        }
        .card-custom {
            background-color: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.02);
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
        .badge-custom {
            font-weight: 500;
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
        }
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }
        .empty-state svg {
            color: #cbd5e1;
            margin-bottom: 1.5rem;
        }
        .toast-container-custom {
            position: fixed;
            top: 24px;
            right: 24px;
            z-index: 1080;
        }
        .toast-custom {
            background-color: #ffffff;
            border: none;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #10b981;
        }
    </style>
</head>
<body>

    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom py-3 mb-4">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/student/dashboard">Smart Campus</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarText">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0"></ul>
                <div class="d-flex align-items-center">
                    <!-- Notification Bell Placeholder -->
                    <div class="position-relative me-4" style="cursor: pointer;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#64748b" class="bi bi-bell" viewBox="0 0 16 16">
                            <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2M8 1.918l-.797.161A4 4 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4 4 0 0 0-3.203-3.92zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5 5 0 0 1 13 6c0 .88.32 4.2 1.22 6"/>
                        </svg>
                        <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                    </div>
                    <!-- Student Username -->
                    <span class="text-secondary small fw-medium me-4">Welcome, <strong class="text-dark">${userName}</strong></span>
                    <!-- Logout -->
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm rounded-pill px-3">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Success Toast Container -->
    <div class="toast-container-custom">
        <div id="submitToast" class="toast toast-custom hide" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="4000">
            <div class="toast-header border-0 pb-0">
                <strong class="me-auto text-success d-flex align-items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill me-2" viewBox="0 0 16 16">
                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                    </svg>
                    Submission Successful
                </strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body text-secondary pt-1 pb-3">
                Your complaint has been submitted successfully!
            </div>
        </div>
    </div>

    <!-- Main Content Container -->
    <div class="container pb-5">
        
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

        </div>

    </div>

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side Filter Logic and Counters -->
    <script>
        (() => {
            'use strict';

            // 1. Toast Notification on successful submit
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('submitted') === 'true') {
                const toastEl = document.getElementById('submitToast');
                if (toastEl) {
                    const toast = new bootstrap.Toast(toastEl);
                    toast.show();
                    
                    // Clean URL query parameter cleanly without reloading
                    const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                    window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
                }
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
