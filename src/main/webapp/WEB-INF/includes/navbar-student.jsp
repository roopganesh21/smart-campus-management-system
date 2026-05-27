<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Custom Premium Navbar CSS -->
<style>
    .navbar-premium {
        background: #ffffff;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        border-bottom: 1px solid #f1f5f9;
        font-family: 'Outfit', sans-serif;
    }
    .navbar-premium .navbar-brand {
        font-weight: 700;
        color: #4f46e5 !important;
        letter-spacing: -0.5px;
        font-size: 1.35rem;
    }
    .navbar-premium .nav-link-custom {
        color: #64748b !important;
        font-weight: 500;
        font-size: 0.95rem;
        padding: 0.5rem 1rem !important;
        border-radius: 8px;
        transition: all 0.2s ease;
    }
    .navbar-premium .nav-link-custom:hover {
        color: #4f46e5 !important;
        background-color: #f5f3ff;
    }
    .navbar-premium .nav-link-custom.active {
        color: #4f46e5 !important;
        background-color: #e0e7ff;
        font-weight: 600;
    }
    
    /* Bell dropdown sizing and styling */
    .bell-dropdown-menu {
        width: 340px !important;
        border-radius: 16px !important;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08) !important;
        border: 1px solid #f1f5f9 !important;
        padding: 0 !important;
        overflow: hidden;
    }
    
    /* Wiggle keyframes for live bell alert */
    @keyframes wiggle {
        0%, 100% { transform: rotate(0deg); }
        15% { transform: rotate(10deg); }
        30% { transform: rotate(-10deg); }
        45% { transform: rotate(6deg); }
        60% { transform: rotate(-6deg); }
        75% { transform: rotate(3deg); }
        90% { transform: rotate(-3deg); }
    }
    .animate-wiggle {
        animation: wiggle 1s ease-in-out infinite;
        transform-origin: top center;
    }
    
    .avatar-initials-custom {
        width: 38px;
        height: 38px;
        background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
        box-shadow: 0 4px 8px rgba(79, 70, 229, 0.2);
        font-size: 0.95rem;
        transition: transform 0.2s ease;
    }
    .avatar-initials-custom:hover {
        transform: scale(1.05);
    }
</style>

<nav class="navbar navbar-expand-lg navbar-premium py-3 mb-4 sticky-top">
    <div class="container">
        <!-- Brand logo -->
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/student/dashboard">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-rocket-takeoff-fill me-2" viewBox="0 0 16 16">
                <path d="M12.17 9.53c-.077-.166-.16-.334-.246-.5a32.944 32.944 0 0 0-3.3-5.32c-.443-.574-.897-1.127-1.41-1.643a4.48 4.48 0 0 0-6.29 0l-.188.188a.5.5 0 0 0 .047.807c.53.322 1.19.811 1.777 1.397.99.99 1.699 2.107 2.157 2.914a26.893 26.893 0 0 0 2.298 3.502c.438.553.847 1.01 1.265 1.427.778.778 1.618 1.462 2.442 2.043a.5.5 0 0 0 .765-.488l-.133-2.147c-.015-.246-.037-.491-.064-.737zm2.247-2.631a.5.5 0 0 0-.816-.17l-1.247 1.247a.5.5 0 0 0-.146.353v.445L10.5 10H10a.5.5 0 0 0-.354.146L8.4 11.4a.5.5 0 0 0 .146.854l1.458.486a.5.5 0 0 0 .525-.13l1.113-1.113a.5.5 0 0 0 .14-.302l.142-2.29 1.248-1.248a.5.5 0 0 0 .198-.432z"/>
                <path d="M5.265 9.764a.5.5 0 0 0-.707 0L.6 13.72a.5.5 0 0 0 .708.708l3.957-3.957a.5.5 0 0 0 0-.708z"/>
            </svg>
            Smart Campus
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarContent">
            <!-- Navigation Links -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                <li class="nav-item">
                    <a class="nav-link nav-link-custom ${fn:contains(pageContext.request.requestURI, 'dashboard') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/dashboard">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-custom ${fn:contains(pageContext.request.requestURI, 'raiseComplaint') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/raiseComplaint">New Complaint</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-custom ${fn:contains(pageContext.request.requestURI, 'trackComplaints') || fn:contains(pageContext.request.requestURI, 'complaintDetail') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/trackComplaints">My Complaints</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-custom ${fn:contains(pageContext.request.requestURI, 'bookResource') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/bookResource">Book Resource</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-custom ${fn:contains(pageContext.request.requestURI, 'myBookings') ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/student/myBookings">My Bookings</a>
                </li>
            </ul>
            
            <!-- Right Hand Icons & Profile Controls -->
            <div class="d-flex align-items-center">
                
                <!-- Notification Bell Dropdown -->
                <div class="dropdown me-4 position-relative">
                    <a class="text-secondary p-1 d-inline-block position-relative" href="#" role="button" id="nav-bell-btn" data-bs-toggle="dropdown" aria-expanded="false">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="#64748b" class="bi bi-bell" viewBox="0 0 16 16">
                            <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zM8 1.918l-.797.161A4 4 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4 4 0 0 0-3.203-3.92zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5 5 0 0 1 13 6c0 .88.32 4.2 1.22 6"/>
                        </svg>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" 
                              id="nav-bell-badge" style="font-size: 0.65rem; display: none; padding: 0.25em 0.5em; top: 4px !important;">
                        </span>
                    </a>
                    
                    <div class="dropdown-menu dropdown-menu-end bell-dropdown-menu" aria-labelledby="nav-bell-btn">
                        <!-- Dropdown Header -->
                        <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom bg-light">
                            <span class="fw-bold text-dark small">Notifications</span>
                            <button type="button" class="btn btn-link text-primary p-0 text-decoration-none small" id="nav-notifications-mark-all" style="font-size: 0.8rem;">
                                Mark all read
                            </button>
                        </div>
                        
                        <!-- Notifications List -->
                        <div id="nav-notifications-list" style="max-height: 320px; overflow-y: auto;">
                            <!-- Populated dynamically via AJAX -->
                        </div>
                    </div>
                </div>
                
                <!-- Initials Circle Avatar -->
                <div class="avatar-initials-custom text-white fw-bold d-inline-flex align-items-center justify-content-center rounded-circle me-3" title="Student Profile">
                    <c:choose>
                        <c:when test="${not empty userName}">
                            <c:out value="${fn:toUpperCase(fn:substring(userName, 0, 1))}"/>
                        </c:when>
                        <c:otherwise>S</c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Welcome student & Logout -->
                <div class="d-flex flex-column align-items-start me-3 d-none d-md-flex" style="line-height: 1.2;">
                    <span class="text-secondary" style="font-size: 0.75rem;">Logged in as</span>
                    <strong class="text-dark small"><c:out value="${userName}"/></strong>
                </div>
                
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-medium" style="font-size: 0.85rem;">Logout</a>
            </div>
        </div>
    </div>
</nav>

<!-- JavaScript Context variables -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
    window.userRole = 'student';
</script>
<script src="${pageContext.request.contextPath}/js/notifications.js"></script>
