package com.smartcampus.utility;

import org.apache.commons.dbcp2.BasicDataSource;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBConnection is a thread-safe singleton class responsible for managing database
 * connections via the Apache DBCP2 connection pooling library.
 * It uses double-checked locking to ensure only a single instance of the connection pool is created.
 */
public class DBConnection {

    // Retrieve logger specific to DBConnection for descriptive log filtering
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    // Volatile keyword ensures changes made by one thread are immediately visible to others, preventing memory caching issues
    private static volatile DBConnection instance;

    // Apache DBCP2 DataSource which handles SQL connection pooling automatically
    private BasicDataSource dataSource;

    /**
     * Private constructor to prevent direct instantiation (Singleton pattern).
     * Automatically attempts to resolve and load db.properties before spinning up the DBCP2 datasource pool.
     */
    private DBConnection(ServletContext context) {
        Properties properties = loadProperties(context);
        initializePool(properties);
    }

    /**
     * Retrieves the thread-safe singleton instance of DBConnection, initializing it if necessary.
     * Uses double-checked locking to optimize performance while maintaining safety in high-concurrency environments.
     * 
     * @param context ServletContext used to locate db.properties via application resource paths
     * @return DBConnection instance
     */
    public static DBConnection getInstance(ServletContext context) {
        if (instance == null) {
            // Synchronize class block to block concurrent thread instantiation races
            synchronized (DBConnection.class) {
                // Secondary check inside synchronization locks ensures thread safety
                if (instance == null) {
                    instance = new DBConnection(context);
                }
            }
        }
        return instance;
    }

    /**
     * Fallback getInstance overload that does not require a ServletContext,
     * relying purely on the ClassLoader to load configuration. Useful for standalone execution or tests.
     * 
     * @return DBConnection instance
     */
    public static DBConnection getInstance() {
        if (instance == null) {
            synchronized (DBConnection.class) {
                if (instance == null) {
                    LOGGER.info("Initializing DBConnection without ServletContext; falling back to ClassLoader resources.");
                    instance = new DBConnection(null);
                }
            }
        }
        return instance;
    }

    /**
     * Returns an active database Connection from the pooled datasource.
     * Throws descriptive RuntimeExceptions if connection pooling is not yet initialized.
     * 
     * @return java.sql.Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        if (instance == null || instance.dataSource == null) {
            LOGGER.severe("Connection request failed: Connection pool has not been initialized yet.");
            throw new RuntimeException("Database connection pool is not initialized. Please call DBConnection.getInstance(...) first.");
        }
        return instance.dataSource.getConnection();
    }

    /**
     * Helper method to load configuration keys from db.properties file.
     * It uses a robust layered strategy (ServletContext -> ClassLoader -> Direct File Access)
     * to guarantee configuration availability under various environments.
     */
    private Properties loadProperties(ServletContext context) {
        Properties props = new Properties();
        InputStream is = null;

        // Method 1: Load via ServletContext (standard way for deployed servlets)
        if (context != null) {
            try {
                is = context.getResourceAsStream("/WEB-INF/db.properties");
                if (is != null) {
                    props.load(is);
                    LOGGER.info("db.properties successfully loaded using ServletContext.");
                    return props;
                }
            } catch (IOException e) {
                LOGGER.log(Level.WARNING, "Failed to read db.properties via ServletContext, trying fallback.", e);
            } finally {
                closeStream(is);
            }
        }

        // Method 2: Load via ClassLoader (standard fallback for unit tests and local runs)
        try {
            is = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
            if (is == null) {
                is = DBConnection.class.getResourceAsStream("/db.properties");
            }
            if (is == null) {
                is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            }
            if (is != null) {
                props.load(is);
                LOGGER.info("db.properties successfully loaded using ClassLoader resource stream.");
                return props;
            }
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Failed to read db.properties via ClassLoader, trying fallback.", e);
        } finally {
            closeStream(is);
        }

        // Method 3: Load via direct absolute/relative filesystem path (final IDE development environment fallback)
        try {
            java.io.File directFile = new java.io.File("src/main/webapp/WEB-INF/db.properties");
            if (directFile.exists()) {
                is = new java.io.FileInputStream(directFile);
                props.load(is);
                LOGGER.info("db.properties successfully loaded using Direct File IO Stream.");
                return props;
            }
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Failed to read db.properties via Direct File Stream.", e);
        } finally {
            closeStream(is);
        }

        LOGGER.severe("All resource loading strategies failed. db.properties is missing from deployment folders.");
        throw new RuntimeException("Critical Error: Database configuration file 'db.properties' could not be resolved.");
    }

