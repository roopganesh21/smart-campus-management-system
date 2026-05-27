package com.smartcampus.controller;

import com.smartcampus.dao.ComplaintDAO;
import com.smartcampus.model.Complaint;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfWriter;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ExportServlet is responsible for generating dynamic reports.
 * It uses iText to generate PDF documents and Apache POI to generate Excel spreadsheets
 * for analytical reporting of complaints.
 */
@WebServlet("/admin/export")
public class ExportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ExportServlet.class.getName());
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
            LOGGER.warning("Unauthorized export attempt.");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access.");
            return;
        }

        String type = request.getParameter("type");
        LOGGER.info("ExportServlet triggered for type: " + type);

        if ("pdf".equalsIgnoreCase(type)) {
            exportPdf(response);
        } else if ("excel".equalsIgnoreCase(type)) {
            exportExcel(response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid export type specified.");
        }
    }

    private void exportPdf(HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"campus-report.pdf\"");

        List<Complaint> complaints = complaintDAO.getAllComplaints();
        Map<String, Integer> stats = complaintDAO.getComplaintStats();

        int total = stats.getOrDefault("total", 0);
        int resolved = stats.getOrDefault("resolved", 0);
        int pending = stats.getOrDefault("pending", 0);
        int inProgress = stats.getOrDefault("in_progress", 0);
        int assigned = stats.getOrDefault("assigned", 0);

        Document document = new Document(com.itextpdf.text.PageSize.A4);
        try {
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            // Add page number event helper
            writer.setPageEvent(new PageNumberHelper());
            
            document.open();

            // 1. Add Title
            com.itextpdf.text.Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, new BaseColor(37, 99, 235)); // #2563eb
            Paragraph title = new Paragraph("Smart Campus Complaint Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(10);
            document.add(title);

            // 2. Add Generation Date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            com.itextpdf.text.Font dateFont = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.GRAY);
            Paragraph dateStr = new Paragraph("Generated on: " + sdf.format(new Date()), dateFont);
            dateStr.setAlignment(Element.ALIGN_CENTER);
            dateStr.setSpacingAfter(20);
            document.add(dateStr);

            // 3. Add Summary Paragraph
            com.itextpdf.text.Font bodyFont = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.BLACK);
            String summaryText = String.format(
                "Executive Summary: A total of %d complaints have been registered in the system. " +
                "To date, %d complaints have been successfully resolved, %d are currently pending assignment, " +
                "%d have been assigned to service workers, and %d are actively in progress.",
                total, resolved, pending, assigned, inProgress
            );
            Paragraph summary = new Paragraph(summaryText, bodyFont);
            summary.setSpacingAfter(25);
            summary.setLeading(16f);
            document.add(summary);

            // 4. Create PdfPTable
            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{1.0f, 3.0f, 1.8f, 1.5f, 1.8f, 2.2f}); // Relative column widths

            // Header Style
            com.itextpdf.text.Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
            BaseColor headerBg = new BaseColor(30, 41, 59); // #1e293b

            String[] headers = {"ID", "Title", "Category", "Priority", "Status", "Date Raised"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(headerBg);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                cell.setPadding(8);
                table.addCell(cell);
            }

            // Alternating rows style
            BaseColor altRowBg = new BaseColor(248, 250, 252); // #f8fafc
            BaseColor borderCol = new BaseColor(226, 232, 240); // #e2e8f0
            com.itextpdf.text.Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK);

            SimpleDateFormat dateSdf = new SimpleDateFormat("yyyy-MM-dd");

            int rowIdx = 0;
            for (Complaint c : complaints) {
                BaseColor bg = (rowIdx % 2 == 1) ? altRowBg : BaseColor.WHITE;
                
                String raisedDate = c.getCreatedAt() != null ? dateSdf.format(c.getCreatedAt()) : "-";

                addStyledCell(table, String.valueOf(c.getId()), cellFont, bg, borderCol, Element.ALIGN_CENTER);
                addStyledCell(table, c.getTitle(), cellFont, bg, borderCol, Element.ALIGN_LEFT);
                addStyledCell(table, c.getCategory(), cellFont, bg, borderCol, Element.ALIGN_CENTER);
                addStyledCell(table, c.getPriority(), cellFont, bg, borderCol, Element.ALIGN_CENTER);
                addStyledCell(table, c.getStatus(), cellFont, bg, borderCol, Element.ALIGN_CENTER);
                addStyledCell(table, raisedDate, cellFont, bg, borderCol, Element.ALIGN_CENTER);
                
                rowIdx++;
            }

            document.add(table);

        } catch (DocumentException e) {
            LOGGER.log(Level.SEVERE, "iText compilation or building error.", e);
            throw new IOException("PDF generation failed due to formatting issues.", e);
        } finally {
            if (document.isOpen()) {
                document.close();
            }
        }
    }

    private void addStyledCell(PdfPTable table, String text, com.itextpdf.text.Font font, BaseColor bg, BaseColor border, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(text != null ? text : "", font));
        cell.setBackgroundColor(bg);
        cell.setBorderColor(border);
        cell.setHorizontalAlignment(align);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(6);
        table.addCell(cell);
    }

    private void exportExcel(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"campus-complaints.xlsx\"");

        List<Complaint> complaints = complaintDAO.getAllComplaints();
        Map<String, Integer> stats = complaintDAO.getComplaintStats();

        try (Workbook workbook = new XSSFWorkbook()) {
            // Sheet 1: Complaints List
            Sheet sheet = workbook.createSheet("Complaints");

            // Define styles
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_80_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);

            // Row Header
            Row headerRow = sheet.createRow(0);
            String[] headers = {"Complaint ID", "Title", "Category", "Priority", "Status", "Date Raised", "Assigned Worker"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Create borders & formatting for data
            CellStyle normalStyle = workbook.createCellStyle();
            normalStyle.setBorderBottom(BorderStyle.THIN);
            normalStyle.setBorderTop(BorderStyle.THIN);
            normalStyle.setBorderLeft(BorderStyle.THIN);
            normalStyle.setBorderRight(BorderStyle.THIN);

            SimpleDateFormat dateSdf = new SimpleDateFormat("yyyy-MM-dd");

            int rowIdx = 1;
            for (Complaint c : complaints) {
                Row row = sheet.createRow(rowIdx++);
                
                Cell cell0 = row.createCell(0);
                cell0.setCellValue(c.getId());
                cell0.setCellStyle(normalStyle);

                Cell cell1 = row.createCell(1);
                cell1.setCellValue(c.getTitle());
                cell1.setCellStyle(normalStyle);

                Cell cell2 = row.createCell(2);
                cell2.setCellValue(c.getCategory());
                cell2.setCellStyle(normalStyle);

                Cell cell3 = row.createCell(3);
                cell3.setCellValue(c.getPriority());
                cell3.setCellStyle(normalStyle);

                // Highlight status cell
                Cell cell4 = row.createCell(4);
                cell4.setCellValue(c.getStatus());
                
                CellStyle statusStyle = workbook.createCellStyle();
                statusStyle.cloneStyleFrom(normalStyle);
                statusStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                String status = c.getStatus() != null ? c.getStatus().toLowerCase() : "";
                if ("resolved".equals(status)) {
                    statusStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
                } else if ("pending".equals(status)) {
                    statusStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
                } else if ("assigned".equals(status)) {
                    statusStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
                } else if ("in_progress".equals(status)) {
                    statusStyle.setFillForegroundColor(IndexedColors.LIGHT_TURQUOISE.getIndex());
                } else {
                    statusStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
                }
                cell4.setCellStyle(statusStyle);

                Cell cell5 = row.createCell(5);
                cell5.setCellValue(c.getCreatedAt() != null ? dateSdf.format(c.getCreatedAt()) : "-");
                cell5.setCellStyle(normalStyle);

                Cell cell6 = row.createCell(6);
                cell6.setCellValue(c.getWorkerName() != null ? c.getWorkerName() : "Unassigned");
                cell6.setCellStyle(normalStyle);
            }

            // Auto-size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Sheet 2: Summary Stats
            Sheet summarySheet = workbook.createSheet("Summary");

            Row sumHeaderRow = summarySheet.createRow(0);
            Cell sumHeaderCell = sumHeaderRow.createCell(0);
            sumHeaderCell.setCellValue("Smart Campus KPI Dashboard Summary");
            CellStyle sumHeaderStyle = workbook.createCellStyle();
            Font sumHeaderFont = workbook.createFont();
            sumHeaderFont.setBold(true);
            sumHeaderFont.setFontHeightInPoints((short) 14);
            sumHeaderStyle.setFont(sumHeaderFont);
            sumHeaderCell.setCellStyle(sumHeaderStyle);

            int total = stats.getOrDefault("total", 0);
            int resolved = stats.getOrDefault("resolved", 0);
            int pending = stats.getOrDefault("pending", 0);
            int inProgress = stats.getOrDefault("in_progress", 0);
            int assigned = stats.getOrDefault("assigned", 0);

            String[] metrics = {"Metric Description", "Total Value"};
            Row labelRow = summarySheet.createRow(2);
            for (int i = 0; i < metrics.length; i++) {
                Cell cell = labelRow.createCell(i);
                cell.setCellValue(metrics[i]);
                cell.setCellStyle(headerStyle);
            }

            addSummaryRow(summarySheet, 3, "Total Filed Complaints", total, normalStyle);
            addSummaryRow(summarySheet, 4, "Resolved Complaints", resolved, normalStyle);
            addSummaryRow(summarySheet, 5, "Pending Complaints", pending, normalStyle);
            addSummaryRow(summarySheet, 6, "Assigned Complaints", assigned, normalStyle);
            addSummaryRow(summarySheet, 7, "In Progress Complaints", inProgress, normalStyle);

            summarySheet.autoSizeColumn(0);
            summarySheet.autoSizeColumn(1);

            workbook.write(response.getOutputStream());
        }
    }

    private void addSummaryRow(Sheet sheet, int rowIdx, String label, int value, CellStyle style) {
        Row row = sheet.createRow(rowIdx);
        Cell cell0 = row.createCell(0);
        cell0.setCellValue(label);
        cell0.setCellStyle(style);

        Cell cell1 = row.createCell(1);
        cell1.setCellValue(value);
        cell1.setCellStyle(style);
    }

    /**
     * PageNumberHelper dynamically adds page footers to PDF documents.
     */
    private static class PageNumberHelper extends PdfPageEventHelper {
        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            PdfContentByte cb = writer.getDirectContent();
            cb.beginText();
            try {
                BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                cb.setFontAndSize(bf, 8);
                cb.setColorFill(BaseColor.GRAY);
                
                String footerText = "Page " + writer.getPageNumber();
                float x = (document.right() - document.left()) / 2 + document.leftMargin();
                float y = document.bottom() - 15;
                
                cb.showTextAligned(PdfContentByte.ALIGN_CENTER, footerText, x, y, 0);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed generating PDF footer numbers.", e);
            } finally {
                cb.endText();
            }
        }
    }
}
