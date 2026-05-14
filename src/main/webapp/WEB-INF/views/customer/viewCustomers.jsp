<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customers | SIMS</title>
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
        .toolbar { display: flex; align-items: center; justify-content: space-between; gap: 16px; background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px 8px 0 0; padding: 16px; }
        .toolbar h3 { margin: 0; color: #111827; font-size: 16px; }
        .table-wrap { overflow-x: auto; background: #ffffff; border: 1px solid #d9e1ea; border-top: 0; border-radius: 0 0 8px 8px; }
        table { width: 100%; border-collapse: collapse; min-width: 760px; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: middle; }
        th { color: #475569; background: #f8fafc; font-size: 13px; text-transform: uppercase; }
        tbody tr:hover { background: #f8fafc; }
        tbody tr:last-child td { border-bottom: 0; }
        .badge { display: inline-flex; align-items: center; min-height: 28px; padding: 4px 10px; border-radius: 999px; font-size: 13px; font-weight: 700; background: #eef2f6; color: #475569; }
        .empty { text-align: center; padding: 22px 16px; color: #64748b; }
        @media (max-width: 760px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 20px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px; }
            .topbar { align-items: flex-start; flex-direction: column; }
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
            <a href="/customers" class="active">Customers</a>
            <a href="/suppliers">Suppliers</a>
            <a href="/stockin">Stock In</a>
            <a href="/stockout">Stock Out</a>
            <a href="/alerts">Alerts</a>
            <a href="/users">Users</a>
        </nav>
    </aside>

    <main class="main">
        <header class="topbar">
            <div class="page-title">
                <h1>Customers</h1>
                <p>View customer contact details saved in the system.</p>
            </div>
            <div class="actions">
                <a class="button button-primary" href="/customers/add">Add Customer</a>
            </div>
        </header>

        <section aria-label="Customers table">
            <div class="toolbar">
                <h3>Customer List</h3>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        java.util.List<com.inventory.sims.customer.Customer> customerList =
                                (java.util.List<com.inventory.sims.customer.Customer>) request.getAttribute("customers");
                        if (customerList != null && !customerList.isEmpty()) {
                            for (com.inventory.sims.customer.Customer customer : customerList) {
                    %>
                    <tr>
                        <td><span class="badge"><%= customer.getId() %></span></td>
                        <td><%= customer.getName() %></td>
                        <td><%= customer.getEmail() %></td>
                        <td><%= customer.getPhone() %></td>
                        <td><%= customer.getAddress() == null || customer.getAddress().isBlank() ? "-" : customer.getAddress() %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="empty">No customers found. Click "Add Customer" to create one.</td>
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
