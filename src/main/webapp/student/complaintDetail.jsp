<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Detail - Smart Campus</title>
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
        .meta-label {
            font-size: 0.8rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
            margin-bottom: 0.2rem;
        }
        .meta-val {
            font-weight: 500;
            color: #1e293b;
            font-size: 0.95rem;
        }
        .desc-box {
            border: 1.5px dashed #cbd5e1;
            border-radius: 12px;
            background-color: #f8fafc;
            padding: 1.25rem;
            color: #334155;
            line-height: 1.6;
            font-size: 0.95rem;
        }
        .badge-custom {
            font-weight: 500;
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 6px;
        }
        .thumbnail-custom {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 10px;
            border: 1.5px solid #e2e8f0;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .thumbnail-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
            border-color: #4f46e5;
        }

        /* Timeline styling */
        .timeline-wrapper {
            position: relative;
            padding-left: 24px;
        }
        .timeline-wrapper::before {
            content: '';
            position: absolute;
            top: 10px;
            left: 5px;
            bottom: 0;
            width: 2px;
            border-left: 2px dashed #e2e8f0;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
        }
        .timeline-indicator {
            position: absolute;
            left: -24px;
            top: 4px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #cbd5e1;
            border: 2px solid white;
            box-shadow: 0 0 0 3px rgba(203, 213, 225, 0.2);
            z-index: 2;
        }
        .timeline-indicator.pending { background-color: #64748b; box-shadow: 0 0 0 3px rgba(100, 116, 139, 0.2); }
        .timeline-indicator.assigned { background-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2); }
        .timeline-indicator.in_progress { background-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2); }
        .timeline-indicator.resolved { background-color: #10b981; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.2); }

        .timeline-card {
            background-color: #f8fafc;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            border: 1px solid #f1f5f9;
        }

        /* Stars CSS rating */
        .rating-stars {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
        }
        .rating-stars input {
            display: none;
        }
        .rating-stars label {
            font-size: 2.5rem;
            color: #cbd5e1;
            cursor: pointer;
            transition: color 0.15s ease;
            margin-right: 0.25rem;
        }
        .rating-stars label:hover,
        .rating-stars label:hover ~ label,
        .rating-stars input:checked ~ label {
            color: #f59e0b;
        }
        .read-only-stars {
            font-size: 1.5rem;
            color: #f59e0b;
            letter-spacing: -2px;
        }
        .read-only-stars .star-empty {
            color: #cbd5e1;
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
                    <span class="text-secondary small fw-medium me-4">Welcome, <strong class="text-dark">${userName}</strong></span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm rounded-pill px-3">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Container -->
    <div class="container pb-5">
        
        <!-- Breadcrumbs -->
        <div class="mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/trackComplaints">Complaints</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Detail</li>
                </ol>
            </nav>
        </div>

        <div class="row">
            
            <!-- LEFT COLUMN: Complaint Details -->
            <div class="col-lg-8">
                
                <!-- Complaint Information Card -->
                <div class="card card-custom">
                    <div class="d-flex justify-content-between align-items-start mb-4 flex-wrap">
                        <div class="me-3">
                            <span class="badge badge-custom bg-light-subtle text-secondary border mb-2">Complaint ID: #${complaint.id}</span>
                            <h3 class="fw-bold text-dark mb-0"><c:out value="${complaint.title}" /></h3>
                        </div>
                        <span class="badge badge-custom mt-2
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
                    </div>

                    <!-- Metadata Grid -->
                    <div class="row g-4 mb-4 border-bottom pb-4">
                        <div class="col-6 col-md-4">
                            <div class="meta-label">Category</div>
                            <div class="meta-val">
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
                            </div>
                        </div>
                        <div class="col-6 col-md-4">
                            <div class="meta-label">Priority</div>
                            <div class="meta-val">
                                <span class="badge badge-custom 
                                    <c:choose>
                                        <c:when test="${complaint.priority == 'low'}">bg-secondary text-white</c:when>
                                        <c:when test="${complaint.priority == 'medium'}">bg-warning text-dark</c:when>
                                        <c:when test="${complaint.priority == 'high'}">bg-danger text-white</c:when>
                                        <c:otherwise>bg-secondary text-white</c:otherwise>
                                    </c:choose>">
                                    <c:out value="${complaint.priority}"/>
                                </span>
                            </div>
                        </div>
                        <div class="col-6 col-md-4">
                            <div class="meta-label">Date Raised</div>
                            <div class="meta-val small text-secondary">
                                <fmt:formatDate value="${complaint.createdAt}" pattern="MMM dd, yyyy hh:mm a"/>
                            </div>
                        </div>
                        <div class="col-6 col-md-4">
                            <div class="meta-label">Last Updated</div>
                            <div class="meta-val small text-secondary">
                                <fmt:formatDate value="${complaint.updatedAt}" pattern="MMM dd, yyyy hh:mm a"/>
                            </div>
                        </div>
                        <div class="col-12 col-md-8">
                            <div class="meta-label">Assigned Worker</div>
                            <div class="meta-val">
                                <c:choose>
                                    <c:when test="${not empty complaint.workerName}">
                                        <div class="d-flex align-items-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi fill-primary me-2" viewBox="0 0 16 16">
                                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
                                            </svg>
                                            <c:out value="${complaint.workerName}" />
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted italic small">Pending Assignment</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Description Section -->
                    <h5 class="fw-bold text-dark mb-3">Description</h5>
                    <div class="desc-box mb-4">
                        <c:out value="${complaint.description}" />
                    </div>

                    <!-- Uploaded Images Section -->
                    <c:if test="${not empty images}">
                        <h5 class="fw-bold text-dark mb-3">Supporting Attachments</h5>
                        <div class="row g-3 mb-3">
                            <c:forEach var="img" items="${images}" varStatus="loop">
                                <div class="col-4 col-md-3">
                                    <img src="${pageContext.request.contextPath}/${img.imagePath}" class="thumbnail-custom" alt="Attachment" onclick="openLightbox(${loop.index})">
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                </div>

                <!-- BOTTOM SECTION: Feedback Form / Submitted Feedback -->
                <c:if test="${complaint.status == 'resolved'}">
                    
                    <c:choose>
                        <c:when test="${!feedbackExists}">
                            <!-- Feedback Submission Form -->
                            <div class="card card-custom border-left-warning shadow-sm">
                                <h5 class="fw-bold text-dark mb-2">We value your Feedback!</h5>
                                <p class="text-secondary small mb-4">Please rate the service resolved for this complaint.</p>
                                
                                <form action="${pageContext.request.contextPath}/student/submitFeedback" method="POST">
                                    <input type="hidden" name="complaintId" value="${complaint.id}">
                                    
                                    <!-- Stars Rating -->
                                    <div class="mb-3">
                                        <label class="form-label d-block text-secondary small fw-medium">Satisfactory Rating</label>
                                        <div class="rating-stars">
                                            <input type="radio" id="star5" name="rating" value="5" required/><label for="star5" title="Excellent">★</label>
                                            <input type="radio" id="star4" name="rating" value="4"/><label for="star4" title="Good">★</label>
                                            <input type="radio" id="star3" name="rating" value="3"/><label for="star3" title="Average">★</label>
                                            <input type="radio" id="star2" name="rating" value="2"/><label for="star2" title="Poor">★</label>
                                            <input type="radio" id="star1" name="rating" value="1"/><label for="star1" title="Very Poor">★</label>
                                        </div>
                                    </div>

                                    <!-- Comments -->
                                    <div class="mb-4">
                                        <label for="comment" class="form-label text-secondary small fw-medium">Optional Review Comment</label>
                                        <textarea class="form-control" id="comment" name="comment" rows="3" placeholder="Share your experience resolving this issue..."></textarea>
                                    </div>

                                    <!-- Submit -->
                                    <button type="submit" class="btn btn-primary btn-primary-custom px-4">Submit Review</button>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Feedback Read-Only Card -->
                            <div class="card card-custom bg-light border-0 shadow-sm">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="fw-bold text-dark mb-0">Your Review</h5>
                                    <!-- Read-Only Stars -->
                                    <div class="read-only-stars" aria-label="Rating: ${feedback.rating} stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= feedback.rating}">★</c:when>
                                                <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </div>
                                <blockquote class="blockquote mb-0 fs-6 text-secondary" style="border-left: 3px solid #f59e0b; padding-left: 1rem;">
                                    <p class="mb-1 italic"><c:out value="${empty feedback.comment ? 'No written review comments.' : feedback.comment}" /></p>
                                    <footer class="blockquote-footer small mt-1">Submitted on <fmt:formatDate value="${feedback.createdAt}" pattern="MMMM dd, yyyy"/></footer>
                                </blockquote>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </c:if>

            </div>

            <!-- RIGHT COLUMN: Status Timeline -->
            <div class="col-lg-4">
                <div class="card card-custom">
                    <h5 class="fw-bold text-dark mb-4">Tracking History</h5>
                    
                    <c:choose>
                        <c:when test="${empty logs}">
                            <p class="text-muted italic small">No audit history found.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="timeline-wrapper">
                                <!-- Loops backwards to show most recent at top -->
                                <c:forEach var="i" begin="0" end="${fn:length(logs) - 1}">
                                    <c:set var="log" value="${logs[fn:length(logs) - 1 - i]}" />
                                    
                                    <div class="timeline-item">
                                        <!-- Node Indicator with status colors -->
                                        <div class="timeline-indicator ${log.newStatus}"></div>
                                        
                                        <!-- Node details -->
                                        <div class="timeline-card">
                                            <div class="d-flex justify-content-between align-items-start mb-2 flex-wrap">
                                                <span class="badge badge-custom text-uppercase
                                                    <c:choose>
                                                        <c:when test="${log.newStatus == 'pending'}">bg-secondary-subtle text-secondary</c:when>
                                                        <c:when test="${log.newStatus == 'assigned'}">bg-primary-subtle text-primary</c:when>
                                                        <c:when test="${log.newStatus == 'in_progress'}">bg-warning-subtle text-warning</c:when>
                                                        <c:when test="${log.newStatus == 'resolved'}">bg-success-subtle text-success</c:when>
                                                        <c:otherwise>bg-secondary-subtle text-secondary</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${log.newStatus == 'in_progress'}">In Progress</c:when>
                                                        <c:otherwise><c:out value="${log.newStatus}"/></c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="text-muted" style="font-size: 0.75rem;">
                                                    <fmt:formatDate value="${log.changedAt}" pattern="MMM dd, HH:mm"/>
                                                </span>
                                            </div>

                                            <div class="small text-secondary mb-1">
                                                By: <strong class="text-dark"><c:out value="${log.changedByName}"/></strong>
                                            </div>

                                            <!-- Old Status -> New Status -->
                                            <div class="small text-secondary mb-2" style="font-size: 0.8rem;">
                                                <c:choose>
                                                    <c:when test="${not empty log.oldStatus}">
                                                        <c:out value="${log.oldStatus}"/> &rarr; <c:out value="${log.newStatus}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Filed New Complaint
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <c:if test="${not empty log.remark}">
                                                <div class="text-secondary small italic bg-white p-2 rounded border border-light-subtle">
                                                    "<c:out value="${log.remark}"/>"
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>

        </div>

    </div>

    <!-- Bootstrap 5.3 Lightbox Modal -->
    <div class="modal fade" id="lightboxModal" tabindex="-1" aria-labelledby="lightboxModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content bg-transparent border-0">
                <div class="modal-header border-0 p-0 position-absolute w-100 justify-content-end pe-3 pt-3" style="z-index: 10;">
                    <button type="button" class="btn-close btn-close-white bg-dark opacity-75 rounded-circle p-2" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0 text-center position-relative">
                    <img id="lightboxImage" src="" class="img-fluid rounded shadow-lg max-vh-80" alt="Full Attachment">
                    
                    <!-- Prev/Next Controls -->
                    <button class="btn btn-dark opacity-50 position-absolute top-50 start-0 translate-middle-y ms-3 rounded-circle" style="width: 44px; height: 44px;" onclick="prevImage()">
                        &larr;
                    </button>
                    <button class="btn btn-dark opacity-50 position-absolute top-50 end-0 translate-middle-y me-3 rounded-circle" style="width: 44px; height: 44px;" onclick="nextImage()">
                        &rarr;
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Lightbox Navigation Scripts -->
    <script>
        let currentImageIndex = 0;
        const imagesList = [
            <c:forEach var="img" items="${images}" varStatus="loop">
                "${pageContext.request.contextPath}/${img.imagePath}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        function openLightbox(index) {
            currentImageIndex = index;
            updateLightboxImage();
            const modal = new bootstrap.Modal(document.getElementById('lightboxModal'));
            modal.show();
        }

        function updateLightboxImage() {
            const imgEl = document.getElementById('lightboxImage');
            imgEl.src = imagesList[currentImageIndex];
        }

        function prevImage() {
            if (imagesList.length === 0) return;
            currentImageIndex = (currentImageIndex - 1 + imagesList.length) % imagesList.length;
            updateLightboxImage();
        }

        function nextImage() {
            if (imagesList.length === 0) return;
            currentImageIndex = (currentImageIndex + 1) % imagesList.length;
            updateLightboxImage();
        }
    </script>
</body>
</html>
