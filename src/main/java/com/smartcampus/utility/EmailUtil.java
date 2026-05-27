package com.smartcampus.utility;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmailUtil automates SMTP mailing alerts for system notifications using Jakarta Mail.
 * It builds beautifully formatted, responsive HTML emails with inline styles,
 * and sends them asynchronously to prevent blocking the main request thread.
 */
public class EmailUtil {
    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());
    private static final Properties properties = new Properties();
    private static boolean isInitialized = false;

    /**
     * Initializes the email configuration by reading parameters from mail.properties.
     * Uses ServletContext path mapping or falls back to standard ClassLoader resource loading.
     */
    public static synchronized void initialize(ServletContext context) {
        if (isInitialized) return;

        InputStream is = null;
        try {
            if (context != null) {
                is = context.getResourceAsStream("/WEB-INF/mail.properties");
                if (is != null) {
                    properties.load(is);
                    isInitialized = true;
                    LOGGER.info("mail.properties loaded successfully via ServletContext.");
                }
            }

            if (!isInitialized) {
                // ClassLoader fallback
                is = Thread.currentThread().getContextClassLoader().getResourceAsStream("mail.properties");
                if (is != null) {
                    properties.load(is);
                    isInitialized = true;
                    LOGGER.info("mail.properties loaded successfully via ClassLoader.");
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to load mail.properties configuration file.", e);
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException ignored) {}
            }
        }

        if (!isInitialized) {
            LOGGER.severe("EmailUtil failed to initialize: mail.properties was not found.");
        }
    }

    /**
     * Eager initialization block if not previously triggered by the servlet context listener.
     */
    private static void ensureInitialized() {
        if (!isInitialized) {
            initialize(null);
        }
    }

    /**
     * Synchronously sends a styled HTML email to a target recipient using SMTP credentials.
     *
     * @param toEmail   Recipient email address
     * @param subject   Email subject line
     * @param htmlBody  Pre-built responsive HTML email body string
     */
    public static void sendEmail(String toEmail, String subject, String htmlBody) {
        ensureInitialized();

        if (!isInitialized || properties.isEmpty()) {
            LOGGER.warning(String.format("[STUB EMAIL FALLBACK] Target: %s | Subject: %s\nUnable to send real SMTP mail because EmailUtil was not initialized.", toEmail, subject));
            return;
        }

        final String fromEmail = properties.getProperty("mail.from.address");
        final String fromName = properties.getProperty("mail.from.name", "Smart Campus Alerts");
        final String fromPassword = properties.getProperty("mail.from.password");

        if (fromEmail == null || fromPassword == null || fromPassword.contains("your_app_password_here")) {
            LOGGER.warning(String.format("[STUB EMAIL FALLBACK] Target: %s | Subject: %s\nProperties loaded but SMTP credentials are placeholder values.", toEmail, subject));
            return;
        }

        // Set up session
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, fromPassword);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, fromName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");
            
            // Set message body format to html
            message.setContent(htmlBody, "text/html; charset=utf-8");

            LOGGER.info("Attempting to dispatch SMTP email to: " + toEmail);
            Transport.send(message);
            LOGGER.info("Successfully sent SMTP email alert to: " + toEmail);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "SMTP failure occurred when sending alert email to " + toEmail, e);
        }
    }

    /**
     * Asynchronously dispatches an email alert inside a non-blocking thread
     * to prevent blocking server responses or database transactions.
     *
     * @param toEmail   Recipient email address
     * @param subject   Email subject line
     * @param htmlBody  Pre-built HTML email body string
     */
    public static void sendEmailAsync(final String toEmail, final String subject, final String htmlBody) {
        new Thread(() -> {
            try {
                sendEmail(toEmail, subject, htmlBody);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Asynchronous thread email alert dispatch failed.", e);
            }
        }).start();
    }

    /**
     * Pre-compiles a beautifully styled, premium, responsive HTML email alert for Complaint Status Updates.
     */
    public static String buildStatusUpdateEmail(String studentName, String complaintTitle, String status, String workerName, String remark) {
        String statusColor = "#64748b"; // Secondary grey
        String statusText = status.toUpperCase();

        if ("assigned".equalsIgnoreCase(status)) statusColor = "#4f46e5"; // Indigo Blue
        else if ("in_progress".equalsIgnoreCase(status)) {
            statusColor = "#f59e0b"; // Warning Orange
            statusText = "IN PROGRESS";
        }
        else if ("resolved".equalsIgnoreCase(status)) statusColor = "#10b981"; // Success Green

        return "<!DOCTYPE html>" +
               "<html>" +
               "<head>" +
               "  <meta charset='utf-8'>" +
               "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
               "  <title>Smart Campus Status Update</title>" +
               "  <style>" +
               "    body { font-family: 'Outfit', 'Inter', -apple-system, sans-serif; background-color: #f8fafc; color: #334155; margin: 0; padding: 0; -webkit-font-smoothing: antialiased; }" +
               "    .email-container { max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; }" +
               "    .email-header { background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%); padding: 32px 24px; text-align: center; color: #ffffff; }" +
               "    .email-header h2 { margin: 0; font-size: 24px; font-weight: 700; letter-spacing: -0.5px; }" +
               "    .email-body { padding: 32px 24px; }" +
               "    .greeting { font-size: 18px; font-weight: 600; color: #1e293b; margin-top: 0; margin-bottom: 8px; }" +
               "    .intro { font-size: 15px; line-height: 1.6; color: #64748b; margin-bottom: 24px; }" +
               "    .status-badge { display: inline-block; padding: 6px 14px; font-size: 13px; font-weight: 600; text-transform: uppercase; border-radius: 30px; color: #ffffff; background-color: " + statusColor + "; margin-bottom: 24px; }" +
               "    .detail-card { background-color: #f8fafc; border-radius: 12px; padding: 20px; border: 1px solid #f1f5f9; margin-bottom: 24px; }" +
               "    .detail-row { display: flex; justify-content: space-between; border-bottom: 1px solid #e2e8f0; padding: 8px 0; font-size: 14px; }" +
               "    .detail-row:last-child { border-bottom: none; }" +
               "    .detail-label { font-weight: 600; color: #475569; width: 140px; flex-shrink: 0; }" +
               "    .detail-val { color: #1e293b; text-align: right; flex-grow: 1; }" +
               "    .remark-box { background-color: #ffffff; border-left: 4px solid " + statusColor + "; padding: 12px 16px; border-radius: 4px; font-style: italic; margin-top: 8px; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; border-right: 1px solid #f1f5f9; color: #475569; font-size: 13.5px; }" +
               "    .btn-container { text-align: center; margin-top: 32px; }" +
               "    .btn-action { display: inline-block; padding: 12px 28px; font-size: 14px; font-weight: 600; color: #ffffff !important; background-color: #4f46e5; text-decoration: none; border-radius: 8px; box-shadow: 0 4px 10px rgba(79, 70, 229, 0.2); transition: background-color 0.2s ease; }" +
               "    .email-footer { background-color: #f8fafc; padding: 24px; text-align: center; font-size: 12px; color: #94a3b8; border-top: 1px solid #e2e8f0; }" +
               "  </style>" +
               "</head>" +
               "<body>" +
               "  <div class='email-container'>" +
               "    <div class='email-header'>" +
               "      <h2>Smart Campus Updates</h2>" +
               "    </div>" +
               "    <div class='email-body'>" +
               "      <div class='greeting'>Hello, " + studentName + "!</div>" +
               "      <p class='intro'>There is an update regarding the complaint ticket you raised on our platform. Please review the details below:</p>" +
               "      <div style='text-align: center;'><span class='status-badge'>" + statusText + "</span></div>" +
               "      <div class='detail-card'>" +
               "        <div class='detail-row'><span class='detail-label'>Complaint Title</span><span class='detail-val'>" + complaintTitle + "</span></div>" +
               "        <div class='detail-row'><span class='detail-label'>Assigned To</span><span class='detail-val'>" + (workerName != null ? workerName : "Unassigned") + "</span></div>" +
               "        <div class='detail-row' style='flex-direction: column; border-bottom: none;'>" +
               "          <span class='detail-label' style='margin-bottom: 6px;'>Latest Status Remarks</span>" +
               "          <div class='remark-box'>\"" + (remark != null && !remark.isEmpty() ? remark : "No remarks provided.") + "\"</div>" +
               "        </div>" +
               "      </div>" +
               "      <div class='btn-container'>" +
               "        <a href='http://localhost:8080/smart-campus/student/trackComplaints' class='btn-action'>Track Complaint</a>" +
               "      </div>" +
               "    </div>" +
               "    <div class='email-footer'>" +
               "      This is an automated system notification. Please do not reply directly to this message.<br>" +
               "      &copy; 2026 Smart Campus Management System. All rights reserved." +
               "    </div>" +
               "  </div>" +
               "</body>" +
               "</html>";
    }

    /**
     * Pre-compiles a beautifully styled, premium, responsive HTML email alert for Resource Booking Confirmations.
     */
    public static String buildBookingConfirmationEmail(String studentName, String resourceName, String bookingDate, String timeFrame, String status, String remark) {
        String statusColor = "#f59e0b"; // Pending Warning Yellow
        String statusText = status.toUpperCase();

        if ("approved".equalsIgnoreCase(status)) statusColor = "#10b981"; // Approved Success Green
        else if ("rejected".equalsIgnoreCase(status)) statusColor = "#ef4444"; // Rejected Danger Red

        return "<!DOCTYPE html>" +
               "<html>" +
               "<head>" +
               "  <meta charset='utf-8'>" +
               "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
               "  <title>Smart Campus Booking Confirmation</title>" +
               "  <style>" +
               "    body { font-family: 'Outfit', 'Inter', -apple-system, sans-serif; background-color: #f8fafc; color: #334155; margin: 0; padding: 0; -webkit-font-smoothing: antialiased; }" +
               "    .email-container { max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; }" +
               "    .email-header { background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%); padding: 32px 24px; text-align: center; color: #ffffff; }" +
               "    .email-header h2 { margin: 0; font-size: 24px; font-weight: 700; letter-spacing: -0.5px; }" +
               "    .email-body { padding: 32px 24px; }" +
               "    .greeting { font-size: 18px; font-weight: 600; color: #1e293b; margin-top: 0; margin-bottom: 8px; }" +
               "    .intro { font-size: 15px; line-height: 1.6; color: #64748b; margin-bottom: 24px; }" +
               "    .status-badge { display: inline-block; padding: 6px 14px; font-size: 13px; font-weight: 600; text-transform: uppercase; border-radius: 30px; color: #ffffff; background-color: " + statusColor + "; margin-bottom: 24px; }" +
               "    .detail-card { background-color: #f8fafc; border-radius: 12px; padding: 20px; border: 1px solid #f1f5f9; margin-bottom: 24px; }" +
               "    .detail-row { display: flex; justify-content: space-between; border-bottom: 1px solid #e2e8f0; padding: 8px 0; font-size: 14px; }" +
               "    .detail-row:last-child { border-bottom: none; }" +
               "    .detail-label { font-weight: 600; color: #475569; width: 140px; flex-shrink: 0; }" +
               "    .detail-val { color: #1e293b; text-align: right; flex-grow: 1; }" +
               "    .remark-box { background-color: #ffffff; border-left: 4px solid " + statusColor + "; padding: 12px 16px; border-radius: 4px; font-style: italic; margin-top: 8px; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; border-right: 1px solid #f1f5f9; color: #475569; font-size: 13.5px; }" +
               "    .btn-container { text-align: center; margin-top: 32px; }" +
               "    .btn-action { display: inline-block; padding: 12px 28px; font-size: 14px; font-weight: 600; color: #ffffff !important; background-color: #0ea5e9; text-decoration: none; border-radius: 8px; box-shadow: 0 4px 10px rgba(14, 165, 233, 0.2); transition: background-color 0.2s ease; }" +
               "    .email-footer { background-color: #f8fafc; padding: 24px; text-align: center; font-size: 12px; color: #94a3b8; border-top: 1px solid #e2e8f0; }" +
               "  </style>" +
               "</head>" +
               "<body>" +
               "  <div class='email-container'>" +
               "    <div class='email-header'>" +
               "      <h2>Smart Campus Bookings</h2>" +
               "    </div>" +
               "    <div class='email-body'>" +
               "      <div class='greeting'>Hello, " + studentName + "!</div>" +
               "      <p class='intro'>The status of your resource booking request has been updated. Please find the reservation metrics below:</p>" +
               "      <div style='text-align: center;'><span class='status-badge'>" + statusText + "</span></div>" +
               "      <div class='detail-card'>" +
               "        <div class='detail-row'><span class='detail-label'>Resource Name</span><span class='detail-val'>" + resourceName + "</span></div>" +
               "        <div class='detail-row'><span class='detail-label'>Reserved Date</span><span class='detail-val'>" + bookingDate + "</span></div>" +
               "        <div class='detail-row'><span class='detail-label'>Time Frame</span><span class='detail-val'>" + timeFrame + "</span></div>" +
               "        <div class='detail-row' style='flex-direction: column; border-bottom: none;'>" +
               "          <span class='detail-label' style='margin-bottom: 6px;'>Administrator Remark</span>" +
               "          <div class='remark-box'>\"" + (remark != null && !remark.isEmpty() ? remark : "No remarks provided.") + "\"</div>" +
               "        </div>" +
               "      </div>" +
               "      <div class='btn-container'>" +
               "        <a href='http://localhost:8080/smart-campus/student/myBookings' class='btn-action'>View My Bookings</a>" +
               "      </div>" +
               "    </div>" +
               "    <div class='email-footer'>" +
               "      This is an automated system notification. Please do not reply directly to this message.<br>" +
               "      &copy; 2026 Smart Campus Management System. All rights reserved." +
               "    </div>" +
               "  </div>" +
               "</body>" +
               "</html>";
    }
}
