<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Products" />
    <jsp:param name="activeMenu" value="products" />
</jsp:include>

<style>
    /* ── Page Header Override ── */
    .product-hero {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 28px;
        margin-top: 20px;
    }
    .product-hero .hero-content {
        display: flex;
        flex-direction: column;
    }
    .product-hero h2 {
        font-size: 26px;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 6px;
    }
    .product-hero .hero-notes {
        color: var(--text-muted);
        font-size: 14px;
        margin-bottom: 14px;
        max-width: 600px;
    }
    .product-hero .hero-meta {
        display: flex;
        gap: 10px;
    }
    .product-hero .actions {
        display: flex;
        gap: 12px;
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
    .badge-general { background: #e0f2fe; color: #0284c7; }
    .badge-electronics { background: #f3e8ff; color: #7e22ce; }
    .badge-food { background: #dcfce7; color: #166534; }
    .badge-low-stock { background: var(--error-bg); color: var(--error); }
    .badge-ok-stock { background: var(--success-bg); color: var(--success); }

    /* ── Info Cards Grid ── */
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

    /* ── Stock Records Section ── */
    .stock-records-card {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 16px;
        padding: 28px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.02);
        margin-bottom: 24px;
    }
    .stock-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 24px;
        flex-wrap: wrap;
        gap: 16px;
    }
    .stock-header-left h3 {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 4px;
    }
    .stock-header-left.stock-in h3 i { color: var(--success); }
    .stock-header-left.stock-out h3 i { color: var(--warning); }
    .stock-header-left p {
        font-size: 13px;
        color: var(--text-muted);
    }
    .summary-chips {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    .summary-chip {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        border-radius: 12px;
        background: var(--bg-main);
        border: 1px solid var(--border-color);
        font-size: 13px;
        color: var(--text-muted);
    }
    .summary-chip strong {
        font-weight: 700;
        color: var(--text-main);
        font-size: 15px;
    }
    .summary-chip i { font-size: 18px; }
    .summary-chip.records i { color: var(--info); }
    .summary-chip.quantity i { color: var(--primary); }
    .summary-chip.cost i { color: var(--success); }

    /* ── Stock Table ── */
    .stock-table-wrap {
        overflow-x: auto;
        border-radius: 12px;
        border: 1px solid var(--border-color);
    }
    .stock-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }
    .stock-table thead {
        background: var(--bg-main);
    }
    .stock-table th {
        padding: 14px 18px;
        text-align: left;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: var(--text-muted);
        border-bottom: 1px solid var(--border-color);
    }
    .stock-table td {
        padding: 14px 18px;
        border-bottom: 1px solid var(--border-color);
        color: var(--text-main);
        vertical-align: middle;
    }
    .stock-table tbody tr:last-child td {
        border-bottom: none;
    }
    .stock-table tbody tr {
        transition: background 0.15s ease;
    }
    .stock-table tbody tr:hover {
        background: rgba(99, 102, 241, 0.03);
    }
    .stock-id-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 6px;
        background: var(--info-bg);
        color: var(--info);
        font-weight: 600;
        font-size: 12px;
    }
    .money-cell {
        font-weight: 600;
        font-variant-numeric: tabular-nums;
    }
    .empty-row-cell {
        text-align: center;
        padding: 40px 18px !important;
        color: var(--text-muted);
        font-size: 14px;
    }

    @media (max-width: 768px) {
        .info-grid { grid-template-columns: 1fr; }
        .stock-header { flex-direction: column; }
    }
</style>

<%
    com.inventory.sims.product.Product p = (com.inventory.sims.product.Product) request.getAttribute("product");
    com.inventory.sims.supplier.Supplier supplier = (com.inventory.sims.supplier.Supplier) request.getAttribute("supplier");
    
    String typeStr = p.getClass().getSimpleName();
    String badgeClass = "badge-general";
    String extraLabel = "";
    String extraValue = "";
    
    if (p instanceof com.inventory.sims.product.ElectronicsProduct) {
        badgeClass = "badge-electronics";
        extraLabel = "Warranty (Months)";
        extraValue = String.valueOf(((com.inventory.sims.product.ElectronicsProduct) p).getWarrantyMonths());
    } else if (p instanceof com.inventory.sims.product.FoodProduct) {
        badgeClass = "badge-food";
        extraLabel = "Expiration Date";
        extraValue = ((com.inventory.sims.product.FoodProduct) p).getExpirationDate();
        if (extraValue == null || extraValue.isEmpty()) extraValue = "N/A";
    }

    boolean isLowStock = p.getQuantity() <= 5;
%>

<div class="product-hero">
    <div class="hero-content">
        <h2><%= p.getName() %> <span style="font-size: 16px; color: var(--text-muted); font-weight: normal;">#<%= p.getId() %></span></h2>
        <p class="hero-notes">Comprehensive details and inventory history for this product.</p>
        <div class="hero-meta">
            <span class="badge-pill <%= badgeClass %>">
                <i class="ph ph-tag"></i> <%= typeStr %>
            </span>
            <span class="badge-pill <%= isLowStock ? "badge-low-stock" : "badge-ok-stock" %>">
                <i class="ph <%= isLowStock ? "ph-warning-circle" : "ph-check-circle" %>"></i> 
                Stock: <%= p.getQuantity() %>
            </span>
        </div>
    </div>
    <div class="actions">
        <a class="button button-secondary" href="/products">Back to products</a>
        <a class="button button-primary" href="/products/edit/<%= p.getId() %>">Edit product</a>
    </div>
</div>

<!-- Info Grid -->
<div class="info-grid">
    <div class="info-card">
        <h3><i class="ph ph-info"></i> Product Information</h3>
        <div class="detail-row">
            <span class="detail-label">Product Name</span>
            <span class="detail-value"><%= p.getName() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Current Stock</span>
            <span class="detail-value" style="font-weight: 700; color: <%= isLowStock ? "var(--error)" : "var(--text-main)" %>"><%= p.getQuantity() %> Units</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">MRP (Default Sell)</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", p.getMrp()) %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Default Stock-In</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", p.getDefaultStockInPrice()) %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Default Stock-Out</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", p.getDefaultStockOutPrice()) %></span>
        </div>
        <% if (!extraLabel.isEmpty()) { %>
        <div class="detail-row">
            <span class="detail-label"><%= extraLabel %></span>
            <span class="detail-value"><%= extraValue %></span>
        </div>
        <% } %>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-truck"></i> Supplier Details</h3>
        <% if (supplier != null) { %>
        <div class="detail-row">
            <span class="detail-label">Company Name</span>
            <span class="detail-value"><a href="/suppliers/details/<%= supplier.getId() %>" style="color: var(--primary); text-decoration: none; font-weight: 600;"><%= supplier.getCompanyName() %></a></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Contact Person</span>
            <span class="detail-value"><%= supplier.getContactPerson() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Phone Number</span>
            <span class="detail-value"><%= supplier.getPhone() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Email Address</span>
            <span class="detail-value"><%= supplier.getEmail() %></span>
        </div>
        <% } else { %>
        <div class="detail-row" style="border: none; justify-content: center; padding: 20px 0;">
            <span class="detail-value" style="color: var(--text-muted);">Supplier details not found.</span>
        </div>
        <% } %>
    </div>
