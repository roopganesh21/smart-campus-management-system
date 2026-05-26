package com.smartcampus.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * LogoutServlet handles session termination and logout procedures.
 * Maps to "/logout" and supports both HTTP GET and POST requests.
 * Invalidate sessions and sets strict cache-control headers to prevent
 * unauthorized back-button browser access to previously cached protected pages.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    /**
     * Common method to process both GET and POST logout requests.
     * Invalidates active user session, clears browser caches, and redirects.
     */
    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            String userName = (String) session.getAttribute("userName");
            LOGGER.info("Logging out active session for user: " + userName);
            // Completely destroy the session
            session.invalidate();
        }

        // Set cache-control headers to prevent browser caching of protected views
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // Redirect back to login page with logout query parameter
        response.sendRedirect(request.getContextPath() + "/login.jsp?logout=true");
    }
}
