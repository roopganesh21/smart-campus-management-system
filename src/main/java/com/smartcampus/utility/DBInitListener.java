package com.smartcampus.utility;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * DBInitListener is a ServletContextListener annotated with @WebListener.
 * It manages the lifecycle of the Apache DBCP2 database connection pool in sync with the
 * web application container.
 * 
 * WHY: Initializing database connections eagerly during web application startup ensures
 * that any configuration issues (such as wrong passwords or offline database servers) are
 * caught immediately at deploy time rather than failing on user requests. Likewise, shutting down
 * the pool on container destroy prevents socket and thread leakage on redeployments.
 */
@WebListener
public class DBInitListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(DBInitListener.class.getName());

    /**
     * Triggered by the container when the web application is starting up.
     * Initiates singleton setup and performs a diagnostic SQL query.
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Web Application starting up. Initializing eager configurations...");

        // Initialize SMTP email utility
        EmailUtil.initialize(sce.getServletContext());

        // Eagerly retrieve the singleton instance. This triggers the constructor, loads
        // properties, and warms up the Apache DBCP2 connection pool.
        DBConnection dbConnection = DBConnection.getInstance(sce.getServletContext());

        // Perform a diagnostic query ("SELECT 1") immediately to verify connection integrity
        boolean checkDb = DBConnection.testConnection();
        if (checkDb) {
            LOGGER.info("Eager Database Initialization Succeeded: Smart Campus is connected to MySQL.");
        } else {
            // Severe level guarantees visibility in standard application server logs (Tomcat console)
            LOGGER.severe("Eager Database Initialization Failed: Connection check returned negative status.");
        }
    }

    /**
     * Triggered by the container when the web application is shutting down.
     * Releases active connection pool sockets cleanly.
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Web Application shutting down. Triggering connection pool closure...");

        // Access the singleton instance. We pass null because it was already initialized;
        // it simply returns the volatile pointer instance
        DBConnection dbConnection = DBConnection.getInstance();
        if (dbConnection != null) {
            // Safely close the BasicDataSource instance to shut down physical socket pools
            dbConnection.shutdown();
        } else {
            LOGGER.warning("Context teardown reached, but DBConnection instance was never initialized.");
        }
    }
}
