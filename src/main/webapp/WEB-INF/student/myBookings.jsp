<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
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
        .nav-link-custom {
            color: #64748b;
            font-weight: 500;
            transition: color 0.2s ease;
        }
        .nav-link-custom:hover, .nav-link-custom.active {
            color: #4f46e5;
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
        /* Overrides Bootstrap Toast to place it elegantly in the top-right corner */
        .toast-container {
            position: fixed;
            top: 24px;
            right: 24px;
            z-index: 1060;
        }
    </style>
</head>
<body>

    <!-- Premium Top Navigation Bar -->
    <jsp:include page="/WEB-INF/includes/navbar-student.jsp" />

    <!-- Success Toast Notification (double-submit prevention feedback) -->
    <div class="toast-container">
        <div class="toast align-items-center text-white bg-success border-0 shadow-lg rounded-3" id="bookingToast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body d-flex align-items-center gap-2">
                    <!-- Check circle Icon -->
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16">
                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                        <path d="m10.97 4.97-.02.022-3.473 4.425-2.093-2.094a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05"/>
                    </svg>
                    <span>Your booking request has been submitted successfully!</span>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <!-- Main Content Container -->
    <div class="container pb-5">
        
        <!-- Page Header -->
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h2 class="fw-bold text-dark mb-0">My Resource Bookings</h2>
                <p class="text-secondary small mt-1">Review the status and comments on your reservation history.</p>
            </div>
        </div>

        <!-- Bookings History Table -->
        <div class="card card-custom p-4">
            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="text-center py-5">
                        <div class="p-5 d-inline-block">
                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-calendar-x text-muted mb-3" viewBox="0 0 16 16">
                                <path d="M6.146 7.146a.5.5 0 0 1 .708 0L8 8.293l1.146-1.147a.5.5 0 1 1 .708.708L8.707 9l1.147 1.146a.5.5 0 0 1-.708.708L8 9.707l-1.146 1.147a.5.5 0 0 1-.708-.708L7.293 9l-1.147-1.146a.5.5 0 0 1 0-.708M14 1H2a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2M1 3.857C1 3.384 1.448 3 2 3h12c.552 0 1 .384 1 .857v10.286c0 .473-.448.857-1 .857H2c-.552 0-1-.384-1-.857z"/>
                            </svg>
                            <h5 class="fw-bold text-dark mb-2">No Bookings Recorded</h5>
                            <p class="text-muted small mb-3">You have not submitted any resource reservation slots yet.</p>
                            <a href="${pageContext.request.contextPath}/student/bookResource" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">
                                Reserve a Resource
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Resource Name</th>
                                    <th>Type</th>
                                    <th>Date</th>
                                    <th>Time Frame</th>
                                    <th>Purpose</th>
                                    <th>Status</th>
                                    <th>Admin Remark</th>
                                    <th>Date Created</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${bookings}">
                                    <tr>
                                        <td class="fw-bold"><c:out value="${book.resourceName}"/></td>
                                        <td>
                                            <span class="badge bg-secondary-subtle text-secondary badge-custom text-uppercase">
                                                <c:choose>
                                                    <c:when test="${book.resourceType == 'hall'}">Seminar Hall</c:when>
                                                    <c:when test="${book.resourceType == 'lab'}">Academic Lab</c:when>
                                                    <c:otherwise>Equipment</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
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
                                            <span class="badge badge-custom
                                                <c:choose>
                                                    <c:when test="${book.status == 'pending'}">bg-warning text-dark</c:when>
                                                    <c:when test="${book.status == 'approved'}">bg-success text-white</c:when>
                                                    <c:when test="${book.status == 'rejected'}">bg-danger text-white</c:when>
                                                    <c:otherwise>bg-secondary text-white</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${book.status}"/>
                                            </span>
                                        </td>
                                        <td class="small text-muted" style="max-width: 150px;">
                                            <c:choose>
                                                <c:when test="${not empty book.adminRemark}">
                                                    <c:out value="${book.adminRemark}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted italic small">No remarks</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-secondary small">
                                            <fmt:formatDate value="${book.createdAt}" pattern="MMM dd, yyyy"/>
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

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Toast Notification trigger and URL cleaning -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === 'true') {
                // Initialize and show toast
                const toastEl = document.getElementById('bookingToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 5000 });
                toast.show();

                // Clean the success param from browser history
                urlParams.delete('success');
                const newRelativePathQuery = window.location.pathname + (urlParams.toString() ? '?' + urlParams.toString() : '');
                window.history.replaceState({}, document.title, newRelativePathQuery);
            }
        });
    </script>
</body>
</html>
