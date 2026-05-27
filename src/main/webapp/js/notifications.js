/**
 * Smart Campus Complaint & Resource Management System
 * AJAX Notification Handling & Live Updates
 */

class NotificationManager {
    constructor() {
        this.contextPath = window.contextPath || '';
        this.userRole = window.userRole || 'student';
        this.pollInterval = 30000; // Poll every 30 seconds
        this.timerId = null;

        // Cache elements
        this.bellBtn = document.getElementById('nav-bell-btn');
        this.bellBadge = document.getElementById('nav-bell-badge');
        this.notificationsList = document.getElementById('nav-notifications-list');
        this.markAllBtn = document.getElementById('nav-notifications-mark-all');

        this.init();
    }

    init() {
        if (!this.bellBtn) {
            console.warn("Notification bell button not found on this page.");
            return;
        }

        // Run initial count fetch
        this.fetchCount();

        // Start periodic polling
        this.timerId = setInterval(() => this.fetchCount(), this.pollInterval);

        // Bind click event to bell icon to load recent notifications list
        this.bellBtn.addEventListener('click', (e) => {
            e.preventDefault();
            this.fetchList();
        });

        // Bind mark all as read action
        if (this.markAllBtn) {
            this.markAllBtn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation(); // Prevent closing dropdown
                this.markAllAsRead();
            });
        }
    }

    async fetchCount() {
        try {
            const response = await fetch(`${this.contextPath}/notifications?action=count`);
            if (response.ok) {
                const data = await response.json();
                this.updateBadge(data.unread);
            }
        } catch (error) {
            console.error("Error fetching notification count:", error);
        }
    }

    async fetchList() {
        if (!this.notificationsList) return;

        // Show a loading indicator
        this.notificationsList.innerHTML = `
            <div class="text-center py-4">
                <div class="spinner-border spinner-border-sm text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        `;

        try {
            const response = await fetch(`${this.contextPath}/notifications?action=list`);
            if (response.ok) {
                const notifications = await response.json();
                this.renderList(notifications);
            } else {
                this.notificationsList.innerHTML = `<div class="text-center text-danger py-3 small">Failed to load alerts.</div>`;
            }
        } catch (error) {
            console.error("Error fetching notification list:", error);
            this.notificationsList.innerHTML = `<div class="text-center text-danger py-3 small">Network error.</div>`;
        }
    }

    updateBadge(count) {
        if (!this.bellBadge) return;

        if (count > 0) {
            this.bellBadge.textContent = count;
            this.bellBadge.style.display = 'inline-flex';
            
            // Add premium wiggle micro-animation to the bell
            const bellIcon = this.bellBtn.querySelector('svg');
            if (bellIcon) {
                bellIcon.classList.add('animate-wiggle');
            }
        } else {
            this.bellBadge.textContent = '';
            this.bellBadge.style.display = 'none';
            const bellIcon = this.bellBtn.querySelector('svg');
            if (bellIcon) {
                bellIcon.classList.remove('animate-wiggle');
            }
        }
    }

    renderList(notifications) {
        if (!this.notificationsList) return;

        if (notifications.length === 0) {
            this.notificationsList.innerHTML = `
                <div class="text-center py-4 px-3 text-secondary">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-bell-slash mb-2 text-muted" viewBox="0 0 16 16">
                        <path d="M5.164 14H15c-.3 0-.8-1.11-1-1.343L5.164 14zM13.678 12.332 3.68 2.335l-.707.707 1.25 1.25C4.085 4.707 4 5.337 4 6c0 1.098-.5 6-2 7h10.293l1.835 1.835.707-.707zM10 6c0 .11-.004.22-.012.328L5.32 1.66A5.002 5.002 0 0 1 12 6c0 .88.32 4.2 1.22 6H12c-.12 0-.25-.102-.34-.224L10 6.002zM8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2z"/>
                    </svg>
                    <div class="small fw-medium">All caught up!</div>
                    <div class="text-muted" style="font-size: 0.75rem;">No new notifications found.</div>
                </div>
            `;
            return;
        }

        let html = '';
        notifications.forEach(n => {
            const iconHtml = this.getIconForType(n.type);
            const unreadClass = n.isRead ? '' : 'bg-light-subtle font-weight-bold';
            const unreadDot = n.isRead ? '' : `<span class="ms-2 mt-2 p-1 bg-primary rounded-circle" style="width: 6px; height: 6px; flex-shrink: 0;" title="Unread"></span>`;

            html += `
                <div class="dropdown-item d-flex align-items-start p-3 border-bottom notification-item ${unreadClass}" 
                     data-id="${n.id}" data-type="${n.type}" data-related="${n.relatedId}" 
                     style="cursor: pointer; white-space: normal; transition: background-color 0.2s ease;">
                    <div class="me-3 mt-1 flex-shrink-0">
                        ${iconHtml}
                    </div>
                    <div class="flex-grow-1">
                        <div class="small text-dark mb-1 ${n.isRead ? '' : 'fw-semibold'}">${this.escapeHTML(n.message)}</div>
                        <div class="text-muted" style="font-size: 0.75rem;">${n.createdAt}</div>
                    </div>
                    ${unreadDot}
                </div>
            `;
        });

        this.notificationsList.innerHTML = html;

        // Bind click events to notification list items
        const items = this.notificationsList.querySelectorAll('.notification-item');
        items.forEach(item => {
            item.addEventListener('click', (e) => {
                const id = item.getAttribute('data-id');
                const type = item.getAttribute('data-type');
                const relatedId = item.getAttribute('data-related');
                this.handleNotificationClick(id, type, relatedId);
            });
        });
    }

    getIconForType(type) {
        if (type === 'complaint') {
            return `
                <div class="rounded-circle bg-primary-subtle p-2 d-flex align-items-center justify-content-center text-primary" style="width: 32px; height: 32px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-text" viewBox="0 0 16 16">
                        <path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5"/>
                        <path d="M13.5 1a1.5 1.5 0 0 0-1.5-1.5H4A1.5 1.5 0 0 0 2.5 1v14a1.5 1.5 0 0 0 1.5 1.5h8a1.5 1.5 0 0 0 1.5-1.5V3.5zM4 .5h8a.5.5 0 0 1 .5.5v2h-9V1a.5.5 0 0 1 .5-.5M13 15a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5V4h9z"/>
                    </svg>
                </div>
            `;
        } else if (type === 'booking') {
            return `
                <div class="rounded-circle bg-success-subtle p-2 d-flex align-items-center justify-content-center text-success" style="width: 32px; height: 32px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-calendar-check" viewBox="0 0 16 16">
                        <path d="M10.854 7.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 9.793l2.646-2.647a.5.5 0 0 1 .708 0"/>
                        <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z"/>
                    </svg>
                </div>
            `;
        } else {
            return `
                <div class="rounded-circle bg-secondary-subtle p-2 d-flex align-items-center justify-content-center text-secondary" style="width: 32px; height: 32px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bell-fill" viewBox="0 0 16 16">
                        <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zm.995-14.901a1 1 0 1 0-1.99 0A5.002 5.002 0 0 0 3 6c0 1.098-.5 6-2 7h14c-1.5-1-2-5.902-2-7 0-2.42-1.72-4.44-4.005-4.901z"/>
                    </svg>
                </div>
            `;
        }
    }

    async handleNotificationClick(id, type, relatedId) {
        try {
            // Send POST request to mark notification as read
            const response = await fetch(`${this.contextPath}/notifications?action=markRead&id=${id}`, {
                method: 'POST'
            });
            const data = await response.json();
            if (data.success) {
                this.fetchCount(); // Refresh badge
            }
        } catch (error) {
            console.error("Error marking notification read on click:", error);
        }

        // Determine navigation target based on role and notification context
        let targetUrl = `${this.contextPath}/`;
        if (this.userRole === 'student') {
            if (type === 'complaint' && relatedId && relatedId !== 'null') {
                targetUrl += `student/complaintDetail?id=${relatedId}`;
            } else if (type === 'booking') {
                targetUrl += `student/myBookings`;
            } else {
                targetUrl += `student/dashboard`;
            }
        } else if (this.userRole === 'admin') {
            if (type === 'complaint') {
                targetUrl += `admin/manageComplaints`;
            } else if (type === 'booking') {
                targetUrl += `admin/manageBookings`;
            } else {
                targetUrl += `admin/dashboard`;
            }
        } else if (this.userRole === 'worker') {
            targetUrl += `worker/dashboard`;
        }

        window.location.href = targetUrl;
    }

    async markAllAsRead() {
        try {
            const response = await fetch(`${this.contextPath}/notifications?action=markAll`, {
                method: 'POST'
            });
            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    this.updateBadge(0);
                    // Re-render current dropdown list as read
                    const items = this.notificationsList.querySelectorAll('.notification-item');
                    items.forEach(item => {
                        item.classList.remove('bg-light-subtle', 'font-weight-bold');
                        const dot = item.querySelector('.bg-primary.rounded-circle');
                        if (dot) dot.remove();
                    });
                }
            }
        } catch (error) {
            console.error("Error marking all notifications as read:", error);
        }
    }

    escapeHTML(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;')
                  .replace(/</g, '&lt;')
                  .replace(/>/g, '&gt;')
                  .replace(/"/g, '&quot;')
                  .replace(/'/g, '&#039;');
    }
}

// Instantiate on load
document.addEventListener('DOMContentLoaded', () => {
    window.notificationManager = new NotificationManager();
});
