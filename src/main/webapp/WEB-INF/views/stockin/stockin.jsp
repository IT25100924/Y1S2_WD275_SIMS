<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock In | SIMS</title>
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
        .button-primary { background: #1d4ed8; color: #ffffff; width: 100%; margin-top: 6px; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #ffffff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .content-grid { display: grid; grid-template-columns: minmax(0, 640px) minmax(260px, 1fr); gap: 22px; align-items: start; }
        .form-card, .info-panel { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 24px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: grid; gap: 8px; margin-bottom: 18px; }
        .full-width { grid-column: 1 / -1; }
        .form-group label { font-weight: 700; color: #334155; font-size: 14px; }
        .form-control { width: 100%; min-height: 42px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; background: #ffffff; }
        textarea.form-control { min-height: 96px; resize: vertical; }
        .form-control:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .alert { margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; font-size: 14px; font-weight: 700; }
        .alert-success { color: #166534; background: #dcfce7; border: 1px solid #86efac; }
        .alert-error { color: #991b1b; background: #fee2e2; border: 1px solid #fecaca; }
        .info-panel h2 { margin: 0 0 14px; font-size: 18px; color: #111827; }
        .info-panel p { margin: 0 0 16px; color: #64748b; line-height: 1.6; }
        .stat-list { display: grid; gap: 12px; margin: 0; padding: 0; list-style: none; }
        .stat-list li { display: flex; justify-content: space-between; gap: 12px; padding: 12px 0; border-top: 1px solid #e2e8f0; color: #475569; }
        .stat-list strong { color: #111827; }

        @media (max-width: 900px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 18px; }
            .brand { margin-bottom: 16px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px 18px; }
            .topbar { align-items: stretch; flex-direction: column; }
            .content-grid, .form-grid { grid-template-columns: 1fr; }
            .actions, .button-secondary { width: 100%; }
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
                <h1>Stock In</h1>
                <p>Record incoming stock and add it to product quantity.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/products">View Products</a>
            </div>
        </header>

        <%
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            java.util.List<com.inventory.sims.product.Product> products =
                    (java.util.List<com.inventory.sims.product.Product>) request.getAttribute("products");
            String today = (String) request.getAttribute("today");
        %>

        <% if (success != null && !success.isBlank()) { %>
        <div class="alert alert-success"><%= success %></div>
        <% } %>
        <% if (error != null && !error.isBlank()) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <div class="content-grid">
            <section class="form-card" aria-label="Stock in form">
                <form action="/stockin" method="post">
                    <div class="form-group full-width">
                        <label for="productId">Product</label>
                        <select id="productId" name="productId" class="form-control" required>
                            <option value="">Select product</option>
                            <%
                                if (products != null) {
                                    for (com.inventory.sims.product.Product product : products) {
                            %>
                            <option value="<%= product.getId() %>">
                                <%= product.getId() %> - <%= product.getName() %> (Current: <%= product.getQuantity() %>)
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="supplierName">Supplier Name</label>
                            <input type="text" id="supplierName" name="supplierName" class="form-control" required placeholder="Supplier name">
                        </div>

                        <div class="form-group">
                            <label for="receivedDate">Received Date</label>
                            <input type="date" id="receivedDate" name="receivedDate" class="form-control" value="<%= today == null ? "" : today %>" required>
                        </div>

                        <div class="form-group">
                            <label for="quantity">Quantity In</label>
                            <input type="number" id="quantity" name="quantity" class="form-control" min="1" required placeholder="0">
                        </div>

                        <div class="form-group">
                            <label for="unitCost">Unit Cost</label>
                            <input type="number" id="unitCost" name="unitCost" class="form-control" step="0.01" min="0" required placeholder="0.00">
                        </div>

                        <div class="form-group full-width">
                            <label for="note">Note</label>
                            <textarea id="note" name="note" class="form-control" placeholder="Optional stock-in note"></textarea>
                        </div>
                    </div>

                    <button type="submit" class="button button-primary">Save Stock In</button>
                </form>
            </section>
            
        </div>
    </main>
</div>
</body>
</html>
