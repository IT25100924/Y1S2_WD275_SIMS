<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | User" />
    <jsp:param name="activeMenu" value="users" />
</jsp:include>

<style>
    .hero {
        background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%) !important;
        border-radius: 20px !important;
        border: none !important;
        padding: 40px !important;
        margin-bottom: 24px !important;
        box-shadow: 0 8px 30px rgba(79, 70, 229, 0.1) !important;
    }
    .hero h2 {
        color: #1e1b4b !important;
        font-size: 32px !important;
        font-weight: 800 !important;
        margin-bottom: 8px !important;
    }
    .hero p {
        color: #4338ca !important;
        font-size: 16px !important;
        margin-bottom: 16px !important;
    }
    .hero .badge {
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
    }
    
    .card {
        border-radius: 20px !important;
        border: none !important;
        padding: 32px !important;
        transition: transform 0.2s ease, box-shadow 0.2s ease !important;
    }
    .card:hover {
        transform: translateY(-2px);
    }
    
    .card:nth-child(1) {
        background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%) !important;
        box-shadow: 0 8px 30px rgba(2, 132, 199, 0.1) !important;
    }
    .card:nth-child(1) h3 { color: #075985 !important; font-size: 20px !important; font-weight: 700 !important; margin-bottom: 24px !important; }
    .card:nth-child(1) .detail-item span { color: #0284c7 !important; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; }
    .card:nth-child(1) .detail-item strong { color: #0c4a6e !important; font-size: 16px; font-weight: 600; display: block; margin-top: 4px; }
    
    .card:nth-child(2) {
        background: linear-gradient(135deg, #fae8ff 0%, #f5d0fe 100%) !important;
        box-shadow: 0 8px 30px rgba(192, 38, 211, 0.1) !important;
    }
    .card:nth-child(2) h3 { color: #701a75 !important; font-size: 20px !important; font-weight: 700 !important; margin-bottom: 24px !important; }
    .card:nth-child(2) .detail-item span { color: #c026d3 !important; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; }
    .card:nth-child(2) .detail-item strong { color: #4a044e !important; font-size: 16px; font-weight: 600; display: block; margin-top: 4px; }

    .detail-item {
        margin-bottom: 16px;
        background: rgba(255, 255, 255, 0.5);
        padding: 16px;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.8);
        backdrop-filter: blur(8px);
    }
    .detail-item:last-child {
        margin-bottom: 0;
    }
</style>

        <section class="hero">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; width: 100%;">
                <div>
                    <h2>${user.firstName} ${user.lastName}</h2>
                    <p>${user.email}</p>
                    <div class="hero-meta">
                        <span class="badge ${user.active ? 'badge-active' : 'badge-inactive'}">${user.active ? 'Active' : 'Inactive'}</span>
                        <span class="badge badge-warning" style="background-color: var(--info-bg); color: var(--info);">${user.role}</span>
                    </div>
                </div>
                <div class="actions">
                    <a class="button button-secondary" href="/users">Back to users</a>
                    <a class="button button-primary" href="/users/edit/${user.id}">Edit user</a>
                </div>
            </div>
        </section>
        <section class="grid" aria-label="User details">
            <article class="card">
                <h3>Contact Information</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Full Name</span><strong>${user.firstName} ${user.lastName}</strong></div>
                    <div class="detail-item"><span>Email address</span><strong>${user.email}</strong></div>
                    <div class="detail-item"><span>Phone number</span><strong>${user.phone != null && !user.phone.isBlank() ? user.phone : '-'}</strong></div>
                </div>
            </article>
            <article class="card">
                <h3>System Access</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>System ID</span><strong>${user.id}</strong></div>
                    <div class="detail-item"><span>Role Level</span><strong>${user.role}</strong></div>
                    <div class="detail-item"><span>Account Status</span><strong>${user.active ? 'Active' : 'Disabled'}</strong></div>
                </div>
            </article>
        </section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
