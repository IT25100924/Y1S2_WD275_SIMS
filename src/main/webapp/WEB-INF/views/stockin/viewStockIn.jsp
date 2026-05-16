<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Stock In | SIMS</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: Arial, Helvetica, sans-serif; color: #172033; background: #eef2f6; }
        .layout { min-height: 100vh; display: grid; grid-template-columns: 250px 1fr; }
        .sidebar { background: #17324d; color: #ffffff; padding: 28px 22px; }
        .brand { font-size: 18px; font-weight: 700; margin-bottom: 34px; }
        .nav { display: grid; gap: 8px; }
        .nav a { display: block; padding: 12px 14px; color: #d7e4ef; text-decoration: none; border-radius: 6px; font-weight: 700; }
        .nav a:hover, .nav a.active { color: #ffffff; background: rgba(255, 255, 255, 0.12); }
        .main { padding: 32px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 18px; margin-bottom: 26px; }
        .page-title h1 { margin: 0 0 6px; font-size: 30px; color: #111827; }
        .page-title p { margin: 0; color: #64748b; }
        .actions { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .button { min-height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid transparent; padding: 10px 14px; font: inherit; font-weight: 700; text-decoration: none; cursor: pointer; }
        .button-primary { background: #1d4ed8; color: #ffffff; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #ffffff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .alert { margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; font-size: 14px; font-weight: 700; }
        .alert-success { color: #166534; background: #dcfce7; border: 1px solid #86efac; }
        .alert-error { color: #991b1b; background: #fee2e2; border: 1px solid #fecaca; }
        .summary-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .summary-card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 18px; }
        .summary-card span { display: block; color: #64748b; font-size: 14px; margin-bottom: 10px; }
        .summary-card strong { display: block; color: #111827; font-size: 28px; }
        .toolbar { display: flex; align-items: center; justify-content: space-between; gap: 16px; background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px 8px 0 0; padding: 16px; }
        .toolbar h2 { margin: 0; color: #111827; font-size: 16px; }
        .table-wrap { overflow-x: auto; background: #ffffff; border: 1px solid #d9e1ea; border-top: 0; border-radius: 0 0 8px 8px; }
        table { width: 100%; border-collapse: collapse; min-width: 960px; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: middle; }
        th { color: #475569; background: #f8fafc; font-size: 13px; text-transform: uppercase; }
        tbody tr:hover { background: #f8fafc; }
        tbody tr:last-child td { border-bottom: 0; }
        .badge { display: inline-flex; align-items: center; min-height: 28px; padding: 4px 10px; border-radius: 999px; font-size: 13px; font-weight: 700; background: #dcfce7; color: #166534; }
        .money { font-weight: 700; color: #111827; }
        .muted { color: #64748b; }
        .table-actions { display: flex; gap: 8px; flex-wrap: wrap; }
        .table-actions form { margin: 0; }
        .table-actions a, .table-actions button { min-height: 34px; border: 1px solid #cbd5e1; border-radius: 6px; background: #ffffff; color: #334155; padding: 7px 10px; font: inherit; font-size: 14px; text-decoration: none; cursor: pointer; }
        .table-actions a:hover, .table-actions button:hover { background: #f8fafc; }
        .table-actions .delete-button { color: #991b1b; border-color: #fecaca; }
        .table-actions .delete-button:hover { background: #fee2e2; }

        @media (max-width: 900px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 18px; }
            .brand { margin-bottom: 16px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px 18px; }
            .topbar, .toolbar { align-items: stretch; flex-direction: column; }
            .summary-grid { grid-template-columns: 1fr; }
            .actions, .button { width: 100%; }
        }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">SIMS</div>
        <nav class="nav" aria-label="Main navigation">
            <a href="/dashboard">Dashboard</a>
            <a href="/products">Products</a>
            <a href="/suppliers">Suppliers</a>
            <a href="/stockin" class="active">Stock In</a>
            <a href="/stockout">Stock Out</a>
            <a href="/alerts">Alerts</a>
            <a href="/users">Users</a>
        </nav>
    </aside>

    <main class="main">
        <header class="topbar">
            <div class="page-title">
                <h1>Stock In Records</h1>
                <p>Review incoming stock entries saved in the system.</p>
            </div>
            <div class="actions">
                <a class="button button-primary" href="/stockin">Add Stock In</a>
            </div>
        </header>

        <%
            java.util.List<com.inventory.sims.stockin.StockIn> stockIns =
                    (java.util.List<com.inventory.sims.stockin.StockIn>) request.getAttribute("stockIns");
            int totalRecords = stockIns == null ? 0 : stockIns.size();
            int totalQuantity = 0;
            double totalCost = 0;
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            if (stockIns != null) {
                for (com.inventory.sims.stockin.StockIn stockIn : stockIns) {
                    totalQuantity += stockIn.getQuantity();
                    totalCost += stockIn.getTotalCost();
                }
            }
        %>

        <% if (success != null && !success.isBlank()) { %>
        <div class="alert alert-success"><%= success %></div>
        <% } %>
        <% if (error != null && !error.isBlank()) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <section class="summary-grid" aria-label="Stock in summary">
            <div class="summary-card">
                <span>Total records</span>
                <strong><%= totalRecords %></strong>
            </div>
            <div class="summary-card">
                <span>Total quantity in</span>
                <strong><%= totalQuantity %></strong>
            </div>
            <div class="summary-card">
                <span>Total stock cost</span>
                <strong>LKR <%= String.format("%.2f", totalCost) %></strong>
            </div>
        </section>

        <section aria-label="Stock in table">
            <div class="toolbar">
                <h2>Stock In List</h2>
                <a class="button button-secondary" href="/stockin/view">Refresh</a>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Product</th>
                        <th>Supplier</th>
                        <th>Quantity</th>
                        <th>Unit Cost (LKR)</th>
                        <th>Total Cost (LKR)</th>
                        <th>Note</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (stockIns != null && !stockIns.isEmpty()) {
                            for (com.inventory.sims.stockin.StockIn stockIn : stockIns) {
                    %>
                    <tr>
                        <td><span class="badge"><%= stockIn.getId() %></span></td>
                        <td><%= stockIn.getReceivedDate() %></td>
                        <td>
                            <strong><%= stockIn.getProductName() %></strong><br>
                            <span class="muted"><%= stockIn.getProductId() %></span>
                        </td>
                        <td><%= stockIn.getSupplierName() %></td>
                        <td><%= stockIn.getQuantity() %></td>
                        <td class="money">LKR <%= String.format("%.2f", stockIn.getUnitCost()) %></td>
                        <td class="money">LKR <%= String.format("%.2f", stockIn.getTotalCost()) %></td>
                        <td><%= stockIn.getNote() == null || stockIn.getNote().isBlank() ? "-" : stockIn.getNote() %></td>
                        <td>
                            <div class="table-actions">
                                <a href="/stockin/edit/<%= stockIn.getId() %>">Edit</a>
                                <form action="/stockin/delete/<%= stockIn.getId() %>" method="post"
                                      onsubmit="return confirm('Delete stock-in record <%= stockIn.getId() %>?');">
                                    <button type="submit" class="delete-button">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="9" style="text-align: center; padding: 22px; color: #64748b;">No stock-in records found.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
