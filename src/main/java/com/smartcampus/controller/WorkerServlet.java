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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Retrieve and display assigned tasks for the logged-in worker
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle worker task status updates and remarks
    }
}
