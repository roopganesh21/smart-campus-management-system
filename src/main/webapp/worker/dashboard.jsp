<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Worker Dashboard - Smart Campus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5 text-center">
        <div class="card shadow p-5 mx-auto" style="max-width: 600px;">
            <h1 class="text-info mb-4">Worker Dashboard</h1>
            <p class="fs-4">Welcome, <strong>${userName}</strong>!</p>
            <p class="text-muted">Registered Role: <span class="badge bg-secondary">${userRole}</span></p>
            <hr class="my-4">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Log Out</a>
        </div>
    </div>
</body>
</html>
