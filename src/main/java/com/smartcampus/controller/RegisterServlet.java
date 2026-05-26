package com.smartcampus.controller;

import com.smartcampus.dao.UserDAO;
import com.smartcampus.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * RegisterServlet handles student registration.
 * It maps to URL pattern "/register" and supports multipart configurations.
 * Coordinates user parameter extraction, comprehensive server-side validations, 
 * secure password hashing (BCrypt), and calls UserDAO to register the profile.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
@MultipartConfig
public class RegisterServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    /**
     * Forwards HTTP GET requests directly to the registration JSP interface.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    /**
     * Processes student registration HTTP POST requests.
     * Extracts parameters, runs strict server-side validation checks, prevents duplicate email logins,
     * hashes password credentials, and registers new accounts in the database.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Extract and clean user parameter values
        String name = trimParameter(request.getParameter("name"));
        String email = trimParameter(request.getParameter("email"));
        String department = trimParameter(request.getParameter("department"));
        String phone = trimParameter(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2. Comprehensive server-side validations
        String validationError = validateInputs(name, email, department, phone, password, confirmPassword);
        
        if (validationError != null) {
            LOGGER.log(Level.WARNING, "Registration failed validation: " + validationError);
            forwardWithError(request, response, validationError, name, email, department, phone);
            return;
        }

        try {
            // 3. Prevent duplicate account registrations for identical emails
            Optional<User> existingUser = userDAO.getUserByEmail(email);
            if (existingUser.isPresent()) {
                LOGGER.log(Level.WARNING, "Registration failed: Email already taken: " + email);
                forwardWithError(request, response, "This email is already registered", name, email, department, phone);
                return;
            }

            // 4. Secure hashing using blowfish-bcrypt (rounds: 12)
            String salt = BCrypt.gensalt(12);
            String passwordHash = BCrypt.hashpw(password, salt);

            // 5. Instantiating student model
            User newUser = new User();
            newUser.setName(name);
            newUser.setEmail(email);
            newUser.setPasswordHash(passwordHash);
            newUser.setRole("student"); // Forces student privilege constraints for safety
            newUser.setDepartment(department);
            newUser.setPhone(phone);
            newUser.setProfileImage("default.png");
            newUser.setActive(true);

            // 6. DB Insertion
            boolean success = userDAO.registerUser(newUser);

            if (success) {
                LOGGER.info("Registration successful for student: " + email);
                // Redirect back to login page with registered query parameter
                response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
            } else {
                LOGGER.severe("Registration failed in DB insert statement execution.");
                forwardWithError(request, response, "Registration failed due to a database error. Please try again.", name, email, department, phone);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected exception during student registration.", e);
            forwardWithError(request, response, "An unexpected system error occurred. Please contact admin.", name, email, department, phone);
        }
    }

    /**
     * Helper checks evaluating parameter validations.
     * Returns descriptive error string on mismatch, or null if all pass successfully.
     */
    private String validateInputs(String name, String email, String department, String phone, 
                                  String password, String confirmPassword) {
        
        // 1. Mandatory Null/Empty Evaluation
        if (isEmpty(name) || isEmpty(email) || isEmpty(department) || isEmpty(phone) || 
            isEmpty(password) || isEmpty(confirmPassword)) {
            return "All fields are required.";
        }

        // 2. Name Length Check
        if (name.length() < 3) {
            return "Name must be at least 3 characters long.";
        }

        // 3. Email Format Regex Check
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        if (!email.matches(emailRegex)) {
            return "Please enter a valid email address.";
        }

        // 4. Password Security Policy Check (minlength=8, at least 1 uppercase and 1 number)
        if (password.length() < 8) {
            return "Password must be at least 8 characters long.";
        }
        if (!password.matches(".*[A-Z].*")) {
            return "Password must contain at least one uppercase letter.";
        }
        if (!password.matches(".*[0-9].*")) {
            return "Password must contain at least one number.";
        }

        // 5. Password Match Check
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }

        // 6. Indian Phone Format Regex Check (exactly 10 digits starting with 6-9)
        if (!phone.matches("^[6-9]\\d{9}$")) {
            return "Please enter a valid 10-digit Indian phone number.";
        }

        return null; // Passes all validation criteria
    }

    /**
     * Preserves form values, binds error variables, and forwards control back to JSP view.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error,
                                  String name, String email, String department, String phone) 
            throws ServletException, IOException {
        
        request.setAttribute("errorMessage", error);
        
        // Pre-fill preservation attributes
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("department", department);
        request.setAttribute("phone", phone);

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private boolean isEmpty(String str) {
        return str == null || str.isEmpty();
    }

    private String trimParameter(String param) {
        return param == null ? "" : param.trim();
    }
}
