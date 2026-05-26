package com.smartcampus.controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * AuthFilter intercepts and secures resource requests mapped under "/admin/*", "/student/*", and "/worker/*".
 * It guarantees that users have active sessions and prevents cross-role authorization bypasses.
 * 
 * WHY: Servlet security filters act as a centralized firewall, preventing unauthenticated
 * users from accessing backend dashboards by typing exact URLs directly, and stopping authenticated 
 * students from accessing administrative URLs.
 */
@WebFilter(urlPatterns = {"/admin/*", "/student/*", "/worker/*"})
public class AuthFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(AuthFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Required method by servlet filter specifications
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 1. Get active session without creating one
        HttpSession session = httpRequest.getSession(false);
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        LOGGER.info("AuthFilter intercepted URI: " + requestURI + 
                    ". Session exists: " + (session != null));
        if (session != null) {
            LOGGER.info("Session ID: " + session.getId() + 
                        ", userId: " + session.getAttribute("userId") + 
                        ", userRole: " + session.getAttribute("userRole"));
        }
        
        // 2. Validate session existence and authentication attributes
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("Unauthorized access blocked for URI: " + requestURI + 
                           ". Redirecting to login. Reason: " + 
                           (session == null ? "session is null" : "userId attribute is null"));
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // 3. Cross-role authorization check
        String userRole = (String) session.getAttribute("userRole");
        boolean isAuthorized = true;

        if (requestURI.startsWith(contextPath + "/admin/") && !"admin".equalsIgnoreCase(userRole)) {
            isAuthorized = false;
        } else if (requestURI.startsWith(contextPath + "/worker/") && !"worker".equalsIgnoreCase(userRole)) {
            isAuthorized = false;
        } else if (requestURI.startsWith(contextPath + "/student/") && !"student".equalsIgnoreCase(userRole)) {
            isAuthorized = false;
        }

        if (!isAuthorized) {
            LOGGER.severe("Access Denied: Cross-role violation by user with role [" + userRole + "] attempting to access: " + requestURI);
            // Invalidate session on privilege escalation attempts and force a re-login
            session.invalidate();
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // 4. Pass request down the chain
        chain.doFilter(request, response);

        // 5. Post-chain: Set cache-control headers on response to prevent back-button access
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        httpResponse.setHeader("Pragma", "no-cache"); // HTTP 1.0
        httpResponse.setDateHeader("Expires", 0); // Proxies
    }

    @Override
    public void destroy() {
        // Required method by servlet filter specifications
    }
}
