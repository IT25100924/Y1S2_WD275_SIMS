<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Customer" />
    <jsp:param name="activeMenu" value="customers" />
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
    .badge-customer { background: var(--info-bg); color: var(--info); }
    .badge-active { background: var(--success-bg); color: var(--success); }
    .info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
        margin-bottom: 32px;
    }
    .info-card,
    .records-card {
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
    .records-card {
        margin-bottom: 24px;
    }
    .records-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 24px;
        flex-wrap: wrap;
        gap: 16px;
    }
    .records-header-left h3 {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 4px;
    }
    .records-header-left h3 i {
        color: var(--warning);
        font-size: 22px;
    }
    .records-header-left p {
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
    .summary-chip.value i { color: var(--success); }
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
    .stock-table tbody tr:last-child td { border-bottom: none; }
    .stock-table tbody tr:hover { background: rgba(99, 102, 241, 0.03); }
    .stock-id-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 6px;
        background: var(--warning-bg);
        color: var(--warning);
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
        .detail-hero { flex-direction: column; }
        .info-grid { grid-template-columns: 1fr; }
        .records-header { flex-direction: column; }
    }
</style>

<%
    java.util.List<com.inventory.sims.stockout.StockOut> stockOutRecords =
            (java.util.List<com.inventory.sims.stockout.StockOut>) request.getAttribute("stockOutRecords");
    int stockOutCount = stockOutRecords == null ? 0 : stockOutRecords.size();
    int totalQuantity = 0;
    double totalValue = 0;
    if (stockOutRecords != null) {
        for (com.inventory.sims.stockout.StockOut stockOut : stockOutRecords) {
            totalQuantity += stockOut.getQuantity();
            totalValue += stockOut.getTotalPrice();
        }
    }
%>

<div class="detail-hero">
    <div class="hero-content">
        <h2>${customer.name} <span style="font-size: 16px; color: var(--text-muted); font-weight: normal;">#${customer.id}</span></h2>
        <p class="hero-notes">${customer.address}</p>
        <div class="hero-meta">
            <span class="badge-pill badge-customer"><i class="ph ph-user"></i> Customer</span>
            <span class="badge-pill badge-active"><i class="ph ph-receipt"></i> <%= stockOutCount %> stockout record<%= stockOutCount == 1 ? "" : "s" %></span>
        </div>
    </div>
    <div class="actions">
        <a class="button button-secondary" href="/customers">Back to customers</a>
        <a class="button button-primary" href="/customers/edit/${customer.id}">Edit customer</a>
    </div>
</div>

<div class="info-grid">
    <div class="info-card">
        <h3><i class="ph ph-address-book"></i> Contact Information</h3>
        <div class="detail-row">
            <span class="detail-label">Customer Name</span>
            <span class="detail-value">${customer.name}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Email Address</span>
            <span class="detail-value">${customer.email}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Phone Number</span>
            <span class="detail-value">${customer.phone}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Address</span>
            <span class="detail-value">${customer.address}</span>
        </div>
    </div>
    <div class="info-card">
        <h3><i class="ph ph-identification-card"></i> Customer Information</h3>
        <div class="detail-row">
            <span class="detail-label">Customer ID</span>
            <span class="detail-value">${customer.id}</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Total Records</span>
            <span class="detail-value"><%= stockOutCount %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Quantity Issued</span>
            <span class="detail-value"><%= totalQuantity %> units</span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Total Value</span>
            <span class="detail-value money-cell">LKR <%= String.format("%.2f", totalValue) %></span>
        </div>
    </div>
</div>

<div class="records-card" aria-label="Customer stockout records">
    <div class="records-header">
        <div class="records-header-left">
            <h3><i class="ph ph-arrow-circle-up"></i> Stock Out Records</h3>
            <p>Outgoing stock issued to this customer.</p>
        </div>
        <div class="summary-chips">
            <div class="summary-chip records">
                <i class="ph ph-list-dashes"></i>
                Records <strong><%= stockOutCount %></strong>
            </div>
            <div class="summary-chip quantity">
                <i class="ph ph-cube"></i>
                Quantity <strong><%= totalQuantity %></strong>
            </div>
            <div class="summary-chip value">
                <i class="ph ph-currency-circle-dollar"></i>
                Value <strong>LKR <%= String.format("%.2f", totalValue) %></strong>
            </div>
        </div>
    </div>
    <div class="stock-table-wrap">
        <table class="stock-table">
            <thead>
            <tr>
                <th>Stockout ID</th>
                <th>Date</th>
                <th>Product</th>
                <th>Quantity</th>
                <th>Unit Price (LKR)</th>
                <th>Total Price (LKR)</th>
                <th>Reason</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (stockOutRecords != null && !stockOutRecords.isEmpty()) {
                    for (com.inventory.sims.stockout.StockOut stockOut : stockOutRecords) {
            %>
            <tr>
                <td><span class="stock-id-badge"><%= stockOut.getId() %></span></td>
                <td><%= stockOut.getStockOutDate() == null ? "-" : stockOut.getStockOutDate() %></td>
                <td>
                    <strong><%= stockOut.getProductName() %></strong>
                    <div style="font-size: 12px; color: var(--text-muted);"><%= stockOut.getProductId() %></div>
                </td>
                <td><%= stockOut.getQuantity() %></td>
                <td class="money-cell">LKR <%= String.format("%.2f", stockOut.getUnitPrice()) %></td>
                <td class="money-cell">LKR <%= String.format("%.2f", stockOut.getTotalPrice()) %></td>
                <td><%= stockOut.getReason() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="7" class="empty-row-cell">
                    <i class="ph ph-archive" style="font-size:32px;display:block;margin-bottom:8px;opacity:0.3;"></i>
                    No stockout records found for this customer.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
