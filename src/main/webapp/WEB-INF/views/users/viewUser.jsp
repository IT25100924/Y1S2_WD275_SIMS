<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | User" />
    <jsp:param name="activeMenu" value="users" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>User Profile</h1>
                <p>Review user account details and access permissions.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/users">Back to users</a>
                <a class="button button-primary" href="/users/edit/${user.id}">Edit user</a>
            </div>
        </header>
        <section class="hero">
            <h2>${user.firstName} ${user.lastName}</h2>
            <p>${user.email}</p>
            <div class="hero-meta">
                <span class="badge ${user.active ? 'badge-active' : 'badge-inactive'}">${user.active ? 'Active' : 'Inactive'}</span>
                <span class="badge badge-warning" style="background-color: var(--info-bg); color: var(--info);">${user.role}</span>
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
