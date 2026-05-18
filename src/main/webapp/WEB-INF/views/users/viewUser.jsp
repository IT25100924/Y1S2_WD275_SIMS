<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | User" />
    <jsp:param name="activeMenu" value="users" />
</jsp:include>

<style>
    .detail-hero {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin: 20px 0 28px;
        gap: 20px;
    }
    .detail-hero h2 {
        font-size: 26px;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 6px;
    }
    .detail-hero .hero-notes {
        color: var(--text-muted);
        font-size: 14px;
        margin-bottom: 14px;
        max-width: 620px;
    }
    .detail-hero .hero-meta,
    .detail-hero .actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    .badge-pill {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 5px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.4px;
        text-transform: uppercase;
    }
    .badge-admin { background: #fee2e2; color: #b91c1c; }
    .badge-staff { background: var(--info-bg); color: var(--info); }
    .badge-active { background: var(--success-bg); color: var(--success); }
    .badge-inactive { background: var(--warning-bg); color: var(--warning); }
    .info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
        margin-bottom: 32px;
    }
    .info-card {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 16px;
        padding: 28px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.02);
    }
    .info-card h3 {
        font-size: 16px;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .info-card h3 i {
        color: var(--primary);
        font-size: 20px;
    }
    .detail-row {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 20px;
        padding: 12px 0;
        border-bottom: 1px solid var(--border-color);
    }
    .detail-row:last-child { border-bottom: none; }
    .detail-label {
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: var(--text-muted);
        min-width: 120px;
    }
    .detail-value {
        font-size: 14px;
        font-weight: 500;
        color: var(--text-main);
        text-align: right;
    }
    @media (max-width: 768px) {
        .detail-hero { flex-direction: column; }
        .info-grid { grid-template-columns: 1fr; }
    }
</style>

<div class="detail-hero">
    <div class="hero-content">
        <h2>${user.firstName} ${user.lastName} <span style="font-size: 16px; color: var(--text-muted); font-weight: normal;">#${user.id}</span></h2>
        <p class="hero-notes">${user.email}</p>
        <div class="hero-meta">
            <span class="badge-pill ${user.role eq 'ADMIN' ? 'badge-admin' : 'badge-staff'}">
                <i class="ph ph-shield-check"></i> ${user.role}
            </span>
            <span class="badge-pill ${user.active ? 'badge-active' : 'badge-inactive'}">
                <i class="ph ${user.active ? 'ph-check-circle' : 'ph-warning-circle'}"></i>
                ${user.active ? 'Active' : 'Inactive'}
            </span>
        </div>
    </div>
    <div class="actions">
        <a class="button button-secondary" href="/users">Back to users</a>
        <a class="button button-primary" href="/users/edit/${user.id}">Edit user</a>
    </div>
</div>

<div class="info-grid">
    <div class="info-card">
        <h3><i class="ph ph-address-book"></i> Contact Information</h3>
        <div class="detail-row">
            <span class="detail-label">Full Name</span>
            <span class="detail-value">${user.firstName} ${user.lastName}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Email Address</span>
            <span class="detail-value">${user.email}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Phone Number</span>
            <span class="detail-value">${user.phone != null && !user.phone.isBlank() ? user.phone : '-'}</span>
        </div>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-lock-key"></i> System Access</h3>
        <div class="detail-row">
            <span class="detail-label">System ID</span>
            <span class="detail-value">${user.id}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Role Level</span>
            <span class="detail-value">${user.role}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Account Status</span>
            <span class="detail-value">${user.active ? 'Active' : 'Disabled'}</span>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
