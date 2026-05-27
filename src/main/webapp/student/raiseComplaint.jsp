<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Raise a Complaint - Smart Campus</title>
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
        .btn-check:checked + .btn-outline-success {
            background-color: #10b981;
            color: #ffffff;
            border-color: #10b981;
        }
        .btn-check:checked + .btn-outline-warning {
            background-color: #f59e0b;
            color: #ffffff;
            border-color: #f59e0b;
        }
        .btn-check:checked + .btn-outline-danger {
            background-color: #ef4444;
            color: #ffffff;
            border-color: #ef4444;
        }
        .priority-btn {
            border-radius: 10px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }
        .btn-primary-custom {
            background-color: #4f46e5;
            border: none;
            border-radius: 10px;
            padding: 0.75rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .btn-primary-custom:hover {
            background-color: #4338ca;
            transform: translateY(-1px);
        }
        .thumbnail-container {
            position: relative;
            display: inline-block;
            margin: 8px;
        }
        .thumbnail-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 10px;
            border: 1.5px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .remove-btn {
            position: absolute;
            top: -6px;
            right: -6px;
            background-color: #ef4444;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            border: none;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s ease;
        }
        .remove-btn:hover {
            transform: scale(1.1);
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
    </style>
</head>
<body>

    <!-- Premium Top Navigation Bar -->
    <jsp:include page="/WEB-INF/includes/navbar-student.jsp" />

    <!-- Main Content Container -->
    <div class="container pb-5">
        
        <!-- Page Header & Breadcrumbs -->
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h2 class="fw-bold text-dark mb-0">Raise a Complaint</h2>
                <nav aria-label="breadcrumb" class="mt-2">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Home</a></li>
                        <li class="breadcrumb-item text-secondary">Complaints</li>
                        <li class="breadcrumb-item active" aria-current="page">New</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8 mx-auto">

                <!-- Alert Message Displays -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger d-flex align-items-center mb-4 border-0 shadow-sm rounded-4" role="alert">
                        <svg class="bi flex-shrink-0 me-2" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                        </svg>
                        <div><c:out value="${errorMessage}" /></div>
                    </div>
                </c:if>

                <!-- Main Form Card -->
                <div class="card card-custom">
                    <form action="${pageContext.request.contextPath}/student/raiseComplaint" method="POST" enctype="multipart/form-data" novalidate class="needs-validation" id="complaintForm">
                        
                        <!-- SECTION 1: Complaint Details -->
                        <h5 class="fw-bold text-primary mb-4 pb-2 border-bottom">Section 1 — Complaint Details</h5>
                        
                        <!-- Title Field -->
                        <div class="mb-3">
                            <label for="title" class="form-label">Complaint Title</label>
                            <input type="text" class="form-control" id="title" name="title" required minlength="5" placeholder="Brief one-line description" value="<c:out value="${title}" />">
                            <div class="invalid-feedback">Please enter a valid title (at least 5 characters).</div>
                        </div>

                        <!-- Category Select -->
                        <div class="mb-3">
                            <label for="category" class="form-label">Category</label>
                            <select class="form-select" id="category" name="category" required>
                                <option value="" disabled selected>Select category...</option>
                                <option value="hostel" ${category == 'hostel' ? 'selected' : ''}>Hostel Issue</option>
                                <option value="classroom" ${category == 'classroom' ? 'selected' : ''}>Classroom/Furniture</option>
                                <option value="electricity" ${category == 'electricity' ? 'selected' : ''}>Electricity</option>
                                <option value="water" ${category == 'water' ? 'selected' : ''}>Water Supply</option>
                                <option value="lab" ${category == 'lab' ? 'selected' : ''}>Computer Lab</option>
                                <option value="other" ${category == 'other' ? 'selected' : ''}>Other</option>
                            </select>
                            <div class="invalid-feedback">Please select a valid complaint category.</div>
                        </div>

                        <!-- Priority Radio Button Group -->
                        <div class="mb-4">
                            <label class="form-label d-block">Priority Level</label>
                            <div class="btn-group w-100" role="group" aria-label="Complaint Priority">
                                <input type="radio" class="btn-check" name="priority" id="priorityLow" value="low" autocomplete="off" ${priority == 'low' ? 'checked' : ''}>
                                <label class="btn btn-outline-success priority-btn" for="priorityLow">Low</label>

                                <input type="radio" class="btn-check" name="priority" id="priorityMedium" value="medium" autocomplete="off" ${priority == null || priority == 'medium' ? 'checked' : ''}>
                                <label class="btn btn-outline-warning priority-btn" for="priorityMedium">Medium</label>

                                <input type="radio" class="btn-check" name="priority" id="priorityHigh" value="high" autocomplete="off" ${priority == 'high' ? 'checked' : ''}>
                                <label class="btn btn-outline-danger priority-btn" for="priorityHigh">High</label>
                            </div>
                        </div>

                        <!-- Description Textarea -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between">
                                <label for="description" class="form-label">Detailed Description</label>
                                <span class="text-muted small" id="charCounter">0/500 characters</span>
                            </div>
                            <textarea class="form-control" id="description" name="description" required minlength="20" maxlength="500" rows="5" placeholder="Provide a descriptive explanation of the problem (minimum 20 characters)..."><c:out value="${description}" /></textarea>
                            <div class="invalid-feedback">Please provide a descriptive explanation (minimum 20 characters).</div>
                        </div>

                        <!-- SECTION 2: Supporting Images -->
                        <h5 class="fw-bold text-primary mb-4 pb-2 border-bottom mt-5">Section 2 — Supporting Images (Optional)</h5>
                        
                        <div class="mb-4">
                            <label for="imageUploads" class="form-label">Upload Supporting Files</label>
                            <input class="form-control" type="file" id="imageUploads" name="images" multiple accept="image/*">
                            <input type="hidden" id="imageCount" name="imageCount" value="0">
                            <div class="form-text text-muted small mt-2">
                                Max 5 images, 5MB each. Accepted formats: JPG, PNG, GIF
                            </div>
                        </div>

                        <!-- Image Preview Grid -->
                        <div class="mb-4 d-flex flex-wrap justify-content-start" id="previewGrid"></div>

                        <!-- Submit Button with loading feedback -->
                        <div class="d-grid mt-5">
                            <button type="submit" class="btn btn-primary btn-primary-custom" id="submitBtn">
                                <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true" style="display:none;" id="btnSpinner"></span>
                                <span id="btnText">Submit Complaint</span>
                            </button>
                        </div>

                    </form>
                </div>

            </div>
        </div>

    </div>

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side Vanilla JS Validations and File Previews -->
    <script>
        (() => {
            'use strict';

            const form = document.getElementById('complaintForm');
            const description = document.getElementById('description');
            const charCounter = document.getElementById('charCounter');
            const imageUploads = document.getElementById('imageUploads');
            const imageCountInput = document.getElementById('imageCount');
            const previewGrid = document.getElementById('previewGrid');
            const submitBtn = document.getElementById('submitBtn');
            const btnSpinner = document.getElementById('btnSpinner');
            const btnText = document.getElementById('btnText');

            // 1. Live Character Counter for Description Textarea
            description.addEventListener('input', () => {
                const count = description.value.length;
                charCounter.textContent = `${count}/500 characters`;
                if (count >= 500) {
                    charCounter.classList.add('text-danger');
                } else {
                    charCounter.classList.remove('text-danger');
                }
            });

            // Trigger once on load in case of form preservation
            const countOnLoad = description.value.length;
            charCounter.textContent = `${countOnLoad}/500 characters`;

            // 2. Track files in data transfer object to support dynamic removals
            let dt = new DataTransfer();

            imageUploads.addEventListener('change', (e) => {
                const files = e.target.files;
                
                // Enforce max 5 files constraint client-side
                if (dt.items.length + files.length > 5) {
                    alert("Maximum of 5 images are allowed.");
                    imageUploads.value = "";
                    return;
                }

                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    
                    // Validate file type
                    if (!file.type.startsWith('image/')) {
                        alert(`File "${file.name}" is not an image and will be skipped.`);
                        continue;
                    }

                    // Validate file size (5MB limit)
                    if (file.size > 5 * 1024 * 1024) {
                        alert(`File "${file.name}" exceeds the 5MB limit and will be skipped.`);
                        continue;
                    }

                    // Add to custom file transfer registry
                    dt.items.add(file);

                    // Render Thumbnail preview via FileReader API
                    const reader = new FileReader();
                    reader.onload = (event) => {
                        const container = document.createElement('div');
                        container.className = 'thumbnail-container';
                        
                        const img = document.createElement('img');
                        img.src = event.target.result;
                        img.className = 'thumbnail-img';
                        img.alt = file.name;

                        const removeBtn = document.createElement('button');
                        removeBtn.className = 'remove-btn';
                        removeBtn.innerHTML = '&times;';
                        
                        // Handler to remove a specific file item dynamically
                        removeBtn.addEventListener('click', (e) => {
                            e.preventDefault();
                            container.remove();
                            
                            // Rebuild DataTransfer object minus deleted file
                            const newDt = new DataTransfer();
                            for (let j = 0; j < dt.files.length; j++) {
                                if (dt.files[j] !== file) {
                                    newDt.items.add(dt.files[j]);
                                }
                            }
                            dt = newDt;
                            imageUploads.files = dt.files;
                            imageCountInput.value = dt.files.length;
                        });

                        container.appendChild(img);
                        container.appendChild(removeBtn);
                        previewGrid.appendChild(container);
                    };
                    reader.readAsDataURL(file);
                }

                // Sync file input files
                imageUploads.files = dt.files;
                imageCountInput.value = dt.files.length;
            });

            // 3. Form Submission Handling with Double-Submit Prevention
            form.addEventListener('submit', (event) => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                } else {
                    btnSpinner.style.display = 'inline-block';
                    btnText.textContent = 'Submitting Complaint...';
                    submitBtn.disabled = true;
                }
                form.classList.add('was-validated');
            }, false);
        })();
    </script>
</body>
</html>
