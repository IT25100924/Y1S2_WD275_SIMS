<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.sims.user.User" %>
<%!
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }
        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<%
    User dashboardUser = (User) session.getAttribute("loggedUser");
    String dashboardFirstName = dashboardUser == null || dashboardUser.getFirstName() == null
            || dashboardUser.getFirstName().isBlank()
            ? "Admin"
            : dashboardUser.getFirstName();
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard" />
    <jsp:param name="activeMenu" value="dashboard" />
</jsp:include>

<style>
    .welcome-banner {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
        padding: 32px 40px;
        border-radius: 20px;
        margin-bottom: 32px;
        border: 1px solid var(--border-color);
        gap: 20px;
        flex-wrap: wrap;
    }
    .welcome-text {
        flex: 1;
        min-width: 300px;
    }
    .welcome-text h1 {
        font-size: 28px;
        color: var(--text-main);
        margin-bottom: 8px;
    }
    .welcome-text h1 span { color: var(--primary); }
    .welcome-text p { color: var(--text-muted); font-size: 15px; }

    .welcome-actions {
        display: flex;
        gap: 12px;
        align-items: center;
        flex-wrap: wrap;
    }
    .btn-dashboard-action {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 11px 20px;
        color: white;
        border-radius: 12px;
        font-weight: 600;
        font-size: 14px;
        text-decoration: none;
        transition: all 0.2s ease;
    }
    .btn-dashboard-action:hover {
        transform: translateY(-2px);
        filter: brightness(0.95);
    }
    .btn-dashboard-action.btn-purple {
        background-color: var(--primary);
        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
    }
    .btn-dashboard-action.btn-purple:hover {
        box-shadow: 0 6px 16px rgba(99, 102, 241, 0.3);
    }
    .btn-dashboard-action.btn-cyan {
        background-color: var(--secondary);
        box-shadow: 0 4px 12px rgba(6, 182, 212, 0.2);
    }
    .btn-dashboard-action.btn-cyan:hover {
        box-shadow: 0 6px 16px rgba(6, 182, 212, 0.3);
    }
    .btn-dashboard-action.btn-orange {
        background-color: var(--tertiary);
        box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);
    }
    .btn-dashboard-action.btn-orange:hover {
        box-shadow: 0 6px 16px rgba(245, 158, 11, 0.3);
    }
    .btn-dashboard-action.btn-blue {
        background-color: var(--info);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);
    }
    .btn-dashboard-action.btn-blue:hover {
        box-shadow: 0 6px 16px rgba(59, 130, 246, 0.3);
    }
    .btn-dashboard-action i {
        font-size: 18px;
    }
    
    .metrics-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 24px;
        margin-bottom: 32px;
    }
    .metric-card {
        border-radius: 20px;
        padding: 24px;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        border: none;
    }
    .metric-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.04);
    }
    .metric-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 24px;
    }
    .metric-icon {
        width: 48px;
        height: 48px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
    }
    
    .metric-card.card-purple { background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); }
    .metric-card.card-purple .metric-icon { background-color: #a5b4fc; color: #4338ca; }
    .metric-card.card-purple .metric-badge { background-color: #bfdbfe; color: #1d4ed8; }

    .metric-card.card-red { background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); }
    .metric-card.card-red .metric-icon { background-color: #fca5a5; color: #b91c1c; }
    .metric-card.card-red .metric-badge { background-color: #fca5a5; color: #b91c1c; }

    .metric-card.card-blue { background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%); }
    .metric-card.card-blue .metric-icon { background-color: #7dd3fc; color: #0369a1; }
    .metric-card.card-blue .metric-badge { background-color: transparent; color: #334155; padding: 0; }

    .metric-card.card-orange { background: linear-gradient(135deg, #ffedd5 0%, #fed7aa 100%); }
    .metric-card.card-orange .metric-icon { background-color: #fdba74; color: #c2410c; }
    .metric-card.card-orange .metric-badge { background-color: transparent; color: #334155; padding: 0; }

    .metric-badge {
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 4px;
    }
    
    .metric-card h3 {
        font-size: 15px;
        color: #475569;
        font-weight: 600;
        margin-bottom: 8px;
    }
    .metric-card .value {
        font-size: 36px;
        font-weight: 800;
        color: #0f172a;
    }

    /* Bottom Grid - Two equal cards */
    .bottom-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
    }
    .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    .card-header h2 {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
    }

    /* Activity List */
    .view-all {
        color: var(--primary);
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
    }
    .view-all:hover { text-decoration: underline; }
    .activity-list {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .stockin-card {
        background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
        border: none;
        border-radius: 20px;
        padding: 24px;
        box-shadow: 0 8px 30px rgba(16, 185, 129, 0.05);
    }
    .stockin-card .card-header h2 { color: #065f46; }
    .stockin-card .view-all { color: #059669; }
    .stockin-card .activity-item {
        background: rgba(255, 255, 255, 0.5);
        border: 1px solid rgba(255, 255, 255, 0.8);
        backdrop-filter: blur(8px);
    }
    .stockin-card .activity-item:hover {
        background: rgba(255, 255, 255, 0.9);
        box-shadow: 0 4px 16px rgba(16, 185, 129, 0.1);
    }
    .stockin-card .activity-icon.green {
        background: linear-gradient(135deg, #a7f3d0 0%, #34d399 100%);
        color: #064e3b;
    }

    .stockout-card {
        background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
        border: none;
        border-radius: 20px;
        padding: 24px;
        box-shadow: 0 8px 30px rgba(245, 158, 11, 0.05);
    }
    .stockout-card .card-header h2 { color: #92400e; }
    .stockout-card .view-all { color: #d97706; }
    .stockout-card .activity-item {
        background: rgba(255, 255, 255, 0.5);
        border: 1px solid rgba(255, 255, 255, 0.8);
        backdrop-filter: blur(8px);
    }
    .stockout-card .activity-item:hover {
        background: rgba(255, 255, 255, 0.9);
        box-shadow: 0 4px 16px rgba(245, 158, 11, 0.1);
    }
    .stockout-card .activity-icon.orange {
        background: linear-gradient(135deg, #fde68a 0%, #fbbf24 100%);
        color: #78350f;
    }

    .activity-item {
        display: flex;
        gap: 14px;
        align-items: center;
        padding: 14px 16px;
        border-radius: 12px;
        background: var(--bg-main);
        border: 1px solid var(--border-color);
        transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
    }
    .activity-item:hover {
        transform: translateX(4px);
    }
    .activity-icon {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        flex-shrink: 0;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }
    .activity-icon.green { background-color: var(--success-bg); color: var(--success); }
    .activity-icon.orange { background-color: var(--warning-bg); color: var(--warning); }
    
    .activity-details p {
        font-size: 14px;
        color: var(--text-main);
        margin-bottom: 2px;
    }
    .activity-details span {
        font-size: 12px;
        color: var(--text-muted);
    }
    .empty-state {
        text-align: center;
        padding: 40px 16px;
        color: var(--text-muted);
        font-size: 14px;
    }
    .empty-state i {
        font-size: 40px;
        display: block;
        margin-bottom: 12px;
        opacity: 0.35;
    }
    @media (max-width: 1024px) {
        .bottom-grid { grid-template-columns: 1fr; }
        .metrics-grid { grid-template-columns: repeat(2, 1fr); }
    }
</style>

        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <div class="welcome-text">
                <h1>Welcome back, <span><%= escapeHtml(dashboardFirstName) %>!</span> 👋</h1>
                <p>Here's what's happening with your inventory today.</p>
            </div>
            <div class="welcome-actions">
                <% if (dashboardUser != null && dashboardUser.getRole() != null && "ADMIN".equals(dashboardUser.getRole().name())) { %>
                <a href="/users/register" class="btn-dashboard-action btn-purple">
                    <i class="ph ph-user-plus"></i> Add User
                </a>
                <% } %>
                <a href="/suppliers/register" class="btn-dashboard-action btn-cyan">
                    <i class="ph ph-truck"></i> Add Supplier
                </a>
                <a href="/products/add" class="btn-dashboard-action btn-orange">
                    <i class="ph ph-plus-circle"></i> Add Product
                </a>
                <a href="/customers/add" class="btn-dashboard-action btn-blue">
                    <i class="ph ph-user-circle-plus"></i> Add Customer
                </a>
            </div>
        </div>

        <!-- Metrics Grid -->
        <div class="metrics-grid">
            <div class="metric-card card-purple">
                <div class="metric-header">
                    <div class="metric-icon"><i class="ph ph-package"></i></div>
                    <span class="metric-badge">+12%</span>
                </div>
                <h3>Total Products</h3>
                <div class="value">${totalProducts}</div>
            </div>
            
            <div class="metric-card card-red">
                <div class="metric-header">
                    <div class="metric-icon"><i class="ph ph-warning"></i></div>
                    <span class="metric-badge"><i class="ph ph-arrow-up"></i> 3</span>
                </div>
                <h3>Low Stock Alerts</h3>
                <div class="value">${lowStockCount}</div>
            </div>

            <div class="metric-card card-blue">
                <div class="metric-header">
                    <div class="metric-icon"><i class="ph ph-arrow-down"></i></div>
                    <span class="metric-badge">This Month</span>
                </div>
                <h3>Monthly Stock-in</h3>
                <div class="value">${monthlyStockIn}</div>
            </div>

            <div class="metric-card card-orange">
                <div class="metric-header">
                    <div class="metric-icon"><i class="ph ph-arrow-up"></i></div>
                    <span class="metric-badge">This Month</span>
                </div>
                <h3>Monthly Stock-out</h3>
                <div class="value">${monthlyStockOut}</div>
            </div>
        </div>

        <!-- Bottom Grid: Recent Stock-in & Stock-out -->
        <div class="bottom-grid">

            <!-- Recent Stock-in Card -->
            <div class="card stockin-card">
                <div class="card-header">
                    <h2><i class="ph ph-arrow-circle-down" style="margin-right:8px;"></i>Recent Stock-in</h2>
                    <a href="/stockin" class="view-all">View All</a>
                </div>
                <div class="activity-list">
                    <%@ page import="com.inventory.sims.stockin.StockIn" %>
                    <%@ page import="java.util.List" %>
                    <%
                        List<StockIn> recentStockIn = (List<StockIn>) request.getAttribute("recentStockIn");
                        if (recentStockIn != null && !recentStockIn.isEmpty()) {
                            for (StockIn si : recentStockIn) {
                    %>
                    <div class="activity-item">
                        <div class="activity-icon green"><i class="ph ph-arrow-square-in"></i></div>
                        <div class="activity-details">
                            <p>Stock in for <strong><%= si.getProductName() %></strong></p>
                            <span><%= si.getReceivedDate() %> &bull; +<%= si.getQuantity() %> units &bull; from <%= si.getSupplierName() %></span>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="empty-state">
                        <i class="ph ph-archive"></i>
                        No recent stock-in records found.
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Recent Stock-out Card -->
            <div class="card stockout-card">
                <div class="card-header">
                    <h2><i class="ph ph-arrow-circle-up" style="margin-right:8px;"></i>Recent Stock-out</h2>
                    <a href="/stockout" class="view-all">View All</a>
                </div>
                <div class="activity-list">
                    <%@ page import="com.inventory.sims.stockout.StockOut" %>
                    <%
                        List<StockOut> recentStockOut = (List<StockOut>) request.getAttribute("recentStockOut");
                        if (recentStockOut != null && !recentStockOut.isEmpty()) {
                            for (StockOut so : recentStockOut) {
                    %>
                    <div class="activity-item">
                        <div class="activity-icon orange"><i class="ph ph-arrow-square-out"></i></div>
                        <div class="activity-details">
                            <p>Stock out for <strong><%= so.getProductName() %></strong></p>
                            <span><%= so.getStockOutDate() %> &bull; -<%= so.getQuantity() %> units</span>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="empty-state">
                        <i class="ph ph-archive"></i>
                        No recent stock-out records found.
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
