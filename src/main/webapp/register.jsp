<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inline Custom Styles for WOW Aesthetics -->
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .register-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            max-width: 500px;
            width: 100%;
            padding: 2.5rem;
            transition: transform 0.3s ease;
        }
        .register-card:hover {
            transform: translateY(-5px);
        }
        .brand-logo {
            width: 70px;
            height: 70px;
            object-fit: contain;
            border-radius: 50%;
            background-color: #f1f5f9;
            padding: 8px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .form-control, .form-select {
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.6rem 0.8rem;
            transition: all 0.2s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }
        .btn-primary {
            background-color: #4f46e5;
            border: none;
            border-radius: 10px;
            padding: 0.75rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #4338ca;
            transform: translateY(-1px);
        }
        .btn-primary:active {
            transform: translateY(1px);
        }
    </style>
</head>
<body>

    <div class="register-card">
        <!-- Logo Placeholders & Title Header -->
        <div class="text-center mb-4">
            <img src="images/logo.png" alt="Smart Campus" class="brand-logo mb-2" onerror="this.style.display='none'; document.getElementById('logo-fallback').style.display='block';">
            <div id="logo-fallback" style="display:none;" class="fs-3 fw-bold text-primary mb-2">Smart Campus</div>
            <h3 class="fw-bold text-dark mb-1">Student Registration</h3>
            <p class="text-muted small">Create your account to start managing campus issues and resources</p>
        </div>

        <!-- Bootstrap Validation Feedback Alerts -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                <div>
                    <svg class="bi flex-shrink-0 me-2" width="20" height="20" role="img" aria-label="Danger:" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                    </svg>
                    <c:out value="${errorMessage}" />
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success d-flex align-items-center mb-3" role="alert">
                <div>
                    <svg class="bi flex-shrink-0 me-2" width="20" height="20" role="img" aria-label="Success:" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                    </svg>
                    <c:out value="${successMessage}" />
                </div>
            </div>
        </c:if>

        <!-- Registration Form -->
        <form action="${pageContext.request.contextPath}/register" method="POST" class="needs-validation" novalidate id="registerForm">
            
            <!-- Full Name -->
            <div class="mb-3">
                <label for="name" class="form-label small fw-semibold text-dark">Full Name</label>
                <input type="text" class="form-control" id="name" name="name" 
                       value="<c:out value='${name}'/>" required minlength="3" placeholder="Enter full name">
                <div class="invalid-feedback">Name is required (at least 3 characters).</div>
            </div>

            <!-- Email Address -->
            <div class="mb-3">
                <label for="email" class="form-label small fw-semibold text-dark">Email Address</label>
                <input type="email" class="form-control" id="email" name="email" 
                       value="<c:out value='${email}'/>" required placeholder="name@student.edu">
                <div class="invalid-feedback">A valid email address is required.</div>
            </div>

            <!-- Department Selector -->
            <div class="mb-3">
                <label for="department" class="form-label small fw-semibold text-dark">Department</label>
                <select class="form-select" id="department" name="department" required>
                    <option value="" disabled ${empty department ? 'selected' : ''}>Select your department</option>
                    <option value="Computer Science" ${department == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Electronics" ${department == 'Electronics' ? 'selected' : ''}>Electronics</option>
                    <option value="Mechanical" ${department == 'Mechanical' ? 'selected' : ''}>Mechanical</option>
                    <option value="Civil" ${department == 'Civil' ? 'selected' : ''}>Civil</option>
                    <option value="Chemical" ${department == 'Chemical' ? 'selected' : ''}>Chemical</option>
                    <option value="Other" ${department == 'Other' ? 'selected' : ''}>Other</option>
                </select>
                <div class="invalid-feedback">Please select your department.</div>
            </div>

            <!-- Phone Number -->
            <div class="mb-3">
                <label for="phone" class="form-label small fw-semibold text-dark">Phone Number</label>
                <input type="tel" class="form-control" id="phone" name="phone" 
                       value="<c:out value='${phone}'/>" required pattern="^[6-9]\d{9}$" placeholder="10-digit Indian number">
                <div class="invalid-feedback">Please enter a valid 10-digit Indian mobile number (starts with 6-9).</div>
            </div>

            <!-- Password -->
            <div class="mb-3">
                <label for="password" class="form-label small fw-semibold text-dark">Password</label>
                <input type="password" class="form-control" id="password" name="password" required minlength="8" placeholder="At least 8 characters">
                <div class="invalid-feedback" id="passFeedback">Password must be at least 8 characters long.</div>
                <div id="passRequirements" class="form-text text-muted small mt-1">Must contain at least 1 uppercase letter and 1 number.</div>
            </div>

            <!-- Confirm Password -->
            <div class="mb-3">
                <label for="confirmPass" class="form-label small fw-semibold text-dark">Confirm Password</label>
                <input type="password" class="form-control" id="confirmPass" name="confirmPassword" required placeholder="Verify password">
                <div class="invalid-feedback" id="confirmFeedback">Please confirm your password.</div>
            </div>

            <!-- Submit Button with loading spinner -->
            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary btn-block" id="submitBtn">
                    <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true" style="display:none;" id="btnSpinner"></span>
                    <span id="btnText">Register</span>
                </button>
            </div>

            <!-- Back to Login link -->
            <div class="text-center mt-3">
                <span class="small text-muted">Already registered? </span>
                <a href="${pageContext.request.contextPath}/login.jsp" class="small text-primary fw-semibold text-decoration-none">Log In here</a>
            </div>

        </form>
    </div>

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-side Javascript validation logic -->
    <script>
        (() => {
            'use strict';

            const form = document.getElementById('registerForm');
            const password = document.getElementById('password');
            const confirmPass = document.getElementById('confirmPass');
            const phone = document.getElementById('phone');
            const passFeedback = document.getElementById('passFeedback');
            const confirmFeedback = document.getElementById('confirmFeedback');
            const submitBtn = document.getElementById('submitBtn');
            const btnSpinner = document.getElementById('btnSpinner');
            const btnText = document.getElementById('btnText');

            form.addEventListener('submit', event => {
                let isValid = true;

                // Reset field custom validity statuses
                password.setCustomValidity('');
                confirmPass.setCustomValidity('');
                phone.setCustomValidity('');

                // 1. Password checks (at least 1 uppercase and 1 number, minlength=8)
                const pwdVal = password.value;
                const hasUppercase = /[A-Z]/.test(pwdVal);
                const hasNumber = /[0-9]/.test(pwdVal);

                if (pwdVal.length < 8) {
                    password.setCustomValidity('Password must be at least 8 characters.');
                    passFeedback.textContent = 'Password must be at least 8 characters long.';
                    isValid = false;
                } else if (!hasUppercase || !hasNumber) {
                    password.setCustomValidity('Password missing uppercase or number.');
                    passFeedback.textContent = 'Password must contain at least one uppercase letter and one number.';
                    isValid = false;
                }

                // 2. Password Match Check
                if (pwdVal !== confirmPass.value) {
                    confirmPass.setCustomValidity('Passwords do not match.');
                    confirmFeedback.textContent = 'Passwords do not match. Please verify.';
                    confirmFeedback.style.color = '#ef4444'; // Visual red text cue
                    isValid = false;
                }

                // 3. Indian Phone Format Check (exactly 10 digits starting with 6-9)
                const phonePattern = /^[6-9]\d{9}$/;
                if (!phonePattern.test(phone.value)) {
                    phone.setCustomValidity('Invalid phone.');
                    isValid = false;
                }

                // 4. Form Execution
                if (!form.checkValidity() || !isValid) {
                    event.preventDefault();
                    event.stopPropagation();
                } else {
                    // Success path: prevent double submits by showing loader spinner
                    btnSpinner.style.display = 'inline-block';
                    btnText.textContent = 'Registering...';
                    submitBtn.disabled = true;
                }

                form.classList.add('was-validated');
            }, false);
        })();
    </script>
</body>
</html>
