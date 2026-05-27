package com.smartcampus.utility;

import jakarta.servlet.http.HttpServletRequest;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * FileUploadUtil assists with server-side document upload storage.
 * It parses multipart form payloads using Commons FileUpload, validates files, and persists them.
 * 
 * =========================================================================
 * ℹ️ HOW COMMONS FILEUPLOAD PROCESSES MULTIPART STREAMS VS request.getParameter():
 * =========================================================================
 * 1. Standard application/x-www-form-urlencoded payloads send fields as plain key=value strings.
 *    The servlet container parses these automatically, populating request.getParameter() maps.
 * 
 * 2. File uploads require multipart/form-data encoding. The payload is divided into discrete parts,
 *    demarcated by a unique boundary string, with individual headers (e.g., Content-Disposition) and
 *    binary streams.
 * 
 * 3. The standard request.getParameter() method returns null or is empty for multipart bodies, 
 *    as the container does not parse boundary separators natively by default unless a framework 
 *    or special configuration is registered.
 * 
 * 4. Commons FileUpload intercepts the raw HTTP request input stream, parses the boundary lines,
 *    and encapsulates each component into a FileItem. It distinguishes between regular text fields
 *    (FileItem.isFormField() == true) and binary files (FileItem.isFormField() == false) without
 *    loading the entire request into application heap memory, allowing high-performance streaming.
 */
public class FileUploadUtil {

    private static final Logger LOGGER = Logger.getLogger(FileUploadUtil.class.getName());

    // Static constant: Max 5MB per file
    public static final long MAX_FILE_SIZE = 5 * 1024 * 1024L;

    // Allowed image file extensions
    private static final String[] ALLOWED_EXTENSIONS = { "jpg", "jpeg", "png", "gif" };

    /**
     * Custom RequestContext adapter wrapping jakarta.servlet.http.HttpServletRequest.
     * Required because Commons FileUpload 1.5 targets the javax.servlet package namespaces,
     * whereas Tomcat 10 uses the modern jakarta.servlet packages.
     */
    private static class JakartaRequestContext implements RequestContext {
        private final HttpServletRequest request;

        public JakartaRequestContext(HttpServletRequest request) {
            this.request = request;
        }

        @Override
        public String getCharacterEncoding() {
            return request.getCharacterEncoding();
        }

        @Override
        public String getContentType() {
            return request.getContentType();
        }

        @Override
        public int getContentLength() {
            return request.getContentLength();
        }

        @Override
        public InputStream getInputStream() throws IOException {
            return request.getInputStream();
        }
    }

    /**
     * Helper checks whether the request has multipart/form-data encoding.
     */
    public static boolean isMultipartContent(HttpServletRequest request) {
        if (request == null) {
            return false;
        }
        String contentType = request.getContentType();
        return contentType != null && contentType.toLowerCase().startsWith("multipart/");
    }

