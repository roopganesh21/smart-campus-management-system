<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Global Style Theme Sheet -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .card-custom {
            background-color: #ffffff;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            border: none;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .table-custom thead th {
            font-weight: 600;
            color: #475569;
            background-color: #f8fafc;
            border-bottom: 1.5px solid #e2e8f0;
            padding: 0.85rem;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .table-custom tbody td {
            padding: 1rem 0.85rem;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.9rem;
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
        <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp" />
        
        <!-- MAIN CONTENT AREA -->
        <div class="main-content flex-grow-1 p-4 fade-in">
            <!-- Premium Admin Top Navbar -->
            <jsp:include page="/WEB-INF/includes/navbar-admin.jsp" />
            
            <!-- Page Header -->
            <div class="mb-4">
                <h2 class="fw-bold text-dark">Real-Time Campus Analytics</h2>
                <p class="text-secondary small">System metrics overview, category trends, and monthly resolution monitoring.</p>
            </div>
                
                <!-- ROW 1: 4 Statistics Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="card stat-card bg-primary-subtle border-0 p-3 h-100">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h3 class="fw-bold text-primary mb-1">${stats['total']}</h3>
                                    <span class="text-primary-emphasis small fw-medium">Total Complaints</span>
                                </div>
                                <div class="bg-primary text-white p-2 rounded-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-bar-chart-fill" viewBox="0 0 16 16">
                                        <path d="M1 11a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1zm5-4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1zm5-5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1z"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card stat-card bg-success-subtle border-0 p-3 h-100">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h3 class="fw-bold text-success mb-1">${stats['resolved']}</h3>
                                    <span class="text-success-emphasis small fw-medium">Resolved Complaints</span>
                                </div>
                                <div class="bg-success text-white p-2 rounded-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card stat-card bg-warning-subtle border-0 p-3 h-100">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h3 class="fw-bold text-warning-emphasis mb-1">${stats['pending']}</h3>
                                    <span class="text-warning-emphasis small fw-medium">Pending Review</span>
                                </div>
                                <div class="bg-warning text-dark p-2 rounded-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-clock-fill" viewBox="0 0 16 16">
                                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71z"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card stat-card bg-info-subtle border-0 p-3 h-100">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h3 class="fw-bold text-info-emphasis mb-1">${workerCount}</h3>
                                    <span class="text-info-emphasis small fw-medium">Active Workers</span>
                                </div>
                                <div class="bg-info text-white p-2 rounded-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-people-fill" viewBox="0 0 16 16">
                                        <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-5.784 6A2.24 2.24 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.3 6.3 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1zM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 2: Doughnut Chart & Horizontal Bar Chart -->
                <div class="row g-4 mb-4">
                    <div class="col-md-5">
                        <div class="card card-custom h-100">
                            <h5 class="fw-bold text-dark mb-4">Complaints Status Distribution</h5>
                            <div style="height: 260px; position: relative;">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-7">
                        <div class="card card-custom h-100">
                            <h5 class="fw-bold text-dark mb-4">Complaints by Category</h5>
                            <div style="height: 260px; position: relative;">
                                <canvas id="categoryChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 3: Historical Line Chart -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card card-custom">
                            <h5 class="fw-bold text-dark mb-4">6-Month Historical Complaint Trend</h5>
                            <div style="height: 280px; position: relative;">
                                <canvas id="trendChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 4: Recent Complaints Table -->
                <div class="card card-custom">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold text-dark mb-0">Recent Complaint Registries</h5>
                        <a href="${pageContext.request.contextPath}/admin/manageComplaints" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-semibold text-decoration-none">
                            View All →
                        </a>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-custom align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Student</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty recentComplaints}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">No recent complaints found.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="comp" items="${recentComplaints}">
                                            <tr>
                                                <td class="fw-semibold text-secondary">#${comp.id}</td>
                                                <td class="fw-bold"><c:out value="${comp.studentName}"/></td>
                                                <td class="text-truncate" style="max-width: 250px;"><c:out value="${comp.title}"/></td>
                                                <td>
                                                    <span class="badge badge-custom 
                                                        <c:choose>
                                                            <c:when test="${comp.category == 'hostel'}">bg-info-subtle text-info</c:when>
                                                            <c:when test="${comp.category == 'classroom'}">bg-primary-subtle text-primary</c:when>
                                                            <c:when test="${comp.category == 'electricity'}">bg-warning-subtle text-warning</c:when>
                                                            <c:when test="${comp.category == 'water'}">bg-teal-subtle text-teal</c:when>
                                                            <c:when test="${comp.category == 'lab'}">bg-secondary-subtle text-secondary</c:when>
                                                            <c:otherwise>bg-dark-subtle text-dark</c:otherwise>
                                                        </c:choose>">
                                                        <c:out value="${comp.category}"/>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge badge-custom 
                                                        <c:choose>
                                                            <c:when test="${comp.priority == 'low'}">bg-secondary text-white</c:when>
                                                            <c:when test="${comp.priority == 'medium'}">bg-warning text-dark</c:when>
                                                            <c:when test="${comp.priority == 'high'}">bg-danger text-white</c:when>
                                                            <c:otherwise>bg-secondary text-white</c:otherwise>
                                                        </c:choose>">
                                                        <c:out value="${comp.priority}"/>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge badge-custom 
                                                        <c:choose>
                                                            <c:when test="${comp.status == 'pending'}">bg-secondary text-white</c:when>
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
                                                </td>
                                                <td class="text-secondary small">
                                                    <fmt:formatDate value="${comp.createdAt}" pattern="MMM dd, yyyy"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div> <!-- main-content closed -->
        </div> <!-- d-flex closed -->

    <!-- Chart.js 4.x CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

    <!-- Chart Initializer scripts parsing maps and lists -->
    <script>
        // Safely evaluate data variables injected from Servlet attributes
        const statusData = ${statusCountsJson};
        const categoryData = ${categoryCountsJson};
        const trendData = ${monthlyTrendJson};

        document.addEventListener("DOMContentLoaded", function() {
            // -------------------------------------------------------------
            // 1. DOUGHNUT CHART - COMPLAINT STATUS DISTRIBUTION
            // -------------------------------------------------------------
            const statusCanvas = document.getElementById('statusChart');
            const statusLabels = ['Pending', 'Assigned', 'In Progress', 'Resolved'];
            
            // Sync values from statusData structure
            const statusValues = [
                statusData.pending || 0,
                statusData.assigned || 0,
                statusData.in_progress || 0,
                statusData.resolved || 0
            ];

            new Chart(statusCanvas, {
                type: 'doughnut',
                data: {
                    labels: statusLabels,
                    datasets: [{
                        data: statusValues,
                        backgroundColor: ['#ffc107', '#0dcaf0', '#fd7e14', '#198754'],
                        borderWidth: 2,
                        borderColor: '#ffffff',
                        hoverOffset: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                boxWidth: 12,
                                padding: 15,
                                font: {
                                    family: 'Outfit',
                                    size: 12
                                }
                            }
                        }
                    }
                }
            });

            // -------------------------------------------------------------
            // 2. HORIZONTAL BAR CHART - COMPLAINTS BY CATEGORY
            // -------------------------------------------------------------
            const categoryCanvas = document.getElementById('categoryChart');
            
            // Extract raw keys and values directly from category counts map
            const categoryKeys = Object.keys(categoryData);
            const categoryValues = Object.values(categoryData);

            // Translate keys to user-friendly titles
            const categoryLabels = categoryKeys.map(key => {
                switch(key.toLowerCase()) {
                    case 'hostel': return 'Hostel Issue';
                    case 'classroom': return 'Classroom';
                    case 'electricity': return 'Electricity';
                    case 'water': return 'Water Supply';
                    case 'lab': return 'Computer Lab';
                    default: return key.charAt(0).toUpperCase() + key.slice(1);
                }
            });

            // Setup professional color array
            const barColors = ['#6366f1', '#3b82f6', '#14b8a6', '#f59e0b', '#ef4444', '#64748b'];

            new Chart(categoryCanvas, {
                type: 'bar',
                data: {
                    labels: categoryLabels,
                    datasets: [{
                        data: categoryValues,
                        backgroundColor: barColors.slice(0, categoryLabels.length),
                        borderRadius: 8,
                        barThickness: 16
                    }]
                },
                options: {
                    indexAxis: 'y', // Renders the bar chart horizontally
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                stepSize: 1,
                                font: {
                                    family: 'Outfit'
                                }
                            }
                        },
                        y: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: {
                                    family: 'Outfit',
                                    weight: 'bold'
                                }
                            }
                        }
                    }
                }
            });

            // -------------------------------------------------------------
            // 3. LINE CHART - MONTHLY HISTORICAL TREND
            // -------------------------------------------------------------
            const trendCanvas = document.getElementById('trendChart');
            
            // Extract sorted chronological months and complaints counts from array of maps
            const trendLabels = trendData.map(item => item.month);
            const trendValues = trendData.map(item => item.count);

            // Create canvas gradient fill below line
            const ctx = trendCanvas.getContext('2d');
            const gradient = ctx.createLinearGradient(0, 0, 0, 250);
            gradient.addColorStop(0, 'rgba(79, 70, 229, 0.25)');
            gradient.addColorStop(1, 'rgba(79, 70, 229, 0.00)');

            new Chart(trendCanvas, {
                type: 'line',
                data: {
                    labels: trendLabels,
                    datasets: [{
                        label: 'Complaints Opened',
                        data: trendValues,
                        borderColor: '#4f46e5',
                        borderWidth: 3,
                        backgroundColor: gradient,
                        fill: true,
                        tension: 0.4, // Bezier curved rendering
                        pointBackgroundColor: '#4f46e5',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 6,
                        pointHoverRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                color: '#f1f5f9'
                            },
                            ticks: {
                                font: {
                                    family: 'Outfit'
                                }
                            }
                        },
                        y: {
                            grid: {
                                color: '#f1f5f9'
                            },
                            ticks: {
                                stepSize: 1,
                                font: {
                                    family: 'Outfit'
                                }
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
