<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.servlet.jsp.jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS for Premium Design -->
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f0f4f8;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .login-card {
            background-color: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            max-width: 450px;
            width: 100%;
            padding: 2.5rem;
            border: none;
            transition: transform 0.3s ease;
        }
        .login-card:hover {
            transform: translateY(-3px);
        }
        .brand-logo {
            width: 70px;
            height: 70px;
            object-fit: contain;
            border-radius: 50%;
            background-color: #f8fafc;
            padding: 8px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .form-control {
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.6rem 0.8rem;
            transition: all 0.2s ease;
        }
        .form-control:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }
        .input-group-text {
            border: 1.5px solid #e2e8f0;
            border-left: none;
            background-color: #ffffff;
            border-radius: 0 10px 10px 0;
            cursor: pointer;
        }
        .form-control.password-field {
            border-right: none;
            border-radius: 10px 0 0 10px;
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
        .form-check-input:checked {
            background-color: #4f46e5;
            border-color: #4f46e5;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <!-- Logo Placeholders & Title Header -->
        <div class="text-center mb-4">
            <img src="images/logo.png" alt="Smart Campus" class="brand-logo mb-2" onerror="this.style.display='none'; document.getElementById('logo-fallback').style.display='block';">
            <div id="logo-fallback" style="display:none;" class="fs-3 fw-bold text-primary mb-2">Smart Campus</div>
            <h3 class="fw-bold text-dark mb-1">Welcome Back</h3>
            <p class="text-muted small">Log in to manage complaints and bookings</p>
        </div>

        <!-- JSTL Conditional Display Alerts -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                <svg class="bi flex-shrink-0 me-2" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                </svg>
                <div>
                    <c:out value="${errorMessage}" />
                </div>
            </div>
        </c:if>

        <c:if test="${param.registered == 'true'}">
            <div class="alert alert-success d-flex align-items-center mb-3" role="alert">
                <svg class="bi flex-shrink-0 me-2" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                </svg>
                <div>Registration successful! Please log in.</div>
            </div>
        </c:if>

        <c:if test="${param.logout == 'true'}">
            <div class="alert alert-info d-flex align-items-center mb-3" role="alert">
                <svg class="bi flex-shrink-0 me-2" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/>
                </svg>
                <div>You have been successfully logged out.</div>
            </div>
        </c:if>

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/login" method="POST" novalidate class="needs-validation" id="loginForm">
            
            <!-- Email Field -->
            <div class="mb-3">
                <label for="email" class="form-label small fw-semibold text-dark">Email Address</label>
                <input type="email" class="form-control" id="email" name="email" required placeholder="name@smartcampus.edu">
                <div class="invalid-feedback">Please enter a valid email address.</div>
            </div>

            <!-- Password Field with eye toggle -->
            <div class="mb-3">
                <label for="password" class="form-label small fw-semibold text-dark">Password</label>
                <div class="input-group">
                    <input type="password" class="form-control password-field" id="password" name="password" required placeholder="Enter password">
                    <span class="input-group-text" id="togglePassword">
                        <!-- Eye Icon SVG (Pure CSS/JS Toggle) -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="#475569" class="bi bi-eye" viewBox="0 0 16 16" id="eyeIcon">
                            <path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 4 8 4s3.879.668 5.168 1.957A13 13 0 0 1 14.828 8a13 13 0 0 1-1.66 2.043C11.879 11.332 10.119 12 8 12s-3.879-.668-5.168-1.957A13 13 0 0 1 1.173 8"/>
                            <path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/>
                        </svg>
                    </span>
                    <div class="invalid-feedback">Please enter your password.</div>
                </div>
            </div>

            <!-- Remember Me & Reset Password Links -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="rememberMe">
                    <label class="form-check-label small text-muted" for="rememberMe">Remember me</label>
                </div>
            </div>

            <!-- Submit Button with loading spinner -->
            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true" style="display:none;" id="btnSpinner"></span>
                    <span id="btnText">Log In</span>
                </button>
            </div>

            <!-- Back to Register link -->
            <div class="text-center mt-3">
                <span class="small text-muted">New student? </span>
                <a href="${pageContext.request.contextPath}/register" class="small text-primary fw-semibold text-decoration-none">Create an Account</a>
            </div>

        </form>
    </div>

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        (() => {
            'use strict';

            const form = document.getElementById('loginForm');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const togglePassword = document.getElementById('togglePassword');
            const eyeIcon = document.getElementById('eyeIcon');
            const rememberMe = document.getElementById('rememberMe');
            const submitBtn = document.getElementById('submitBtn');
            const btnSpinner = document.getElementById('btnSpinner');
            const btnText = document.getElementById('btnText');

            // 1. Remember Me LocalStorage Logic
            document.addEventListener("DOMContentLoaded", () => {
                const storedEmail = localStorage.getItem("rememberedEmail");
                if (storedEmail) {
                    emailInput.value = storedEmail;
                    rememberMe.checked = true;
                }
            });

            // 2. Password Toggle eye icon logic (Pure CSS/JS)
            togglePassword.addEventListener('click', () => {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                
                if (type === 'password') {
                    // Standard Eye SVG
                    eyeIcon.innerHTML = `
                        <path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 4 8 4s3.879.668 5.168 1.957A13 13 0 0 1 14.828 8a13 13 0 0 1-1.66 2.043C11.879 11.332 10.119 12 8 12s-3.879-.668-5.168-1.957A13 13 0 0 1 1.173 8"/>
                        <path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/>
                    `;
                } else {
                    // Slashed Eye SVG
                    eyeIcon.innerHTML = `
                        <path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a8.6 8.6 0 0 0-2.79.488l.77.77A7.7 7.7 0 0 1 8 3.5c4 0 7.1 3.5 8 4.5-.9 1-3.68 4.32-6.84 4.5l.65.65.65.65.65.65.65.65.65.65.65.65.65.65zM8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5"/>
                        <path d="M14.354 1.146a.5.5 0 0 0-.708 0L.146 13.646a.5.5 0 0 0 .708.708l14-14a.5.5 0 0 0 0-.708M8 12.5c-4 0-7.1-3.5-8-4.5.6-1.12 1.9-3.08 3.75-4.15L5 5.58l.65.65.65.65.65.65.65.65.65.65.65.65z"/>
                    `;
                }
            });

            // 3. Form submission handling and spinners
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                } else {
                    // If checked, persist the username, otherwise remove it
                    if (rememberMe.checked) {
                        localStorage.setItem("rememberedEmail", emailInput.value);
                    } else {
                        localStorage.removeItem("rememberedEmail");
                    }
                    
                    btnSpinner.style.display = 'inline-block';
                    btnText.textContent = 'Logging In...';
                    submitBtn.disabled = true;
                }
                form.classList.add('was-validated');
            }, false);
        })();
    </script>
</body>
</html>
