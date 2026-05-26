package com.smartcampus.controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.IOException;

/**
 * WorkerServlet handles operations performed by workers/maintenance staff.
 * This includes viewing assigned tasks, updating task completion status, and uploading proof of work.
 */
public class WorkerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(WorkerServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        LOGGER.info("WorkerServlet received GET request. URI: " + requestURI + 
                    ", ServletPath: " + servletPath + ", PathInfo: " + pathInfo);
        
        if (pathInfo == null || "/".equals(pathInfo) || "/dashboard".equals(pathInfo)) {
            LOGGER.info("Forwarding to /WEB-INF/worker/dashboard.jsp");
            request.getRequestDispatcher("/WEB-INF/worker/dashboard.jsp").forward(request, response);
            return;
        } else {
            LOGGER.warning("PathInfo '" + pathInfo + "' did not match expected dashboard paths!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle worker task status updates
    }
}