    /**
     * Parses multipart/form-data requests, runs size and type validations, 
     * writes files to webapp upload directory, and returns their relative paths.
     * 
     * @param request        Jakarta HttpServletRequest
     * @param uploadDirName  target directory folder (e.g., "complaint-images")
     * @param fieldName      the input type="file" form field name
     * @return List of relative paths (e.g., "uploads/complaint-images/uuid_filename.jpg")
     * @throws IllegalArgumentException on file format, size, or count violations
     * @throws RuntimeException on disk write failures or parse errors
     */
    public static List<String> uploadFiles(HttpServletRequest request, String uploadDirName, String fieldName) {
        
        // 1. Verify that request is multipart
        if (!isMultipartContent(request)) {
            LOGGER.warning("Upload rejected: Request is not multipart/form-data.");
            throw new IllegalArgumentException("Multipart request is required.");
        }

        List<String> savedPaths = new ArrayList<>();

        // 2. Set up target filesystem path under webapp root
        String contextPath = request.getServletContext().getRealPath("");
        if (contextPath == null) {
            LOGGER.warning("Could not resolve webapp context real path. Defaulting to local workspace.");
            contextPath = new File(".").getAbsolutePath();
        }
        
        String uploadDirPath = contextPath + File.separator + "uploads" + File.separator + uploadDirName;
        File uploadDirFile = new File(uploadDirPath);
        if (!uploadDirFile.exists()) {
            boolean created = uploadDirFile.mkdirs();
            if (created) {
                LOGGER.info("Upload directory successfully created: " + uploadDirPath);
            }
        }

        // 3. Configure DiskFileItemFactory and generic FileUpload
        DiskFileItemFactory factory = new DiskFileItemFactory();
        FileUpload upload = new FileUpload(factory);

        try {
            // 4. Parse request using Jakarta RequestContext Adapter
            List<FileItem> fileItems = upload.parseRequest(new JakartaRequestContext(request));
            List<FileItem> uploadedFiles = new ArrayList<>();

            // Filter out regular form fields and empty file inputs
            for (FileItem item : fileItems) {
                if (!item.isFormField() && fieldName.equals(item.getFieldName()) && item.getSize() > 0) {
                    uploadedFiles.add(item);
                }
            }

            // 5. Enforce max file count constraint (max 5 per complaint)
            if (uploadedFiles.size() > 5) {
                LOGGER.warning("Upload rejected: Attempted to upload " + uploadedFiles.size() + " files. Limit: 5");
                throw new IllegalArgumentException("Maximum of 5 files are allowed per complaint.");
            }

            // 6. Process and validate each file item
            for (FileItem item : uploadedFiles) {
                String originalFilename = item.getName();
                
                // Extract filename only (handles IE/Edge absolute path forms)
                if (originalFilename.contains(File.separator)) {
                    originalFilename = originalFilename.substring(originalFilename.lastIndexOf(File.separator) + 1);
                } else if (originalFilename.contains("/")) {
                    originalFilename = originalFilename.substring(originalFilename.lastIndexOf("/") + 1);
                }

                // A. Validate extension format
                if (!isValidImageFile(originalFilename)) {
                    LOGGER.warning("Upload rejected: Unsupported extension type for file: " + originalFilename);
                    throw new IllegalArgumentException("Only image files allowed (jpg, jpeg, png, gif).");
                }

                // B. Validate max size (5MB per file)
                long size = item.getSize();
                if (size > MAX_FILE_SIZE) {
                    LOGGER.warning("Upload rejected: File size (" + size + " bytes) exceeds 5MB limit: " + originalFilename);
                    throw new IllegalArgumentException("File size exceeds the 5MB limit: " + originalFilename);
                }

                // C. Sanitize and generate unique filename to prevent overwrites or directory traversals
                String sanitized = originalFilename.replaceAll("[^a-zA-Z0-9.-]", "_");
                String uniqueFilename = UUID.randomUUID().toString() + "_" + sanitized;

                // D. Write file to disk
                File targetFile = new File(uploadDirFile, uniqueFilename);
                item.write(targetFile);

                // E. Perform secondary MIME check to prevent file spoofing (MIME validation)
                try {
                    String contentType = java.nio.file.Files.probeContentType(targetFile.toPath());
                    if (contentType == null || !contentType.startsWith("image/")) {
                        LOGGER.warning("Upload rejected: Spoofed MIME type detected for: " + originalFilename + " (MIME resolved: " + contentType + ")");
                        targetFile.delete(); // Immediately purge invalid file
                        throw new IllegalArgumentException("Only valid image files are allowed. Spoofed file type detected.");
                    }
                } catch (IOException e) {
                    LOGGER.log(Level.WARNING, "Failed to resolve MIME type for file: " + originalFilename + ". Proceeding with caution.", e);
                }

                // F. Resolve relative path for database registry
                String relativePath = "uploads/" + uploadDirName + "/" + uniqueFilename;
                savedPaths.add(relativePath);

                LOGGER.info("Successfully uploaded file: " + originalFilename + " -> Saved as: " + relativePath);
            }

            return savedPaths;

        } catch (FileUploadException e) {
            LOGGER.log(Level.SEVERE, "Commons FileUpload failed to parse stream.", e);
            throw new RuntimeException("System failed to parse file upload request.", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error while writing uploaded file to target disk path.", e);
            throw new RuntimeException("System failed to write uploaded files to disk.", e);
        }
    }

    /**
     * Helper check validating if file has supported image extensions.
     */
    public static boolean isValidImageFile(String filename) {
        if (filename == null || filename.isEmpty()) {
            return false;
        }
        String lower = filename.toLowerCase();
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lower.endsWith("." + ext)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Deletes a file on the disk given its relative path.
     * 
     * @param relativePath relative file path (e.g., "uploads/complaint-images/uuid_filename.jpg")
     * @param request      Jakarta HttpServletRequest used to get absolute context path
     * @return true if deleted, false if file did not exist or delete failed
     */
    public static boolean deleteFile(String relativePath, HttpServletRequest request) {
        if (relativePath == null || relativePath.isEmpty()) {
            return false;
        }

        String contextPath = request.getServletContext().getRealPath("");
        if (contextPath == null) {
            contextPath = new File(".").getAbsolutePath();
        }

        // Replace relative forward slashes with system separators
        String cleanRelativePath = relativePath.replace("/", File.separator);
        String absolutePath = contextPath + File.separator + cleanRelativePath;

        File targetFile = new File(absolutePath);
        if (targetFile.exists() && targetFile.isFile()) {
            boolean deleted = targetFile.delete();
            if (deleted) {
                LOGGER.info("File successfully deleted from disk: " + absolutePath);
                return true;
            } else {
                LOGGER.warning("Failed to delete file from disk: " + absolutePath);
                return false;
            }
        }
        
        LOGGER.warning("Attempted to delete non-existing file or directory: " + absolutePath);
        return false;
    }
}
