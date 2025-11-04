package org.example.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.util.Map;

@Service
public class EmailService {
    
    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);
    
    @Autowired
    private JavaMailSender mailSender;
    
    @Autowired
    private TemplateEngine templateEngine;
    
    @Value("${app.email.from}")
    private String fromEmail;
    
    @Value("${app.email.name}")
    private String fromName;
    
    @Value("${app.base-url}")
    private String baseUrl;
    
    public void sendWelcomeEmail(String toEmail, String fullName) {
        try {
            Context context = new Context();
            context.setVariable("fullName", fullName);
            context.setVariable("appName", fromName);
            context.setVariable("baseUrl", baseUrl);
            
            String htmlContent = templateEngine.process("welcome-email", context);
            
            sendHtmlEmail(
                toEmail, 
                "Chào mừng bạn đến với " + fromName + "!", 
                htmlContent
            );
            
            logger.info("Welcome email sent successfully to: {}", toEmail);
        } catch (Exception e) {
            logger.error("Failed to send welcome email to: {}", toEmail, e);
        }
    }
    
    public void sendOtpEmail(String toEmail, String fullName, String otp) {
        try {
            Context context = new Context();
            context.setVariable("fullName", fullName);
            context.setVariable("appName", fromName);
            context.setVariable("otp", otp);
            context.setVariable("baseUrl", baseUrl);
            
            String htmlContent = templateEngine.process("otp-email", context);
            
            sendHtmlEmail(
                toEmail, 
                "Mã OTP đặt lại mật khẩu - " + fromName, 
                htmlContent
            );
            
            logger.info("OTP email sent successfully to: {}", toEmail);
        } catch (Exception e) {
            logger.error("Failed to send OTP email to: {}", toEmail, e);
        }
    }

    public void sendPasswordChangeNotification(String toEmail, String fullName) {
        try {
            Context context = new Context();
            context.setVariable("fullName", fullName);
            context.setVariable("appName", fromName);
            context.setVariable("baseUrl", baseUrl);
            
            String htmlContent = templateEngine.process("password-changed-email", context);
            
            sendHtmlEmail(
                toEmail, 
                "Mật khẩu đã được thay đổi - " + fromName, 
                htmlContent
            );
            
            logger.info("Password change notification sent successfully to: {}", toEmail);
        } catch (Exception e) {
            logger.error("Failed to send password change notification to: {}", toEmail, e);
        }
    }
    
    public void sendCustomEmail(String toEmail, String subject, String templateName, Map<String, Object> variables) {
        try {
            Context context = new Context();
            context.setVariable("appName", fromName);
            context.setVariable("baseUrl", baseUrl);
            
            if (variables != null) {
                variables.forEach(context::setVariable);
            }
            
            String htmlContent = templateEngine.process(templateName, context);
            
            sendHtmlEmail(toEmail, subject, htmlContent);
            
            logger.info("Custom email sent successfully to: {} with template: {}", toEmail, templateName);
        } catch (Exception e) {
            logger.error("Failed to send custom email to: {} with template: {}", toEmail, templateName, e);
        }
    }
    
    private void sendHtmlEmail(String toEmail, String subject, String htmlContent) throws MessagingException {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail, fromName);
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);
            
            mailSender.send(message);
        } catch (Exception e) {
            throw new MessagingException("Failed to send HTML email", e);
        }
    }
    
    public void sendPlainTextEmail(String toEmail, String subject, String content) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
            
            helper.setFrom(fromEmail, fromName);
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(content, false);
            
            mailSender.send(message);
            
            logger.info("Plain text email sent successfully to: {}", toEmail);
        } catch (Exception e) {
            logger.error("Failed to send plain text email to: {}", toEmail, e);
        }
    }
}