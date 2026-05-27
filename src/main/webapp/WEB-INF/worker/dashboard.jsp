<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Worker Dashboard - Smart Campus</title>
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
        .stat-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.02);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.05);
        }
        .complaint-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.02);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: #ffffff;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .complaint-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.06);
        }
        .card-badge {
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
    </style>
</head>
<body>

    <div class="container-fluid p-0">
        <div class="row g-0">
            
            <!-- SIDEBAR -->
            <div class="col-md-3 col-lg-2 sidebar p-4 d-flex flex-column">
                <div class="mb-4 pb-3 border-bottom border-secondary">
                    <a href="${pageContext.request.contextPath}/worker/dashboard" class="sidebar-brand text-decoration-none">Smart Campus</a>
                </div>
                
                <nav class="flex-grow-1">
                    <a href="${pageContext.request.contextPath}/worker/dashboard" class="sidebar-link active">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-card-checklist" viewBox="0 0 16 16">
                            <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2z"/>
                        </svg>
                        My Tasks
                    </a>
                    <a href="#" class="sidebar-link" onclick="alert('Profile section coming soon!')">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
                            <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
                        </svg>
                        Profile
                    </a>
                </nav>
                
                <div class="pt-3 border-top border-secondary">
                    <div class="text-white small fw-medium mb-3">Worker: <strong>${userName}</strong></div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm w-100 rounded-pill">Logout</a>
                </div>
            </div>
            
            <!-- MAIN CONTENT AREA -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Premium Worker Top Navbar -->
                <jsp:include page="/WEB-INF/includes/navbar-worker.jsp" />
                
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold text-dark">Worker Console</h2>
                        <p class="text-secondary small mb-0">View assigned complaints, schedule updates, and submit completion proofs.</p>
                    </div>
                </div>

                <!-- Top Summary Bar (3 Stat Cards) -->
                <div class="row g-4 mb-5">
                    <div class="col-md-4">
                        <div class="card stat-card bg-primary-subtle border-0 h-100 p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-primary fw-semibold small text-uppercase">Assigned</span>
                                    <h2 class="fw-bold text-primary display-5 mt-2 mb-0">${assignedCount}</h2>
                                </div>
                                <div class="bg-primary text-white p-3 rounded-4">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-bookmark-fill" viewBox="0 0 16 16">
                                        <path d="M2 2v13.5a.5.5 0 0 0 .74.439L8 13.069l5.26 2.87A.5.5 0 0 0 14 15.5V2a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card stat-card bg-warning-subtle border-0 h-100 p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-warning fw-semibold small text-uppercase">In Progress</span>
                                    <h2 class="fw-bold text-warning display-5 mt-2 mb-0">${inProgressCount}</h2>
                                </div>
                                <div class="bg-warning text-dark p-3 rounded-4">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-clock-history" viewBox="0 0 16 16">
                                        <path d="M8.515 1.019A7 7 0 0 0 8 1V0a8 8 0 0 1 .589.022zm2.004.45a7 7 0 0 0-.985-.299l.219-.976c.383.086.76.2 1.126.342zm1.37.71a7 7 0 0 0-.439-.27l.493-.87a8 8 0 0 1 .979.654l-.615.789a7 7 0 0 0-.418-.302zm1.834 1.39a7 7 0 0 0-.643-.533l.63-.775a8 8 0 0 1 .96.792l-.63.788a7 7 0 0 0-.317-.273"/>
                                        <path d="M10.854 7.854a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708 0l-.5.5a.5.5 0 0 0 0 .708L8.293 7H2.5a.5.5 0 0 0 0 1h5.793l-1.647 1.646a.5.5 0 0 0 0 .708l.5.5a.5.5 0 0 0 .708 0l3-3z"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card stat-card bg-success-subtle border-0 h-100 p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-success fw-semibold small text-uppercase">Completed</span>
                                    <h2 class="fw-bold text-success display-5 mt-2 mb-0">${completedCount}</h2>
                                </div>
                                <div class="bg-success text-white p-3 rounded-4">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-patch-check-fill" viewBox="0 0 16 16">
                                        <path d="M10.067.87a2.89 2.89 0 0 0-4.134 0l-.622.622-1.39-.021a2.89 2.89 0 0 0-2.924 2.924l.01.139-.62.622a2.89 2.89 0 0 0 0 4.134l.622.622-.02 1.39a2.89 2.89 0 0 0 2.923 2.924l.139-.01.622.62a2.89 2.89 0 0 0 4.134 0l.622-.622 1.39.02a2.89 2.89 0 0 0 2.924-2.923l-.01-.139.62-.622a2.89 2.89 0 0 0 0-4.134l-.622-.622.02-1.39a2.89 2.89 0 0 0-2.924-2.924l-.139.01zm-3.14 8.41a.5.5 0 0 1-.708 0L4.354 7.415a.5.5 0 1 1 .707-.708l1.39 1.39 3.473-3.473a.5.5 0 0 1 .707.708z"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Card Grid showing assigned complaints -->
                <h4 class="fw-bold text-dark mb-4">Assigned Tasks List</h4>
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty complaints}">
                            <div class="col-12 text-center py-5">
                                <div class="bg-white rounded-4 p-5 shadow-sm d-inline-block">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-inbox text-muted mb-3" viewBox="0 0 16 16">
                                        <path d="M4.98 4a.5.5 0 0 0-.39.188L1.54 8H6a.5.5 0 0 1 .5.5 1.5 1.5 0 1 0 3 0A.5.5 0 0 1 10 8h4.46l-3.05-3.812A.5.5 0 0 0 11.02 4zm9.917 5H10.268a2 2 0 0 1-3.536 0H1.103l-.5 4a.5.5 0 0 0 .5.5h13.8a.5.5 0 0 0 .5-.5zM1.08 13.63A1.5 1.5 0 0 1 .5 12.37l.58-4.63h13.84l.58 4.63a1.5 1.5 0 0 1-.58 1.26l-.42.315V14.5a.5.5 0 0 1-.5.5H2a.5.5 0 0 1-.5-.5v-.555z"/>
                                    </svg>
                                    <h5 class="fw-bold text-dark mb-2">No assigned complaints</h5>
                                    <p class="text-muted small mb-0">Good job! All your assigned tasks are completed or clear.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="comp" items="${complaints}">
                                <div class="col-md-6 col-lg-4" id="card-${comp.id}">
                                    <div class="card complaint-card p-4">
                                        
                                        <!-- Header Badges -->
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="badge card-badge bg-primary-subtle text-primary text-uppercase">
                                                <c:choose>
                                                    <c:when test="${comp.category == 'hostel'}">Hostel Issue</c:when>
                                                    <c:when test="${comp.category == 'classroom'}">Classroom</c:when>
                                                    <c:when test="${comp.category == 'electricity'}">Electricity</c:when>
                                                    <c:when test="${comp.category == 'water'}">Water Supply</c:when>
                                                    <c:when test="${comp.category == 'lab'}">Computer Lab</c:when>
                                                    <c:otherwise><c:out value="${comp.category}"/></c:otherwise>
                                                </c:choose>
                                            </span>
                                            
                                            <span class="badge card-badge 
                                                <c:choose>
                                                    <c:when test="${comp.priority == 'low'}">bg-secondary-subtle text-secondary</c:when>
                                                    <c:when test="${comp.priority == 'medium'}">bg-warning-subtle text-warning</c:when>
                                                    <c:when test="${comp.priority == 'high'}">bg-danger-subtle text-danger</c:when>
                                                    <c:otherwise>bg-secondary-subtle text-secondary</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${comp.priority}"/> Priority
                                            </span>
                                        </div>

                                        <!-- Title -->
                                        <h5 class="card-title fw-bold text-dark mb-2" 
                                            title="<c:out value="${comp.title}"/>">
                                            <c:choose>
                                                <c:when test="${fn:length(comp.title) > 60}">
                                                    <c:out value="${fn:substring(comp.title, 0, 57)}..."/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${comp.title}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </h5>

                                        <!-- Student Details -->
                                        <p class="text-secondary small mb-3">
                                            Reported by: <strong><c:out value="${comp.studentName}"/></strong>
                                        </p>

                                        <!-- Dynamic Campus Location Info -->
                                        <div class="d-flex align-items-center gap-2 mb-3 bg-light p-2 rounded-3 text-secondary small">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-geo-alt-fill text-danger" viewBox="0 0 16 16">
                                                <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6"/>
                                            </svg>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${comp.category == 'hostel'}">Campus Boys Hostel, Block C</c:when>
                                                    <c:when test="${comp.category == 'classroom'}">Academic Block-II, Room 204</c:when>
                                                    <c:when test="${comp.category == 'electricity'}">Utility Power Grid, Substation B</c:when>
                                                    <c:when test="${comp.category == 'water'}">Central Overhead Tank House</c:when>
                                                    <c:when test="${comp.category == 'lab'}">Computer Science Lab-1, Main Block</c:when>
                                                    <c:otherwise>General Campus Premises</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <!-- Deadline Row -->
                                        <div class="mb-4">
                                            <c:choose>
                                                <c:when test="${not empty comp.deadline}">
                                                    <div class="d-flex align-items-center gap-2 
                                                        <c:choose>
                                                            <c:when test="${comp.isOverdue()}">text-danger fw-bold</c:when>
                                                            <c:otherwise>text-secondary</c:otherwise>
                                                        </c:choose> small">
                                                        <c:choose>
                                                            <c:when test="${comp.isOverdue()}">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-exclamation-triangle-fill text-danger animate-pulse" viewBox="0 0 16 16">
                                                                    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5m.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2"/>
                                                                </svg>
                                                                Overdue: <fmt:formatDate value="${comp.deadline}" pattern="MMM dd, yyyy"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-calendar3" viewBox="0 0 16 16">
                                                                    <path d="M14 0H2a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2M1 3.857C1 3.384 1.448 3 2 3h12c.552 0 1 3.84 1 3.857v10.286c0 .473-.448.857-1 .857H2c-.552 0-1-.384-1-.857z"/>
                                                                    <path d="M6.5 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2m3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
                                                                </svg>
                                                                Deadline: <fmt:formatDate value="${comp.deadline}" pattern="MMM dd, yyyy"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="d-flex align-items-center gap-2 text-muted small">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-calendar3" viewBox="0 0 16 16">
                                                            <path d="M14 0H2a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2"/>
                                                        </svg>
                                                        <span>No deadline scheduled</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Status Badge & Update Button -->
                                        <div class="mt-auto border-top pt-3">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <span class="small text-secondary">Status:</span>
                                                <span class="badge card-badge card-status-badge
                                                    <c:choose>
                                                        <c:when test="${comp.status == 'assigned'}">bg-primary text-white</c:when>
                                                        <c:when test="${comp.status == 'in_progress'}">bg-warning text-dark</c:when>
                                                        <c:when test="${comp.status == 'resolved'}">bg-success text-white</c:when>
                                                        <c:otherwise>bg-secondary text-white</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${comp.status == 'in_progress'}">In Progress</c:when>
                                                        <c:otherwise><c:out value="${comp.status}"/></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <c:choose>
                                                <c:when test="${comp.status == 'resolved'}">
                                                    <button type="button" class="btn btn-success w-100 rounded-pill py-2" disabled>
                                                        Completed ✓
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-primary w-100 rounded-pill py-2" 
                                                            onclick="openUpdateModal(${comp.id}, '${comp.status}', '<c:out value="${comp.title}"/>')">
                                                        Update Status
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </div>
    </div>

    <!-- UPDATE STATUS MODAL (Unified, dynamically populated) -->
    <div class="modal fade modal-custom" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="updateModalLabel">Update Task Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    
                    <!-- Quick Info Header -->
                    <div class="mb-4 bg-light p-3 rounded-3">
                        <div class="small text-secondary fw-semibold">Complaint Task</div>
                        <h6 class="fw-bold text-dark mb-1" id="modalTitleText">Title</h6>
                        <div class="small text-secondary">Current Status: <span id="modalCurrentStatusBadge" class="badge bg-secondary">status</span></div>
                    </div>
                    
                    <form id="updateStatusForm" enctype="multipart/form-data">
                        <!-- Hidden inputs -->
                        <input type="hidden" name="complaintId" id="modalComplaintId">
                        <input type="hidden" name="currentStatus" id="modalCurrentStatus">
                        
                        <!-- Status Selection (No backward transitions allowed) -->
                        <div class="mb-3">
                            <label for="newStatus" class="form-label small text-secondary fw-semibold">New Status</label>
                            <select class="form-select" name="newStatus" id="newStatus" onchange="toggleRemarksRequirement()">
                                <!-- Populated dynamically by JS -->
                            </select>
                        </div>
                        
                        <!-- Remarks Textarea -->
                        <div class="mb-3">
                            <label for="remark" class="form-label small text-secondary fw-semibold">
                                Worker Remarks <span id="remarksRequiredLabel" class="text-danger d-none">*</span>
                            </label>
                            <textarea class="form-control" name="remark" id="remark" rows="3" placeholder="Describe the status details or completion process..."></textarea>
                        </div>
                        
                        <!-- Proof Image Upload (Single, optional) -->
                        <div class="mb-3">
                            <label for="proofImage" class="form-label small text-secondary fw-semibold">Resolution Proof Image (Optional)</label>
                            <input class="form-control" type="file" name="proofImage" id="proofImage" accept="image/*">
                            <div class="form-text small">Accepted formats: JPG, PNG, GIF. Max size 5MB.</div>
                        </div>

                        <!-- Feedback message -->
                        <div id="errorMsg" class="alert alert-danger d-none py-2 small"></div>
                    </form>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary rounded-pill px-4" onclick="submitStatusUpdate()">Submit Update</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- AJAX & Modal Control JavaScript -->
    <script>
        function openUpdateModal(id, currentStatus, title) {
            document.getElementById('modalComplaintId').value = id;
            document.getElementById('modalCurrentStatus').value = currentStatus;
            document.getElementById('modalTitleText').textContent = title;
            document.getElementById('modalCurrentStatusBadge').textContent = currentStatus === 'in_progress' ? 'In Progress' : currentStatus;
            
            // Sync current status badge style
            let badgeClass = 'bg-secondary';
            if (currentStatus === 'assigned') badgeClass = 'bg-primary';
            else if (currentStatus === 'in_progress') badgeClass = 'bg-warning text-dark';
            document.getElementById('modalCurrentStatusBadge').className = 'badge ' + badgeClass;

            // Clear inputs
            document.getElementById('remark').value = '';
            document.getElementById('proofImage').value = '';
            document.getElementById('errorMsg').classList.add('d-none');

            // Set up Status options dynamically (No backward transitions allowed)
            const selectEl = document.getElementById('newStatus');
            selectEl.innerHTML = '';

            if (currentStatus === 'assigned') {
                selectEl.options.add(new Option('In Progress', 'in_progress'));
                selectEl.options.add(new Option('Resolved', 'resolved'));
            } else if (currentStatus === 'in_progress') {
                selectEl.options.add(new Option('Resolved', 'resolved'));
            }

            toggleRemarksRequirement();

            const modal = new bootstrap.Modal(document.getElementById('updateModal'));
            modal.show();
        }

        function toggleRemarksRequirement() {
            const newStatus = document.getElementById('newStatus').value;
            const label = document.getElementById('remarksRequiredLabel');
            const remarkTextarea = document.getElementById('remark');

            if (newStatus === 'resolved') {
                label.classList.remove('d-none');
                remarkTextarea.required = true;
            } else {
                label.classList.add('d-none');
                remarkTextarea.required = false;
            }
        }

        function submitStatusUpdate() {
            const form = document.getElementById('updateStatusForm');
            const newStatus = document.getElementById('newStatus').value;
            const remark = document.getElementById('remark').value.trim();
            const errorMsg = document.getElementById('errorMsg');

            // Validation: check if remarks are present when resolving
            if (newStatus === 'resolved' && !remark) {
                errorMsg.textContent = "Remarks are strictly required when resolving complaints.";
                errorMsg.classList.remove('d-none');
                return;
            }

            errorMsg.classList.add('d-none');

            // Asynchronous AJAX form submit using FormData
            const formData = new FormData(form);

            fetch('${pageContext.request.contextPath}/worker/updateStatus', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Success callback: refresh dashboard to update stats counters and ticket layout
                    window.location.reload();
                } else {
                    errorMsg.textContent = data.message;
                    errorMsg.classList.remove('d-none');
                }
            })
            .catch(err => {
                console.error("Error executing status update AJAX request:", err);
                errorMsg.textContent = "A server error occurred. Please try again.";
                errorMsg.classList.remove('d-none');
            });
        }
    </script>
</body>
</html>
