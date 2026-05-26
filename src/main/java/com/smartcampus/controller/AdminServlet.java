package com.smartcampus.controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.IOException;

/**
 * AdminServlet manages administrative tasks such as user moderation, resource allocation, 
 * assigning complaints to workers, and accessing system-wide metrics.
 */
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(AdminServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        LOGGER.info("AdminServlet received GET request. URI: " + requestURI + 
                    ", ServletPath: " + servletPath + ", PathInfo: " + pathInfo);
        
        if (pathInfo == null || "/".equals(pathInfo) || "/dashboard".equals(pathInfo)) {
            LOGGER.info("Forwarding to /WEB-INF/admin/dashboard.jsp");
            request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
            return;
        } else {
            LOGGER.warning("PathInfo '" + pathInfo + "' did not match expected dashboard paths!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Perform administrative actions
    }
}
