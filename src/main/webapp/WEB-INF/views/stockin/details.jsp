<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.stockin.StockIn stockIn =
            (com.inventory.sims.stockin.StockIn) request.getAttribute("stockIn");
    String productType = stockIn.getProductType();
    if (productType == null || productType.isBlank() || "General".equalsIgnoreCase(productType)) {
        productType = "Standard";
    }
    String note = stockIn.getNote() == null || stockIn.getNote().isBlank() ? "-" : stockIn.getNote();
    String typeBadgeClass = "badge-standard";
    if ("Food".equalsIgnoreCase(productType)) {
        typeBadgeClass = "badge-food";
    } else if ("Electronics".equalsIgnoreCase(productType)) {
        typeBadgeClass = "badge-electronics";
    }
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Stock In" />
    <jsp:param name="activeMenu" value="stockin" />
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
    .badge-stock-in { background: var(--success-bg); color: var(--success); }
    .badge-date { background: var(--warning-bg); color: var(--warning); }
    .badge-standard { background: var(--info-bg); color: var(--info); }
    .badge-electronics { background: #f3e8ff; color: #7e22ce; }
    .badge-food { background: #dcfce7; color: #166534; }
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
    .money-cell {
        font-weight: 600;
        font-variant-numeric: tabular-nums;
    }
    @media (max-width: 768px) {
        .detail-hero { flex-direction: column; }
        .info-grid { grid-template-columns: 1fr; }
    }
</style>

<div class="detail-hero">
    <div class="hero-content">
        <h2><%= stockIn.getProductName() %> <span style="font-size: 16px; color: var(--text-muted); font-weight: normal;">#<%= stockIn.getId() %></span></h2>
        <p class="hero-notes"><%= note %></p>
        <div class="hero-meta">
            <span class="badge-pill badge-stock-in"><i class="ph ph-arrow-circle-down"></i> Stock In</span>
            <span class="badge-pill <%= typeBadgeClass %>"><i class="ph ph-tag"></i> <%= productType %></span>
            <span class="badge-pill badge-date"><i class="ph ph-calendar"></i> <%= stockIn.getReceivedDate() %></span>
        </div>
    </div>
    <div class="actions">
        <a class="button button-secondary" href="/stockin">Back to records</a>
        <a class="button button-primary" href="/stockin/edit/<%= stockIn.getId() %>">Edit record</a>
    </div>
</div>

<div class="info-grid">
    <div class="info-card">
        <h3><i class="ph ph-arrow-circle-down"></i> Stock Movement</h3>
        <div class="detail-row">
            <span class="detail-label">Stock In ID</span>
            <span class="detail-value"><%= stockIn.getId() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Received Date</span>
            <span class="detail-value"><%= stockIn.getReceivedDate() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Supplier</span>
            <span class="detail-value"><%= stockIn.getSupplierName() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Quantity In</span>
            <span class="detail-value" style="font-weight: 700; color: var(--success);"><%= stockIn.getQuantity() %> units</span>
        </div>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-package"></i> Product Information</h3>
        <div class="detail-row">
            <span class="detail-label">Product ID</span>
            <span class="detail-value"><%= stockIn.getProductId() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Product Name</span>
            <span class="detail-value"><%= stockIn.getProductName() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Product Type</span>
            <span class="detail-value"><%= productType %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Type Details</span>
            <span class="detail-value"><%= stockIn.getSpecialDetails() %></span>
        </div>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-currency-circle-dollar"></i> Cost Details</h3>
        <div class="detail-row">
            <span class="detail-label">Unit Cost</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", stockIn.getUnitCost()) %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Total Cost</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", stockIn.getTotalCost()) %></span>
        </div>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-note"></i> Record Note</h3>
        <div class="detail-row" style="border-bottom: none;">
            <span class="detail-label">Note</span>
            <span class="detail-value"><%= note %></span>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
