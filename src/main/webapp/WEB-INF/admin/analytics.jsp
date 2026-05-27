<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics Dashboard - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    
    <style>
        .conic-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: var(--card-shadow);
        }
        .conic-progress {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            /* Pure CSS Conic Gradient dynamically generated on serverside JSTL value */
            background: conic-gradient(var(--primary) ${analyticsData.resolutionRate}%, #e2e8f0 0);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            transition: var(--transition);
        }
        .conic-progress::after {
            content: "";
            position: absolute;
            width: 130px;
            height: 130px;
            border-radius: 50%;
            background: #ffffff;
            z-index: 2;
        }
        .conic-progress-text {
            position: absolute;
            font-size: 1.8rem;
            font-weight: 700;
            color: #0f172a;
            z-index: 10;
        }
        .chart-card {
            border: none;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            background: #ffffff;
            padding: 1.5rem;
            height: 100%;
        }
        .worker-star {
            color: #f59e0b;
            margin-right: 2px;
        }
        .export-btn-container {
            border-radius: 15px;
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            color: #ffffff;
            padding: 1.5rem 2rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
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

    <div class="d-flex">
        <!-- Sidebar Navigation -->
        <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp" />

        <!-- Main Workspace -->
        <div class="main-content flex-grow-1 p-4 fade-in">
            
            <!-- Header Block -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-0">System Analytics &amp; Reports</h2>
                    <p class="text-secondary small mb-0">Real-time resolution rates, worker KPIs, and dynamic reporting datasets</p>
                </div>
            </div>

            <!-- Export Actions Row (Section 4) -->
            <div class="export-btn-container d-flex flex-wrap justify-content-between align-items-center gap-3">
                <div>
                    <h5 class="fw-bold mb-1"><i class="bi bi-file-earmark-bar-graph me-2"></i>Export campus analytical datasets</h5>
                    <p class="text-light-50 small mb-0">Compile all raised complaints, statuses, and performance logs into production documents</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin/export?type=pdf" class="btn btn-danger px-4 py-2 rounded-3 fw-semibold shadow-sm text-white">
                        <i class="bi bi-file-earmark-pdf me-2"></i>Export PDF Report
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/export?type=excel" class="btn btn-success px-4 py-2 rounded-3 fw-semibold shadow-sm text-white">
                        <i class="bi bi-file-earmark-excel me-2"></i>Export Excel Spreadsheet
                    </a>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <!-- Circular Resolution Progress (Section 1) -->
                <div class="col-lg-4">
                    <div class="conic-container h-100">
                        <h6 class="fw-bold text-slate-800 text-center mb-3">Overall Resolution Rate</h6>
                        <div class="conic-progress mb-3">
                            <span class="conic-progress-text">
                                <fmt:formatNumber value="${analyticsData.resolutionRate}" maxFractionDigits="1" />%
                            </span>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">
                            <c:out value="${analyticsData.resolvedThisMonth}" /> of <c:out value="${analyticsData.totalThisMonth}" />
                        </h4>
                        <p class="text-secondary small text-center mb-0">complaints resolved in the current month</p>
                    </div>
                </div>

                <!-- Chart B (Radar Chart of distributions) -->
                <div class="col-lg-8">
                    <div class="chart-card">
                        <h6 class="fw-bold text-slate-800 mb-3"><i class="bi bi-graph-up-arrow me-2"></i>Category Distributions (Current vs. Previous Month)</h6>
                        <div style="position: relative; height: 260px;">
                            <canvas id="radarChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chart A (Bar Chart of resolution times) -->
            <div class="row g-4 mb-4">
                <div class="col-12">
                    <div class="chart-card">
                        <h6 class="fw-bold text-slate-800 mb-3"><i class="bi bi-alarm me-2"></i>Average Resolution Time per Category (Days)</h6>
                        <div style="position: relative; height: 300px;">
                            <canvas id="barChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Worker Ratings (Section 3) -->
            <div class="card chart-card mb-5">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-slate-800 mb-0"><i class="bi bi-people me-2"></i>Maintenance Worker Performance Leaderboard</h6>
                    <span class="badge bg-primary px-3 py-2 rounded-pill small">Sorted by Resolution Rate</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Worker Name</th>
                                <th class="text-center">Complaints Assigned</th>
                                <th class="text-center">Complaints Resolved</th>
                                <th class="text-center">Resolution Rate</th>
                                <th>Average User Rating</th>
                                <th class="text-center">Performance Badge</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="w" items="${workerRatings}">
                                <tr>
                                    <td class="fw-semibold text-dark"><c:out value="${w.workerName}" /></td>
                                    <td class="text-center"><c:out value="${w.assignedCount}" /></td>
                                    <td class="text-center"><c:out value="${w.resolvedCount}" /></td>
                                    <td class="text-center fw-bold">
                                        <fmt:formatNumber value="${w.resolutionRate}" maxFractionDigits="1" />%
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <span class="fw-bold text-dark me-2">
                                                <fmt:formatNumber value="${w.avgRating}" maxFractionDigits="1" />
                                            </span>
                                            <!-- Stars Display -->
                                            <div>
                                                <c:forEach begin="1" end="5" var="star">
                                                    <i class="bi ${star <= w.avgRating ? 'bi-star-fill worker-star' : 'bi-star text-muted'}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${w.avgRating >= 4.0 && w.resolutionRate > 80.0}">
                                                <span class="badge bg-success-subtle text-success px-3 py-2 rounded-pill fw-semibold">Excellent</span>
                                            </c:when>
                                            <c:when test="${w.avgRating >= 3.0}">
                                                <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">Good</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning px-3 py-2 rounded-pill fw-semibold">Needs Improvement</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty workerRatings}">
                                <tr>
                                    <td colspan="6" class="text-center text-secondary py-4">No worker rating records resolved currently.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Chart.js Library CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const labels = ${labelsJson};
            
            // ----------------------------------------------------
            // CHART A: Bar Chart - Average Resolution Time
            // ----------------------------------------------------
            const avgDays = ${avgResDaysJson};
            // Dynamic bar colors based on duration thresholds
            const barColors = avgDays.map(d => {
                if (d < 3.0) return 'rgba(16, 185, 129, 0.85)'; // Green
                if (d <= 7.0) return 'rgba(245, 158, 11, 0.85)'; // Orange
                return 'rgba(239, 68, 68, 0.85)'; // Red
            });
            const barBorders = avgDays.map(d => {
                if (d < 3.0) return 'rgba(16, 185, 129, 1)';
                if (d <= 7.0) return 'rgba(245, 158, 11, 1)';
                return 'rgba(239, 68, 68, 1)';
            });

            const barCtx = document.getElementById('barChart').getContext('2d');
            new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: labels.map(l => l.charAt(0).toUpperCase() + l.slice(1)),
                    datasets: [{
                        label: 'Average Days to Resolve',
                        data: avgDays,
                        backgroundColor: barColors,
                        borderColor: barBorders,
                        borderWidth: 1.5,
                        borderRadius: 8,
                        barThickness: 32
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Average Days', font: { weight: 'bold' } }
                        }
                    }
                }
            });

            // ----------------------------------------------------
            // CHART B: Radar Chart - Monthly Distribution
            // ----------------------------------------------------
            const currentCounts = ${currentMonthCountsJson};
            const prevCounts = ${prevMonthCountsJson};

            const radarCtx = document.getElementById('radarChart').getContext('2d');
            new Chart(radarCtx, {
                type: 'radar',
                data: {
                    labels: labels.map(l => l.charAt(0).toUpperCase() + l.slice(1)),
                    datasets: [
                        {
                            label: 'Current Month',
                            data: currentCounts,
                            backgroundColor: 'rgba(37, 99, 235, 0.2)', // #2563eb
                            borderColor: 'rgba(37, 99, 235, 1)',
                            pointBackgroundColor: 'rgba(37, 99, 235, 1)',
                            borderWidth: 2
                        },
                        {
                            label: 'Previous Month',
                            data: prevCounts,
                            backgroundColor: 'rgba(100, 116, 139, 0.2)', // #64748b
                            borderColor: 'rgba(100, 116, 139, 1)',
                            pointBackgroundColor: 'rgba(100, 116, 139, 1)',
                            borderWidth: 2
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'right' }
                    },
                    scales: {
                        r: {
                            angleLines: { display: true },
                            suggestedMin: 0
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
