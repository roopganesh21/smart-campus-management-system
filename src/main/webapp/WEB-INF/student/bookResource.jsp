<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Resource - Smart Campus</title>
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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.05);
        }
        .resource-header-img {
            height: 140px;
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 3rem;
        }
        .bg-hall {
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
        }
        .bg-lab {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
        }
        .bg-equipment {
            background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
        }
        .badge-custom {
            font-weight: 600;
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 8px;
        }
        .modal-custom .modal-content {
            border-radius: 24px;
            border: none;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
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
        .form-label {
            font-weight: 500;
            color: #334155;
            font-size: 0.9rem;
        }
        .form-control, .form-select {
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.6rem 0.8rem;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
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
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-4">
                    <li class="nav-item me-3">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/student/raiseComplaint">Raise Complaint</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/student/trackComplaints">My Complaints</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link nav-link-custom active" href="${pageContext.request.contextPath}/student/bookResource">Book Resource</a>
                    </li>
                    <li class="nav-item me-3">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/student/myBookings">My Bookings</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <span class="text-secondary small fw-medium me-4">Welcome, <strong class="text-dark">${userName}</strong></span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm rounded-pill px-3">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Container -->
    <div class="container pb-5">
        
        <!-- Page Header & Active Bookings Count Badge -->
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h2 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                    Book a Resource
                    <span class="badge bg-primary rounded-pill fs-6 py-2 px-3">${activeBookingsCount} Active</span>
                </h2>
                <p class="text-secondary small mb-0 mt-1">Reserve seminar halls, labs, and equipment for study sessions or department tasks.</p>
            </div>
        </div>

        <!-- Resources Section -->
        <div class="row g-4">
            <c:choose>
                <c:when test="${empty resources}">
                    <div class="col-12 text-center py-5">
                        <div class="bg-white rounded-4 p-5 shadow-sm d-inline-block">
                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-x-circle text-muted mb-3" viewBox="0 0 16 16">
                                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
                            </svg>
                            <h5 class="fw-bold text-dark mb-2">No Resources Registered</h5>
                            <p class="text-muted small mb-0">There are currently no active resources registered in the system.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="res" items="${resources}">
                        <div class="col-md-6 col-lg-4">
                            <div class="card card-custom">
                                
                                <!-- Sleek Icon Header based on Type -->
                                <c:choose>
                                    <c:when test="${res.type == 'hall'}">
                                        <div class="resource-header-img bg-hall">
                                            <!-- Building Icon -->
                                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-building-fill" viewBox="0 0 16 16">
                                                <path d="M3 0a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h3v-3.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 .5.5V16h3a1 1 0 0 0 1-1V1a1 1 0 0 0-1-1zm1 2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm-6 3A.5.5 0 0 1 4.5 5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm-6 3A.5.5 0 0 1 4.5 8h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm-6 3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5z"/>
                                            </svg>
                                        </div>
                                    </c:when>
                                    <c:when test="${res.type == 'lab'}">
                                        <div class="resource-header-img bg-lab">
                                            <!-- Flask Icon -->
                                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-funnel-fill" viewBox="0 0 16 16">
                                                <path d="M1.5 1.5A.5.5 0 0 1 2 1h12a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-.124.325L9 9.3v5.1a.5.5 0 0 1-.25.433l-2.5 1.4A.5.5 0 0 1 5.5 15.8V9.3L1.624 3.825a.5.5 0 0 1-.124-.325z"/>
                                            </svg>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="resource-header-img bg-equipment">
                                            <!-- Tools Icon -->
                                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-tools" viewBox="0 0 16 16">
                                                <path d="M1 0 0 1l2.2 3.081a1 1 0 0 0 .815.419h.07a1 1 0 0 1 .708.293l2.675 2.675-2.617 2.654A3.003 3.003 0 0 0 0 13a3 3 0 1 0 5.878-.851l2.654-2.617.968.968a3.99 3.99 0 0 0 1.879.899l.044.01c.29.07.477.373.477.67v.439a1.5 1.5 0 0 0 1.5 1.5h1a1.5 1.5 0 0 0 1.5-1.5v-1a1.5 1.5 0 0 0-1.5-1.5h-.439a.6.6 0 0 1-.6-.477a3.99 3.99 0 0 0-.899-1.878l-.968-.969 2.617-2.654A3.003 3.003 0 0 0 16 3a3 3 0 1 0-5.878.851l-2.654 2.617-.968-.968a3.99 3.99 0 0 0-1.878-.899l-.044-.01a.6.6 0 0 1-.477-.67V3.5a1.5 1.5 0 0 0-1.5-1.5h-1A1.5 1.5 0 0 0 1.5 3.5v.439a.6.6 0 0 1-.477.6c-.29.07-.477.043-.67-.044a3.99 3.99 0 0 0-1.878-.899L1 0Zm2.003 12.274a1 1 0 1 1 1.415-1.414 1 1 0 0 1-1.415 1.414ZM11 11h3v1h-3v-1Zm0-4h3v1h-3V7ZM4 4h3v1H4V4Z"/>
                                            </svg>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Card Body -->
                                <div class="card-body p-4 d-flex flex-column flex-grow-1">
                                    
                                    <!-- Badges -->
                                    <div class="mb-3 d-flex justify-content-between align-items-center">
                                        <span class="badge badge-custom 
                                            <c:choose>
                                                <c:when test="${res.type == 'hall'}">bg-primary text-white</c:when>
                                                <c:when test="${res.type == 'lab'}">bg-info text-white</c:when>
                                                <c:otherwise>bg-teal text-white</c:otherwise>
                                            </c:choose>">
                                            <c:choose>
                                                <c:when test="${res.type == 'hall'}">Seminar Hall</c:when>
                                                <c:when test="${res.type == 'lab'}">Academic Lab</c:when>
                                                <c:otherwise>Equipment</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="text-secondary small fw-medium d-flex align-items-center gap-1">
                                            <!-- Capacity Person Icon -->
                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-people" viewBox="0 0 16 16">
                                                <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.047 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724C2.345 10.63 3.32 10 5 10q.47 0 .92.08"/>
                                            </svg>
                                            Cap: ${res.capacity}
                                        </span>
                                    </div>

                                    <h5 class="fw-bold text-dark mb-2"><c:out value="${res.name}"/></h5>
                                    
                                    <!-- Location Badge -->
                                    <div class="d-flex align-items-center gap-1 text-secondary small mb-3">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-geo-alt-fill text-danger" viewBox="0 0 16 16">
                                            <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6"/>
                                        </svg>
                                        <span><c:out value="${res.location}"/></span>
                                    </div>

                                    <p class="text-secondary small mb-4 flex-grow-1">
                                        <c:choose>
                                            <c:when test="${fn:length(res.description) > 90}">
                                                <c:out value="${fn:substring(res.description, 0, 87)}..."/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${res.description}"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>

                                    <!-- Footer action -->
                                    <button class="btn btn-primary w-100 rounded-pill py-2 fw-semibold" 
                                            onclick="openBookingModal(${res.id}, '<c:out value="${res.name}"/>')">
                                        Check Availability & Book
                                    </button>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <!-- BOOKING MODAL (Shared dynamically) -->
    <div class="modal fade modal-custom" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="bookingModalLabel">Book Resource</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    
                    <!-- Form block -->
                    <form id="bookingForm">
                        <input type="hidden" name="resourceId" id="modalResourceId">
                        
                        <!-- Reservation Date -->
                        <div class="mb-3">
                            <label for="bookingDate" class="form-label">Reservation Date</label>
                            <input type="date" class="form-control" name="bookingDate" id="bookingDate" onchange="resetAvailabilityCheck()">
                        </div>

                        <!-- Start and End Times -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="startTime" class="form-label">Start Time</label>
                                <select class="form-select" name="startTime" id="startTime" onchange="resetAvailabilityCheck()">
                                    <!-- Populated by JS -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="endTime" class="form-label">End Time</label>
                                <select class="form-select" name="endTime" id="endTime" onchange="resetAvailabilityCheck()">
                                    <!-- Populated by JS -->
                                </select>
                            </div>
                        </div>

                        <!-- Purpose description -->
                        <div class="mb-4">
                            <label for="purpose" class="form-label">Purpose of Booking (Min 20 chars)</label>
                            <textarea class="form-control" name="purpose" id="purpose" rows="3" 
                                      placeholder="Describe the activities or meeting goals in detail..."></textarea>
                        </div>

                        <!-- Availability Indicator Alerts -->
                        <div id="availabilityAlert" class="alert d-none py-2 small fw-semibold"></div>

                    </form>

                </div>
                <div class="modal-footer d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4 flex-grow-1" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-warning rounded-pill px-4 flex-grow-1 fw-semibold text-dark" onclick="checkAvailability()">Check Availability</button>
                    <button type="button" class="btn btn-primary rounded-pill px-4 flex-grow-1 fw-semibold" id="confirmBookingBtn" disabled onclick="submitBooking()">Book Slot</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript controls -->
    <script>
        let isAvailable = false;

        document.addEventListener("DOMContentLoaded", function() {
            // 1. Generate dates limit: today to today + 30 days
            const today = new Date();
            const maxDate = new Date();
            maxDate.setDate(today.getDate() + 30);

            const formatString = date => date.toISOString().split('T')[0];
            
            const dateInput = document.getElementById('bookingDate');
            dateInput.min = formatString(today);
            dateInput.max = formatString(maxDate);
            dateInput.value = formatString(today);

            // 2. Generate time dropdown intervals (8:00 AM to 8:00 PM in 30-min intervals)
            populateTimeDropdowns();
        });

        function populateTimeDropdowns() {
            const startSelect = document.getElementById('startTime');
            const endSelect = document.getElementById('endTime');
            
            startSelect.innerHTML = '';
            endSelect.innerHTML = '';

            const times = [];
            for (let hour = 8; hour <= 20; hour++) {
                times.push({ value: formatTimeStr(hour, 0), label: formatDisplayStr(hour, 0) });
                if (hour < 20) {
                    times.push({ value: formatTimeStr(hour, 30), label: formatDisplayStr(hour, 30) });
                }
            }

            times.forEach((t, index) => {
                startSelect.options.add(new Option(t.label, t.value));
                if (index > 0) { // End times must start after the first start time
                    endSelect.options.add(new Option(t.label, t.value));
                }
            });

            // Set default selections
            startSelect.value = "09:00:00";
            endSelect.value = "10:00:00";
        }

        function formatTimeStr(hour, min) {
            const hh = hour.toString().padStart(2, '0');
            const mm = min.toString().padStart(2, '0');
            return `${hh}:${mm}:00`;
        }

        function formatDisplayStr(hour, min) {
            const period = hour >= 12 ? 'PM' : 'AM';
            let h = hour % 12;
            if (h === 0) h = 12;
            const mm = min.toString().padStart(2, '0');
            return `${h}:${mm} ${period}`;
        }

        function openBookingModal(resourceId, resourceName) {
            document.getElementById('modalResourceId').value = resourceId;
            document.getElementById('bookingModalLabel').textContent = "Book " + resourceName;
            document.getElementById('purpose').value = '';
            resetAvailabilityCheck();

            const modal = new bootstrap.Modal(document.getElementById('bookingModal'));
            modal.show();
        }

        function resetAvailabilityCheck() {
            isAvailable = false;
            const alertEl = document.getElementById('availabilityAlert');
            alertEl.classList.add('d-none');
            alertEl.className = 'alert d-none py-2 small fw-semibold';
            
            document.getElementById('confirmBookingBtn').disabled = true;
        }

        function checkAvailability() {
            const resId = document.getElementById('modalResourceId').value;
            const date = document.getElementById('bookingDate').value;
            const start = document.getElementById('startTime').value;
            const end = document.getElementById('endTime').value;
            const alertEl = document.getElementById('availabilityAlert');

            // Client Time Validation
            if (start >= end) {
                alertEl.textContent = "Error: End time must be strictly after the start time.";
                alertEl.className = "alert alert-danger py-2 small fw-semibold";
                alertEl.classList.remove('d-none');
                return;
            }

            const url = `${pageContext.request.contextPath}/student/checkAvailability?resourceId=${resId}&date=${date}&start=${start}&end=${end}`;

            fetch(url)
            .then(res => res.json())
            .then(data => {
                alertEl.classList.remove('d-none');
                if (data.available) {
                    alertEl.textContent = "Available! Proceed to book.";
                    alertEl.className = "alert alert-success py-2 small fw-semibold";
                    
                    isAvailable = true;
                    document.getElementById('confirmBookingBtn').disabled = false;
                } else {
                    alertEl.textContent = "This slot is already taken. Please choose another date or time.";
                    alertEl.className = "alert alert-danger py-2 small fw-semibold";
                    
                    isAvailable = false;
                    document.getElementById('confirmBookingBtn').disabled = true;
                }
            })
            .catch(err => {
                console.error("Error checking availability:", err);
                alertEl.textContent = "Server validation failed. Please try again.";
                alertEl.className = "alert alert-danger py-2 small fw-semibold";
                alertEl.classList.remove('d-none');
            });
        }

        function submitBooking() {
            if (!isAvailable) return;

            const resId = document.getElementById('modalResourceId').value;
            const date = document.getElementById('bookingDate').value;
            const start = document.getElementById('startTime').value;
            const end = document.getElementById('endTime').value;
            const purpose = document.getElementById('purpose').value.trim();
            const alertEl = document.getElementById('availabilityAlert');

            if (purpose.length < 20) {
                alertEl.textContent = "Booking purpose is required and must be at least 20 characters long.";
                alertEl.className = "alert alert-danger py-2 small fw-semibold";
                alertEl.classList.remove('d-none');
                return;
            }

            // AJAX post booking
            const payload = new URLSearchParams();
            payload.append('resourceId', resId);
            payload.append('bookingDate', date);
            payload.append('startTime', start);
            payload.append('endTime', end);
            payload.append('purpose', purpose);

            fetch('${pageContext.request.contextPath}/student/book', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: payload.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Close modal and redirect to My Bookings
                    bootstrap.Modal.getInstance(document.getElementById('bookingModal')).hide();
                    window.location.href = '${pageContext.request.contextPath}/student/myBookings?success=true';
                } else {
                    alertEl.textContent = data.message || "Failed to submit booking request.";
                    alertEl.className = "alert alert-danger py-2 small fw-semibold";
                    alertEl.classList.remove('d-none');
                }
            })
            .catch(err => {
                console.error("Error creating booking request:", err);
                alertEl.textContent = "A server error occurred. Please try again.";
                alertEl.className = "alert alert-danger py-2 small fw-semibold";
                alertEl.classList.remove('d-none');
            });
        }
    </script>
</body>
</html>
