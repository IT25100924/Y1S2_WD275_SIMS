<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.stockout.StockOut stockOut =
            (com.inventory.sims.stockout.StockOut) request.getAttribute("stockOut");
    com.inventory.sims.product.Product product =
            (com.inventory.sims.product.Product) request.getAttribute("product");

    String note = stockOut.getNote() == null || stockOut.getNote().isBlank() ? "-" : stockOut.getNote();
    String productType = "Standard";
    String productDetails = "-";
    String badgeClass = "badge-standard";

    if (product instanceof com.inventory.sims.product.FoodProduct) {
        productType = "Food";
        badgeClass = "badge-food";
        String expirationDate = ((com.inventory.sims.product.FoodProduct) product).getExpirationDate();
        productDetails = expirationDate == null || expirationDate.isBlank() ? "Expiration date not set" : "Expires on " + expirationDate;
    } else if (product instanceof com.inventory.sims.product.ElectronicsProduct) {
        productType = "Electronics";
        badgeClass = "badge-electronics";
        productDetails = ((com.inventory.sims.product.ElectronicsProduct) product).getWarrantyMonths() + " months warranty";
    } else if (product == null) {
        productDetails = "Product record not found";
    }
    double totalValue = stockOut.getQuantity() * stockOut.getUnitPrice();
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Stock Out" />
    <jsp:param name="activeMenu" value="stockout" />
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
    .badge-stock-out { background: var(--warning-bg); color: var(--warning); }
    .badge-date { background: var(--info-bg); color: var(--info); }
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
        <h2><%= stockOut.getProductName() %> <span style="font-size: 16px; color: var(--text-muted); font-weight: normal;">#<%= stockOut.getId() %></span></h2>
        <p class="hero-notes"><%= note %></p>
        <div class="hero-meta">
            <span class="badge-pill badge-stock-out"><i class="ph ph-arrow-circle-up"></i> Stock Out</span>
            <span class="badge-pill <%= badgeClass %>"><i class="ph ph-tag"></i> <%= productType %></span>
            <span class="badge-pill badge-date"><i class="ph ph-calendar"></i> <%= stockOut.getStockOutDate() == null ? "-" : stockOut.getStockOutDate() %></span>
        </div>
    </div>
    <div class="actions">
        <a class="button button-secondary" href="/stockout">Back to records</a>
        <a class="button button-primary" href="/stockout/update/<%= stockOut.getId() %>">Edit record</a>
    </div>
</div>

<div class="info-grid">
    <div class="info-card">
        <h3><i class="ph ph-arrow-circle-up"></i> Stock Movement</h3>
        <div class="detail-row">
            <span class="detail-label">Stock Out ID</span>
            <span class="detail-value"><%= stockOut.getId() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Stock Out Date</span>
            <span class="detail-value"><%= stockOut.getStockOutDate() == null ? "-" : stockOut.getStockOutDate() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Issued To</span>
            <span class="detail-value"><%= stockOut.getIssuedTo() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Reason</span>
            <span class="detail-value"><%= stockOut.getReason() %></span>
        </div>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-package"></i> Product Information</h3>
        <div class="detail-row">
            <span class="detail-label">Product ID</span>
            <span class="detail-value"><%= stockOut.getProductId() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Product Name</span>
            <span class="detail-value"><%= stockOut.getProductName() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Product Type</span>
            <span class="detail-value"><%= productType %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Product Details</span>
            <span class="detail-value"><%= productDetails %></span>
        </div>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-currency-circle-dollar"></i> Value Details</h3>
        <div class="detail-row">
            <span class="detail-label">Quantity Out</span>
            <span class="detail-value" style="font-weight: 700; color: var(--warning);"><%= stockOut.getQuantity() %> units</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Unit Price</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", stockOut.getUnitPrice()) %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Total Value</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", totalValue) %></span>
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