    /**
     * Configures the DBCP2 connection pool with properties loaded from the configuration file.
     */
    private void initializePool(Properties props) {
        try {
            dataSource = new BasicDataSource();
            
            // Database Driver & URL Credentials
            dataSource.setDriverClassName(props.getProperty("db.driver"));
            dataSource.setUrl(props.getProperty("db.url"));
            dataSource.setUsername(props.getProperty("db.username"));
            dataSource.setPassword(props.getProperty("db.password"));

            // Connection Pool Sizing Parameters
            dataSource.setInitialSize(Integer.parseInt(props.getProperty("db.pool.initialSize", "5")));
            dataSource.setMaxTotal(Integer.parseInt(props.getProperty("db.pool.maxTotal", "20")));
            dataSource.setMaxIdle(Integer.parseInt(props.getProperty("db.pool.maxIdle", "10")));
            dataSource.setMinIdle(Integer.parseInt(props.getProperty("db.pool.minIdle", "2")));
            dataSource.setMaxWaitMillis(Long.parseLong(props.getProperty("db.pool.maxWaitMillis", "10000")));

            LOGGER.info("Apache DBCP2 connection pooling initialized with " + dataSource.getInitialSize() + " warm connections.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to configure Apache DBCP2 BasicDataSource.", e);
            throw new RuntimeException("Error initializing database connection pool", e);
        }
    }

    /**
     * Null-safe, isolated closing function for SQL operation components.
     * Prevents resource leaks in persistent server runtimes by explicitly releasing connections.
     * Catches and logs exceptions individually so one failure does not halt other closers.
     * 
     * @param conn database connection to return to pool
     * @param stmt SQL executing statement to release
     * @param rs result cursor to close
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing SQL ResultSet instance.", e);
            }
        }
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing SQL Statement/PreparedStatement instance.", e);
            }
        }
        if (conn != null) {
            try {
                conn.close(); // Returns connection back to DBCP2 pool instead of terminating physical socket
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error returning Connection to pool.", e);
            }
        }
    }

    /**
     * Executes a fast verification statement ("SELECT 1") to test database availability.
     * Logs exact results or failure exceptions using Java util logging systems.
     * 
     * @return true if database is online and reachable, false otherwise.
     */
    public static boolean testConnection() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT 1");
            if (rs.next()) {
                int testValue = rs.getInt(1);
                if (testValue == 1) {
                    LOGGER.info("Database ping test ('SELECT 1') completed successfully.");
                    return true;
                }
            }
            LOGGER.warning("Database ping test returned abnormal results.");
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database ping test failed: Connection could not be established.", e);
            return false;
        } finally {
            close(conn, stmt, rs);
        }
    }

    /**
     * Safely closes the basic datasource connection pool, terminating all active and idle sockets.
     * To be called during application container teardown.
     */
    public void shutdown() {
        if (dataSource != null) {
            try {
                dataSource.close();
                LOGGER.info("DBCP2 Connection pool closed cleanly; all database sockets released.");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error while performing final connection pool shutdown.", e);
            }
        }
    }

    /**
     * Helper to close InputStreams without cluttering core configurations.
     */
    private void closeStream(InputStream is) {
        if (is != null) {
            try {
                is.close();
            } catch (IOException e) {
                LOGGER.log(Level.FINEST, "Failed to close input stream.", e);
            }
        }
    }
}
