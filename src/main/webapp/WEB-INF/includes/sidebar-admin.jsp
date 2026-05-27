<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!-- Mobile Navbar Header (visible only on mobile) -->
<nav class="navbar navbar-dark bg-dark d-md-none px-3 py-2 position-sticky top-0 w-100" style="z-index: 1001; height: 56px;">
    <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#adminSidebarOffcanvas" aria-controls="adminSidebarOffcanvas">
        <span class="navbar-toggler-icon"></span>
    </button>
    <span class="navbar-brand mb-0 h1 fs-6">Smart Campus Admin</span>
</nav>

<!-- Sidebar container for Desktop -->
<aside class="sidebar d-none d-md-flex">
    <div class="sidebar-brand">
        <i class="bi bi-buildings-fill text-primary me-2"></i>
        <span>Smart Campus</span>
    </div>
    
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${uri.endsWith('dashboard.jsp') || uri.endsWith('dashboard') ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i>Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/manageComplaints" class="sidebar-link ${uri.endsWith('manageComplaints.jsp') || uri.endsWith('manageComplaints') ? 'active' : ''}">
                <i class="bi bi-tools"></i>Complaints
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/manageBookings" class="sidebar-link ${uri.endsWith('manageBookings.jsp') || uri.endsWith('manageBookings') ? 'active' : ''}">
                <i class="bi bi-calendar-event"></i>Bookings
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/analytics" class="sidebar-link ${uri.endsWith('analytics.jsp') || uri.endsWith('analytics') ? 'active' : ''}">
                <i class="bi bi-pie-chart-fill"></i>Analytics
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/analytics" class="sidebar-link">
                <i class="bi bi-file-earmark-bar-graph"></i>Reports
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/manageComplaints" class="sidebar-link">
                <i class="bi bi-people-fill"></i>Workers
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/login?logout=true" class="sidebar-link text-danger border-0 p-0 m-0">
            <i class="bi bi-box-arrow-left"></i>Logout
        </a>
    </div>
</aside>

<!-- Sidebar Offcanvas for Mobile -->
<div class="offcanvas offcanvas-start bg-dark text-slate-300 d-md-none" tabindex="-1" id="adminSidebarOffcanvas" aria-labelledby="adminSidebarOffcanvasLabel" style="width: var(--sidebar-width);">
    <div class="offcanvas-header border-bottom border-secondary">
        <h5 class="offcanvas-title text-white fw-bold d-flex align-items-center" id="adminSidebarOffcanvasLabel">
            <i class="bi bi-buildings-fill text-primary me-2"></i>Smart Campus
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0 d-flex flex-column h-100">
        <ul class="sidebar-menu flex-grow-1">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${uri.endsWith('dashboard.jsp') || uri.endsWith('dashboard') ? 'active' : ''}" data-bs-dismiss="offcanvas">
                    <i class="bi bi-speedometer2"></i>Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manageComplaints" class="sidebar-link ${uri.endsWith('manageComplaints.jsp') || uri.endsWith('manageComplaints') ? 'active' : ''}" data-bs-dismiss="offcanvas">
                    <i class="bi bi-tools"></i>Complaints
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manageBookings" class="sidebar-link ${uri.endsWith('manageBookings.jsp') || uri.endsWith('manageBookings') ? 'active' : ''}" data-bs-dismiss="offcanvas">
                    <i class="bi bi-calendar-event"></i>Bookings
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/analytics" class="sidebar-link ${uri.endsWith('analytics.jsp') || uri.endsWith('analytics') ? 'active' : ''}" data-bs-dismiss="offcanvas">
                    <i class="bi bi-pie-chart-fill"></i>Analytics
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/analytics" class="sidebar-link" data-bs-dismiss="offcanvas">
                    <i class="bi bi-file-earmark-bar-graph"></i>Reports
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/manageComplaints" class="sidebar-link" data-bs-dismiss="offcanvas">
                    <i class="bi bi-people-fill"></i>Workers
                </a>
            </li>
        </ul>
        <div class="sidebar-footer border-top border-secondary">
            <a href="${pageContext.request.contextPath}/login?logout=true" class="sidebar-link text-danger border-0 p-0 m-0" data-bs-dismiss="offcanvas">
                <i class="bi bi-box-arrow-left"></i>Logout
            </a>
        </div>
    </div>
</div>
