<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Premium Admin Header/Navbar CSS -->
<style>
    .admin-header {
        background-color: #ffffff;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
        border: 1px solid #f1f5f9;
        padding: 1rem 1.5rem;
        margin-bottom: 2rem;
        font-family: 'Outfit', sans-serif;
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
    
    .avatar-initials-admin {
        width: 38px;
        height: 38px;
        background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
        box-shadow: 0 4px 8px rgba(15, 23, 42, 0.2);
        font-size: 0.95rem;
        transition: transform 0.2s ease;
    }
    .avatar-initials-admin:hover {
        transform: scale(1.05);
    }
</style>

<div class="admin-header d-flex justify-content-between align-items-center flex-wrap gap-3">
    <!-- Left Hand: Title / Context Search placeholder -->
    <div class="d-flex align-items-center">
        <h5 class="fw-bold text-dark mb-0 me-3">Smart Campus Admin Portal</h5>
        <span class="badge bg-danger-subtle text-danger fw-semibold px-2 py-1 rounded">Control Panel</span>
    </div>
    
    <!-- Right Hand: Live Notifications & User profile avatar -->
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
                <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom bg-light">
                    <span class="fw-bold text-dark small">Notifications</span>
                    <button type="button" class="btn btn-link text-primary p-0 text-decoration-none small" id="nav-notifications-mark-all" style="font-size: 0.8rem;">
                        Mark all read
                    </button>
                </div>
                <div id="nav-notifications-list" style="max-height: 320px; overflow-y: auto;">
                    <!-- Populated dynamically via AJAX -->
                </div>
            </div>
        </div>
        
        <!-- Initials Circle Avatar -->
        <div class="avatar-initials-admin text-white fw-bold d-inline-flex align-items-center justify-content-center rounded-circle me-3" title="Admin Profile">
            <c:choose>
                <c:when test="${not empty userName}">
                    <c:out value="${fn:toUpperCase(fn:substring(userName, 0, 1))}"/>
                </c:when>
                <c:otherwise>A</c:otherwise>
            </c:choose>
        </div>
        
        <!-- User Welcome info -->
        <div class="d-flex flex-column align-items-start me-3 d-none d-md-flex" style="line-height: 1.2;">
            <span class="text-secondary" style="font-size: 0.75rem;">Administrator</span>
            <strong class="text-dark small"><c:out value="${userName}"/></strong>
        </div>
    </div>
</div>

<!-- JavaScript Context variables -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
    window.userRole = 'admin';
</script>
<script src="${pageContext.request.contextPath}/js/notifications.js"></script>
