<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Management - Smart Campus</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- DataTables Bootstrap 5 CSS -->
    <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Global Style Theme Sheet -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    
    <!-- Custom CSS for Premium Design -->
    <style>
        .card-custom {
            background-color: #ffffff;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            border: none;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .table-custom thead th {
            font-weight: 600;
            color: #475569;
            background-color: #f8fafc;
            border-bottom: 1.5px solid #e2e8f0;
            padding: 1rem;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .table-custom tbody td {
            padding: 1.2rem 1rem;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.95rem;
        }
        .form-select, .form-control {
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.6rem 0.8rem;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }
        .form-select:focus, .form-control:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }
        .modal-custom .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }
        .modal-custom .modal-header {
            border-bottom: 1px solid #f1f5f9;
            padding: 1.5rem 2rem;
        }
        .modal-custom .modal-body {
            padding: 2rem;
        }
        .modal-custom .modal-footer {
            border-top: 1px solid #f1f5f9;
            padding: 1.5rem 2rem;
        }
    </style>
</head>
<body>

    <!-- Loading Spinner Overlay -->
    <div id="loadingOverlay" class="position-fixed top-0 start-0 w-100 h-100 d-none justify-content-center align-items-center" style="background: rgba(15, 23, 42, 0.6); z-index: 9999;">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <!-- Include Toast Javascript helper -->
    <script><%@ include file="/WEB-INF/includes/toast.js" %></script>

    <div class="d-flex">
        <!-- SIDEBAR -->
        <jsp:include page="/WEB-INF/includes/sidebar-admin.jsp" />
        
        <!-- MAIN CONTENT AREA -->
        <div class="main-content flex-grow-1 p-4 fade-in">
            <!-- Premium Admin Top Navbar -->
            <jsp:include page="/WEB-INF/includes/navbar-admin.jsp" />
            
            <!-- Header -->
            <div class="mb-4">
                <h2 class="fw-bold text-dark">Complaint Management</h2>
                <p class="text-secondary small">Review student complaints, assign operations, and update statuses.</p>
            </div>
                
                <!-- Filter Row -->
                <div class="card card-custom py-3 px-4 mb-4">
                    <div class="row g-3 align-items-center">
                        <div class="col-md-3">
                            <label for="filterStatus" class="form-label small text-secondary fw-semibold">Status</label>
                            <select class="form-select" id="filterStatus">
                                <option value="">All Statuses</option>
                                <option value="pending">Pending</option>
                                <option value="assigned">Assigned</option>
                                <option value="in_progress">In Progress</option>
                                <option value="resolved">Resolved</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filterCategory" class="form-label small text-secondary fw-semibold">Category</label>
                            <select class="form-select" id="filterCategory">
                                <option value="">All Categories</option>
                                <option value="hostel">Hostel Issue</option>
                                <option value="classroom">Classroom/Furniture</option>
                                <option value="electricity">Electricity</option>
                                <option value="water">Water Supply</option>
                                <option value="lab">Computer Lab</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filterPriority" class="form-label small text-secondary fw-semibold">Priority</label>
                            <select class="form-select" id="filterPriority">
                                <option value="">All Priorities</option>
                                <option value="low">Low</option>
                                <option value="medium">Medium</option>
                                <option value="high">High</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filterSearch" class="form-label small text-secondary fw-semibold">Search Title/Student</label>
                            <input type="text" class="form-control" id="filterSearch" placeholder="Type search term...">
                        </div>
                    </div>
                </div>
                
                <!-- Table Card -->
                <div class="card card-custom">
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle mb-0 w-100" id="complaintsTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Student</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Worker</th>
                                    <th>Date</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="comp" items="${complaints}">
                                    <tr id="row-${comp.id}" 
                                        data-id="${comp.id}" 
                                        data-title="<c:out value="${comp.title}"/>" 
                                        data-student="<c:out value="${comp.studentName}"/>" 
                                        data-category="${comp.category}" 
                                        data-priority="${comp.priority}" 
                                        data-status="${comp.status}"
                                        data-worker-id="${comp.workerId}"
                                        data-deadline="${comp.deadline}">
                                        <td class="fw-semibold text-secondary">#${comp.id}</td>
                                        <td class="fw-bold"><c:out value="${comp.studentName}"/></td>
                                        <td class="text-truncate" style="max-width: 180px;"><c:out value="${comp.title}"/></td>
                                        <td>
                                            <span class="badge badge-custom 
                                                <c:choose>
                                                    <c:when test="${comp.category == 'hostel'}">bg-info-subtle text-info</c:when>
                                                    <c:when test="${comp.category == 'classroom'}">bg-primary-subtle text-primary</c:when>
                                                    <c:when test="${comp.category == 'electricity'}">bg-warning-subtle text-warning</c:when>
                                                    <c:when test="${comp.category == 'water'}">bg-teal-subtle text-teal</c:when>
                                                    <c:when test="${comp.category == 'lab'}">bg-secondary-subtle text-secondary</c:when>
                                                    <c:otherwise>bg-dark-subtle text-dark</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${comp.category}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge badge-custom priority-badge
                                                <c:choose>
                                                    <c:when test="${comp.priority == 'low'}">bg-secondary text-white</c:when>
                                                    <c:when test="${comp.priority == 'medium'}">bg-warning text-dark</c:when>
                                                    <c:when test="${comp.priority == 'high'}">bg-danger text-white</c:when>
                                                    <c:otherwise>bg-secondary text-white</c:otherwise>
                                                </c:choose>">
                                                <c:out value="${comp.priority}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge badge-custom status-badge
                                                <c:choose>
                                                    <c:when test="${comp.status == 'pending'}">bg-secondary text-white</c:when>
                                                    <c:when test="${comp.status == 'assigned'}">bg-primary text-white</c:when>
                                                    <c:when test="${comp.status == 'in_progress'}">bg-warning text-dark</c:when>
                                                    <c:when test="${comp.status == 'resolved'}">bg-success text-white</c:when>
                                                    <c:otherwise>bg-secondary text-white</c:otherwise>
                                                </c:choose>">
                                                <c:choose>
                                                    <c:when test="${comp.status == 'in_progress'}">In Progress</c:when>
                                                    <c:otherwise><c:out value="${comp.status}"/></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="worker-td text-secondary small">
                                            <c:choose>
                                                <c:when test="${not empty comp.workerName}">
                                                    <c:out value="${comp.workerName}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted italic">Unassigned</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-secondary small">
                                            <fmt:formatDate value="${comp.createdAt}" pattern="MMM dd, yyyy"/>
                                        </td>
                                        <td class="text-end">
                                            <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="openAssignModal(${comp.id})">
                                                Manage
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                
            </div> <!-- main-content closed -->
        </div> <!-- d-flex closed -->

    <!-- ASSIGN/MANAGE MODAL -->
    <div class="modal fade modal-custom" id="assignModal" tabindex="-1" aria-labelledby="assignModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="assignModalLabel">Manage Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    
                    <!-- Read-Only Title/Status info -->
                    <div class="mb-4 bg-light p-3 rounded-3">
                        <div class="small text-secondary fw-semibold">Complaint Title</div>
                        <h6 class="fw-bold text-dark mb-2" id="modalTitle">Complaint Title Placeholder</h6>
                        <div class="small text-secondary fw-semibold">Current Status: <span id="modalCurrentStatus" class="badge bg-secondary ms-1">pending</span></div>
                    </div>
                    
                    <form id="assignForm">
                        <input type="hidden" id="modalComplaintId">
                        
                        <!-- Worker Selection -->
                        <div class="mb-3">
                            <label for="workerSelect" class="form-label small text-secondary fw-semibold">Assign Worker</label>
                            <select class="form-select" id="workerSelect">
                                <option value="">-- Select Worker --</option>
                                <c:forEach var="worker" items="${workerList}">
                                    <option value="${worker.id}"><c:out value="${worker.name}"/> (<c:out value="${worker.department}"/>)</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- Deadline Scheduler -->
                        <div class="mb-3">
                            <label for="deadline" class="form-label small text-secondary fw-semibold">Assignment Deadline</label>
                            <input type="date" class="form-control" id="deadline">
                        </div>
                        
                        <!-- Priority Switcher -->
                        <div class="mb-3">
                            <label for="prioritySelect" class="form-label small text-secondary fw-semibold">Change Priority</label>
                            <select class="form-select" id="prioritySelect">
                                <option value="low">Low</option>
                                <option value="medium">Medium</option>
                                <option value="high">High</option>
                            </select>
                        </div>
                        
                        <!-- Status Switcher -->
                        <div class="mb-3">
                            <label for="statusSelect" class="form-label small text-secondary fw-semibold">Change Status</label>
                            <select class="form-select" id="statusSelect">
                                <option value="pending">Pending</option>
                                <option value="assigned">Assigned</option>
                                <option value="in_progress">In Progress</option>
                                <option value="resolved">Resolved</option>
                            </select>
                        </div>
                        
                        <!-- Admin Remarks Audit -->
                        <div class="mb-3">
                            <label for="remark" class="form-label small text-secondary fw-semibold">Admin Remark / Audit comments</label>
                            <textarea class="form-control" id="remark" rows="3" placeholder="Provide audit logging remark for the status transition..."></textarea>
                        </div>
                        
                    </form>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary btn-primary-custom rounded-pill px-4" onclick="saveAssignment()">Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- CDNs JQuery and Datatables -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side DataTable and AJAX Assignment Operations -->
    <script>
        let table;
        let activeRow;

        $(document).ready(function() {
            // Set min deadline date to today dynamically
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('deadline').min = today;

            // Initialize Datatable
            table = $('#complaintsTable').DataTable({
                "pageLength": 10,
                "order": [[0, "desc"]],
                "dom": "tp", // Simplify DOM elements showing only table and pagination
                "columnDefs": [
                    { "orderable": false, "targets": [3, 4, 5, 8] }
                ]
            });

            // Status custom filtering
            $('#filterStatus').on('change', function() {
                table.column(5).search(this.value).draw();
            });

            // Category custom filtering
            $('#filterCategory').on('change', function() {
                table.column(3).search(this.value).draw();
            });

            // Priority custom filtering
            $('#filterPriority').on('change', function() {
                table.column(4).search(this.value).draw();
            });

            // Search filtering
            $('#filterSearch').on('keyup', function() {
                table.search(this.value).draw();
            });

            // Sync selectors in case worker is selected
            $('#workerSelect').on('change', function() {
                if (this.value) {
                    $('#statusSelect').val('assigned');
                }
            });
        });

        function openAssignModal(id) {
            activeRow = document.getElementById(`row-${id}`);
            
            const title = activeRow.getAttribute('data-title');
            const status = activeRow.getAttribute('data-status');
            const priority = activeRow.getAttribute('data-priority');
            const workerId = activeRow.getAttribute('data-worker-id');
            const deadline = activeRow.getAttribute('data-deadline');

            // Populate Modal inputs
            document.getElementById('modalComplaintId').value = id;
            document.getElementById('modalTitle').textContent = title;
            document.getElementById('modalCurrentStatus').textContent = status;
            document.getElementById('modalCurrentStatus').className = 'badge ms-1 ' + getStatusClass(status);
            
            document.getElementById('workerSelect').value = (workerId && workerId !== 'null') ? workerId : '';
            document.getElementById('deadline').value = (deadline && deadline !== 'null') ? deadline : '';
            document.getElementById('prioritySelect').value = priority;
            document.getElementById('statusSelect').value = status;
            document.getElementById('remark').value = '';

            const modal = new bootstrap.Modal(document.getElementById('assignModal'));
            modal.show();
        }

        function saveAssignment() {
            const id = document.getElementById('modalComplaintId').value;
            const workerId = document.getElementById('workerSelect').value;
            const deadline = document.getElementById('deadline').value;
            const priority = document.getElementById('prioritySelect').value;
            const newStatus = document.getElementById('statusSelect').value;
            const remark = document.getElementById('remark').value;

            const payload = {
                complaintId: parseInt(id),
                workerId: workerId ? parseInt(workerId) : null,
                deadline: deadline || null,
                priority: priority,
                newStatus: newStatus,
                remark: remark || "Updated by Admin"
            };

            // Show loader overlay spinner
            document.getElementById('loadingOverlay').classList.remove('d-none');

            // Call AJAX post using fetch API
            fetch('${pageContext.request.contextPath}/admin/assignWorker', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(payload)
            })
            .then(res => res.json())
            .then(data => {
                // Hide loader overlay spinner
                document.getElementById('loadingOverlay').classList.add('d-none');

                if (data.success) {
                    // Update table row attributes & cells without reloading page
                    activeRow.setAttribute('data-status', newStatus);
                    activeRow.setAttribute('data-priority', priority);
                    activeRow.setAttribute('data-worker-id', workerId || 'null');
                    activeRow.setAttribute('data-deadline', deadline || 'null');

                    // 1. Update priority badge
                    const prioBadge = activeRow.querySelector('.priority-badge');
                    prioBadge.textContent = priority;
                    prioBadge.className = 'badge badge-custom priority-badge ' + getPriorityClass(priority);

                    // 2. Update status badge
                    const statBadge = activeRow.querySelector('.status-badge');
                    statBadge.textContent = newStatus === 'in_progress' ? 'In Progress' : newStatus;
                    statBadge.className = 'badge badge-custom status-badge ' + getStatusClass(newStatus);

                    // 3. Update worker name text
                    const workerTd = activeRow.querySelector('.worker-td');
                    if (workerId) {
                        const selectEl = document.getElementById('workerSelect');
                        const workerName = selectEl.options[selectEl.selectedIndex].text.split('(')[0].trim();
                        workerTd.textContent = workerName;
                    } else {
                        workerTd.innerHTML = '<span class="text-muted italic">Unassigned</span>';
                    }

                    // Re-draw Datatable rows to preserve clean indexing and sort orders
                    table.row(activeRow).invalidate().draw(false);

                    // Close Modal
                    bootstrap.Modal.getInstance(document.getElementById('assignModal')).hide();
                    
                    // Show premium success toast alert
                    showToast('Complaint updated successfully!', 'success');
                } else {
                    showToast('Failed to update complaint: ' + data.message, 'error');
                }
            })
            .catch(err => {
                // Hide loader overlay spinner
                document.getElementById('loadingOverlay').classList.add('d-none');
                console.error('Error executing AJAX assignment request: ', err);
                showToast('An error occurred while saving.', 'error');
            });
        }

        function getPriorityClass(priority) {
            switch(priority) {
                case 'low': return 'bg-secondary text-white';
                case 'medium': return 'bg-warning text-dark';
                case 'high': return 'bg-danger text-white';
                default: return 'bg-secondary text-white';
            }
        }

        function getStatusClass(status) {
            switch(status) {
                case 'pending': return 'bg-secondary text-white';
                case 'assigned': return 'bg-primary text-white';
                case 'in_progress': return 'bg-warning text-dark';
                case 'resolved': return 'bg-success text-white';
                default: return 'bg-secondary text-white';
            }
        }
    </script>
</body>
</html>
