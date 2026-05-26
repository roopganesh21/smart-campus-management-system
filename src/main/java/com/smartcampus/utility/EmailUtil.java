package com.smartcampus.utility;

import java.util.logging.Logger;

/**
 * EmailUtil automates SMTP mailing alerts for system notifications using Jakarta Mail.
 * It will trigger alert emails when complaints are filed, assigned, or resolved.
 */
public class EmailUtil {
    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    /**
     * Send email notifications.
     * Currently implemented as a stub logger since full SMTP configuration is pending.
     */
    public static void sendEmail(String to, String subject, String body) {
        LOGGER.info(String.format("[STUB EMAIL] Sending email to: %s | Subject: %s | Body: %s", to, subject, body));
    }
}
