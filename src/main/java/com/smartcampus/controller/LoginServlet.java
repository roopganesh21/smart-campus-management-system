package com.smartcampus.controller;

import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * LoginServlet handles student, admin, and worker authentication.
 * Maps to the URL pattern "/login" and manages active HTTP user sessions.
 * On success, binds user attributes to the session and executes role-based redirects.
 */
@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    /**
     * Handles HTTP GET requests.
     * Prevents logged-in users from seeing the login screen by automatically redirecting
     * active sessions directly to their respective dashboards.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("userRole");
            LOGGER.info("Active session detected. Auto-redirecting role: " + role);
            redirectDashboard(request, response, role);
            return;
        }

        // If not logged in, forward to the login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * Handles HTTP POST requests for user authentication.
     * Extracts credentials, verifies BCrypt hashes, validates account state,
     * binds session attributes, and redirects to dashboards.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = trimParameter(request.getParameter("email"));
        String password = request.getParameter("password");

        // 1. Basic empty parameters validation
        if (isEmpty(email) || isEmpty(password)) {
            forwardWithError(request, response, "Email and password are required.");
            return;
        }

        try {
            // 2. Fetch User by Email
            Optional<User> userOpt = userDAO.getUserByEmail(email);
            if (userOpt.isEmpty()) {
                LOGGER.log(Level.WARNING, "Login attempt failed: Email not found: " + email);
                forwardWithError(request, response, "Invalid email or password.");
                return;
            }

            User user = userOpt.get();

            // 3. Verify BCrypt password hash
            boolean matches = BCrypt.checkpw(password, user.getPasswordHash());
            if (!matches) {
                LOGGER.log(Level.WARNING, "Login attempt failed: Password mismatch for email: " + email);
                forwardWithError(request, response, "Invalid email or password.");
                return;
            }

            // 4. Verify account status state (Soft suspension lockout)
            if (!user.isActive()) {
                LOGGER.log(Level.WARNING, "Login attempt blocked: Deactivated account: " + email);
                forwardWithError(request, response, "Your account has been deactivated.");
                return;
            }

            // 5. Success Path: Establish new, secure HttpSession
            // Invalidate any pre-existing session to prevent session fixation attacks
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userEmail", user.getEmail());
            
            // Set maximum inactive interval session lifetime: 30 minutes (1800 seconds)
            session.setMaxInactiveInterval(30 * 60);

            LOGGER.info("Authentication successful for: " + email + " [Role: " + user.getRole() + "]");

            // 6. Role-Based Dashboard Redirection
            redirectDashboard(request, response, user.getRole());

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error executing user login.", e);
            forwardWithError(request, response, "An internal system error occurred. Please try again.");
        }
    }

    /**
     * Executes context-safe role-based dashboard redirects.
     */
    private void redirectDashboard(HttpServletRequest request, HttpServletResponse response, String role) 
            throws IOException {
        String contextPath = request.getContextPath();
        if ("admin".equalsIgnoreCase(role)) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if ("worker".equalsIgnoreCase(role)) {
            response.sendRedirect(contextPath + "/worker/dashboard");
        } else {
            response.sendRedirect(contextPath + "/student/dashboard");
        }
    }

    /**
     * Binds error message and forwards execution to the login view.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error) 
            throws ServletException, IOException {
        request.setAttribute("errorMessage", error);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    private boolean isEmpty(String str) {
        return str == null || str.isEmpty();
    }

    private String trimParameter(String param) {
        return param == null ? "" : param.trim();
    }
}
