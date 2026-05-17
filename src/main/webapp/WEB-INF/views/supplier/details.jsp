<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Supplier" />
    <jsp:param name="activeMenu" value="suppliers" />
</jsp:include>

<style>
    /* ── Page Header Override ── */
    .supplier-hero {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 28px;
        margin-top: 20px;
    }
    .supplier-hero .hero-content {
        display: flex;
        flex-direction: column;
    }
    .supplier-hero h2 {
        font-size: 26px;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 6px;
    }
    .supplier-hero .hero-notes {
        color: var(--text-muted);
        font-size: 14px;
        margin-bottom: 14px;
        max-width: 600px;
    }
    .supplier-hero .hero-meta {
        display: flex;
        gap: 10px;
    }
    .supplier-hero .actions {
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
    .badge-local { background: var(--info-bg); color: var(--info); }
    .badge-import { background: #fef3c7; color: #b45309; }
    .badge-active { background: var(--success-bg); color: var(--success); }
    .badge-pending { background: var(--warning-bg); color: var(--warning); }

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
    .stock-header-left h3 i {
        color: var(--success);
        font-size: 22px;
    }
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
    .summary-chip i {
        font-size: 18px;
    }
    .summary-chip.records i { color: var(--info); }
    .summary-chip.quantity i { color: var(--success); }
    .summary-chip.cost i { color: var(--warning); }

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
    .product-cell strong {
        display: block;
        margin-bottom: 2px;
    }
    .product-cell .sub {
        font-size: 12px;
        color: var(--text-muted);
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

            <!-- Supplier Hero -->
            <div class="supplier-hero">
                <div class="hero-content">
                    <h2>${supplier.companyName}</h2>
                    <p class="hero-notes">${supplier.notes}</p>
                    <div class="hero-meta">
                        <span class="badge-pill ${supplier.category eq 'IMPORT' ? 'badge-import' : 'badge-local'}">
                            <i class="ph ph-tag"></i> ${supplier.category}
                        </span>
                        <span class="badge-pill ${supplier.status eq 'PENDING' ? 'badge-pending' : 'badge-active'}">
                            <i class="ph ph-check-circle"></i> ${supplier.status}
                        </span>
                    </div>
                </div>
                <div class="actions">
                    <a class="button button-secondary" href="/suppliers">Back to suppliers</a>
                    <a class="button button-primary" href="/suppliers/edit/${supplier.id}">Edit supplier</a>
                </div>
            </div>

            <!-- Info Grid -->
            <div class="info-grid">
                <div class="info-card">
                    <h3><i class="ph ph-address-book"></i> Contact Information</h3>
                    <div class="detail-row">
                        <span class="detail-label">Contact Person</span>
                        <span class="detail-value">${supplier.contactPerson}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Email Address</span>
                        <span class="detail-value">${supplier.email}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Phone Number</span>
                        <span class="detail-value">${supplier.phone}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Address</span>
                        <span class="detail-value">${supplier.address}</span>
                    </div>
                </div>
                <div class="info-card">
                    <h3><i class="ph ph-truck"></i> Supply Information</h3>
                    <div class="detail-row">
                        <span class="detail-label">City</span>
                        <span class="detail-value">${supplier.city}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Lead Time</span>
                        <span class="detail-value">${supplier.leadTime}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Category</span>
                        <span class="detail-value">${supplier.category}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Status</span>
                        <span class="detail-value">${supplier.status}</span>
                    </div>
                </div>
            </div>

            <!-- Stock In Records -->
            <%
                java.util.List<com.inventory.sims.stockin.StockIn> stockIns =
                        (java.util.List<com.inventory.sims.stockin.StockIn>) request.getAttribute("stockIns");
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
                    <div class="stock-header-left">
                        <h3><i class="ph ph-arrow-circle-down"></i> Stock In Records</h3>
                        <p>Incoming stock received from ${supplier.companyName}.</p>
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
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Unit Cost (LKR)</th>
                            <th>Total Cost (LKR)</th>
                            <th>Details</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (stockIns != null && !stockIns.isEmpty()) {
                                for (com.inventory.sims.stockin.StockIn stockIn : stockIns) {
                        %>
                        <tr>
                            <td><span class="stock-id-badge"><%= stockIn.getId() %></span></td>
                            <td><%= stockIn.getReceivedDate() %></td>
                            <td class="product-cell">
                                <strong><%= stockIn.getProductName() %></strong>
                                <span class="sub"><%= stockIn.getProductId() %></span>
                            </td>
                            <td><%= stockIn.getQuantity() %></td>
                            <td class="money-cell">LKR <%= String.format("%.2f", stockIn.getUnitCost()) %></td>
                            <td class="money-cell">LKR <%= String.format("%.2f", stockIn.getTotalCost()) %></td>
                            <td><%= stockIn.getSpecialDetails() %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" class="empty-row-cell">
                                <i class="ph ph-archive" style="font-size:32px;display:block;margin-bottom:8px;opacity:0.3;"></i>
                                No stock-in records found for this supplier.
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
