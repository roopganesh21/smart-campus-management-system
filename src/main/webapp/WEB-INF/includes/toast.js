/**
 * Smart Campus Premium Dynamic Toast Notifications
 * Exposes: showToast(message, type)
 * Types: success, error/danger, warning, info
 */
function showToast(message, type) {
    // 1. Get or dynamically construct the toast container on the fly
    let container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
    }

    // 2. Set colors and icon visual classes depending on severity type
    let bgClass = 'bg-primary text-white';
    let iconClass = 'bi-info-circle-fill';
    let titleText = 'Notice';

    if (type === 'success') {
        bgClass = 'bg-success text-white';
        iconClass = 'bi-check-circle-fill';
        titleText = 'Success';
    } else if (type === 'error' || type === 'danger') {
        bgClass = 'bg-danger text-white';
        iconClass = 'bi-exclamation-triangle-fill';
        titleText = 'Error';
    } else if (type === 'warning') {
        bgClass = 'bg-warning text-dark';
        iconClass = 'bi-exclamation-circle-fill';
        titleText = 'Warning';
    } else if (type === 'info') {
        bgClass = 'bg-info text-white';
        iconClass = 'bi-info-circle-fill';
        titleText = 'Information';
    }

    // 3. Construct dynamic HTML template
    const toastId = 'toast_' + Date.now();
    const toastEl = document.createElement('div');
    toastEl.id = toastId;
    toastEl.className = 'toast custom-toast border-0 shadow-lg';
    toastEl.setAttribute('role', 'alert');
    toastEl.setAttribute('aria-live', 'assertive');
    toastEl.setAttribute('aria-atomic', 'true');
    toastEl.setAttribute('data-bs-delay', '4000'); // Auto-dismiss after 4 seconds

    toastEl.innerHTML = `
        <div class="toast-header ${bgClass} d-flex justify-content-between align-items-center py-2 px-3">
            <span class="d-flex align-items-center fw-bold small">
                <i class="bi ${iconClass} me-2"></i> ${titleText}
            </span>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body text-slate-800 bg-white p-3">
            ${message}
        </div>
    `;

    // 4. Stacks toast element vertically into container
    container.appendChild(toastEl);

    // 5. Initialize & display Bootstrap Toast
    const bsToast = new bootstrap.Toast(toastEl);
    bsToast.show();

    // 6. Hook hide event to clean DOM and prevent heap memory leaks
    toastEl.addEventListener('hidden.bs.toast', () => {
        toastEl.remove();
    });
}