</div>

<!-- Stock In Records -->
<%
    java.util.List<com.inventory.sims.stockin.StockIn> stockIns = (java.util.List<com.inventory.sims.stockin.StockIn>) request.getAttribute("stockIns");
    int totalStockInRecords = stockIns == null ? 0 : stockIns.size();
    int totalStockInQuantity = 0;
    double totalStockInCost = 0;
    if (stockIns != null) {
        for (com.inventory.sims.stockin.StockIn stockIn : stockIns) {
            totalStockInQuantity += stockIn.getQuantity();
            totalStockInCost += stockIn.getTotalCost();
        }
    }
%>
<div class="stock-records-card">
    <div class="stock-header">
        <div class="stock-header-left stock-in">
            <h3><i class="ph ph-arrow-circle-down"></i> Stock In History</h3>
            <p>Historical record of units received.</p>
        </div>
        <div class="summary-chips">
            <div class="summary-chip records">
                <i class="ph ph-list-dashes"></i>
                Records <strong><%= totalStockInRecords %></strong>
            </div>
            <div class="summary-chip quantity">
                <i class="ph ph-cube"></i>
                Quantity <strong><%= totalStockInQuantity %></strong>
            </div>
            <div class="summary-chip cost">
                <i class="ph ph-currency-circle-dollar"></i>
                Cost <strong>LKR <%= String.format("%.2f", totalStockInCost) %></strong>
            </div>
        </div>
    </div>
    <div class="stock-table-wrap">
        <table class="stock-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Date</th>
                <th>Supplier</th>
                <th>Quantity</th>
                <th>Unit Cost (LKR)</th>
                <th>Total Cost (LKR)</th>
            </tr>
            </thead>
            <tbody>
            <% if (stockIns != null && !stockIns.isEmpty()) {
                for (com.inventory.sims.stockin.StockIn stockIn : stockIns) { %>
            <tr>
                <td><span class="stock-id-badge"><%= stockIn.getId() %></span></td>
                <td><%= stockIn.getReceivedDate() %></td>
                <td><%= stockIn.getSupplierName() %></td>
                <td><%= stockIn.getQuantity() %></td>
                <td class="money-cell"><%= String.format("%.2f", stockIn.getUnitCost()) %></td>
                <td class="money-cell"><%= String.format("%.2f", stockIn.getTotalCost()) %></td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="6" class="empty-row-cell">
                    <i class="ph ph-archive" style="font-size:32px;display:block;margin-bottom:8px;opacity:0.3;"></i>
                    No stock-in history found for this product.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Stock Out Records -->
<%
    java.util.List<com.inventory.sims.stockout.StockOut> stockOuts = (java.util.List<com.inventory.sims.stockout.StockOut>) request.getAttribute("stockOuts");
    int totalStockOutRecords = stockOuts == null ? 0 : stockOuts.size();
    int totalStockOutQuantity = 0;
    double totalStockOutRevenue = 0;
    if (stockOuts != null) {
        for (com.inventory.sims.stockout.StockOut stockOut : stockOuts) {
            totalStockOutQuantity += stockOut.getQuantity();
            totalStockOutRevenue += stockOut.getTotalPrice();
        }
    }
%>
<div class="stock-records-card">
    <div class="stock-header">
        <div class="stock-header-left stock-out">
            <h3><i class="ph ph-arrow-circle-up"></i> Stock Out History</h3>
            <p>Historical record of units sold or issued.</p>
        </div>
        <div class="summary-chips">
            <div class="summary-chip records">
                <i class="ph ph-list-dashes"></i>
                Records <strong><%= totalStockOutRecords %></strong>
            </div>
            <div class="summary-chip quantity">
                <i class="ph ph-cube"></i>
                Quantity <strong><%= totalStockOutQuantity %></strong>
            </div>
            <div class="summary-chip cost">
                <i class="ph ph-currency-circle-dollar"></i>
                Revenue <strong>LKR <%= String.format("%.2f", totalStockOutRevenue) %></strong>
            </div>
        </div>
    </div>
    <div class="stock-table-wrap">
        <table class="stock-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Date</th>
                <th>Issued To</th>
                <th>Reason</th>
                <th>Quantity</th>
                <th>Unit Price (LKR)</th>
                <th>Total Price (LKR)</th>
            </tr>
            </thead>
            <tbody>
            <% if (stockOuts != null && !stockOuts.isEmpty()) {
                for (com.inventory.sims.stockout.StockOut stockOut : stockOuts) { %>
            <tr>
                <td><span class="stock-id-badge" style="background: var(--warning-bg); color: var(--warning);"><%= stockOut.getId() %></span></td>
                <td><%= stockOut.getStockOutDate() %></td>
                <td><%= stockOut.getIssuedTo() %></td>
                <td><%= stockOut.getReason() %></td>
                <td><%= stockOut.getQuantity() %></td>
                <td class="money-cell"><%= String.format("%.2f", stockOut.getUnitPrice()) %></td>
                <td class="money-cell"><%= String.format("%.2f", stockOut.getTotalPrice()) %></td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="7" class="empty-row-cell">
                    <i class="ph ph-archive" style="font-size:32px;display:block;margin-bottom:8px;opacity:0.3;"></i>
                    No stock-out history found for this product.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
