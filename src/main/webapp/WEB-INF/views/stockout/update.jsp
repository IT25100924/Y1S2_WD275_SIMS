<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.stockout.StockOut stockOut =
            (com.inventory.sims.stockout.StockOut) request.getAttribute("stockOut");
    String stockOutDate = stockOut.getStockOutDate() == null ? "" : stockOut.getStockOutDate().toString();
    String note = stockOut.getNote() == null ? "" : stockOut.getNote();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Stockout | SIMS</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: Arial, Helvetica, sans-serif; color: #172033; background: #eef2f6; }
        .layout { min-height: 100vh; display: grid; grid-template-columns: 250px 1fr; }
        .sidebar { background: #17324d; color: #ffffff; padding: 28px 22px; }
        .brand { font-size: 18px; font-weight: 700; margin-bottom: 34px; }
        .nav { display: grid; gap: 8px; }
        .nav a { display: block; padding: 12px 14px; color: #d7e4ef; text-decoration: none; border-radius: 6px; font-weight: 700; }
        .nav a:hover, .nav a.active { color: #ffffff; background: rgba(255, 255, 255, 0.12); }
        .main { padding: 32px; min-width: 0; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 18px; margin-bottom: 26px; }
        .page-title h1 { margin: 0 0 6px; font-size: 30px; color: #111827; }
        .page-title p { margin: 0; color: #64748b; line-height: 1.5; }
        .form-card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 24px; max-width: 760px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        label { display: grid; gap: 8px; font-weight: 700; color: #263548; font-size: 14px; }
        input, select, textarea { width: 100%; min-height: 46px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; color: #111827; background: #ffffff; }
        input[readonly] { background: #f1f5f9; color: #64748b; cursor: not-allowed; }
        textarea { min-height: 98px; resize: vertical; }
        input:focus, select:focus, textarea:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .full-width { grid-column: 1 / -1; }
        .actions { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin-top: 22px; }
        .button, button { min-height: 46px; border-radius: 6px; padding: 11px 16px; font: inherit; font-weight: 700; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        button { border: 0; background: #1d4ed8; color: #ffffff; }
        button:hover { background: #1e40af; }
        .button-secondary { border: 1px solid #cbd5e1; background: #ffffff; color: #334155; }
        .button-secondary:hover { background: #f8fafc; }
        .alert { margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; border: 1px solid #fecaca; color: #991b1b; background: #fef2f2; font-size: 14px; font-weight: 700; }
        .alert:empty { display: none; }

        @media (max-width: 820px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 20px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px; }
            .topbar { align-items: flex-start; flex-direction: column; }
            .form-grid { grid-template-columns: 1fr; }
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
            <a href="/stockin">Stock In</a>
            <a href="/stockout" class="active">Stock Out</a>
            <a href="/alerts">Alerts</a>
            <a href="/users">Users</a>
        </nav>
    </aside>

    <main class="main">
        <header class="topbar">
            <div class="page-title">
                <h1>Update Stockout</h1>
                <p>Edit stockout record <strong><%= stockOut.getId() %></strong>.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/stockout">Back to records</a>
            </div>
        </header>

        <section class="form-card" aria-label="Update stockout form">
            <div class="alert">${message}</div>

            <form action="/stockout/update/<%= stockOut.getId() %>" method="post">
                <div class="form-grid">
                    <label>
                        Stockout ID
                        <input type="text" value="<%= stockOut.getId() %>" readonly>
                    </label>

                    <label>
                        Product ID
                        <input type="text" name="productId" value="<%= stockOut.getProductId() %>" required>
                    </label>

                    <label>
                        Product name
                        <input type="text" name="productName" value="<%= stockOut.getProductName() %>" required>
                    </label>

                    <label>
                        Quantity
                        <input type="number" name="quantity" min="1" step="1" value="<%= stockOut.getQuantity() %>" required>
                    </label>

                    <label>
                        Stockout date
                        <input type="date" name="stockOutDate" value="<%= stockOutDate %>">
                    </label>

                    <label>
                        Issued to
                        <input type="text" name="issuedTo" value="<%= stockOut.getIssuedTo() %>" required>
                    </label>

                    <label>
                        Reason
                        <select name="reason" required>
                            <option value="">Select reason</option>
                            <option value="Sale" <%= "Sale".equals(stockOut.getReason()) ? "selected" : "" %>>Sale</option>
                            <option value="Internal use" <%= "Internal use".equals(stockOut.getReason()) ? "selected" : "" %>>Internal use</option>
                            <option value="Damaged item" <%= "Damaged item".equals(stockOut.getReason()) ? "selected" : "" %>>Damaged item</option>
                            <option value="Returned to supplier" <%= "Returned to supplier".equals(stockOut.getReason()) ? "selected" : "" %>>Returned to supplier</option>
                            <option value="Other" <%= "Other".equals(stockOut.getReason()) ? "selected" : "" %>>Other</option>
                        </select>
                    </label>

                    <label class="full-width">
                        Note
                        <textarea name="note"><%= note %></textarea>
                    </label>
                </div>

                <div class="actions">
                    <button type="submit">Update stockout</button>
                    <a class="button button-secondary" href="/stockout">Cancel</a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
