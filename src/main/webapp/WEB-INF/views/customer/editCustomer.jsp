<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.customer.Customer customer =
            (com.inventory.sims.customer.Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Customer | SIMS</title>
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
        .form-card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 24px; max-width: 600px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 700; color: #334155; font-size: 14px; }
        .form-control { width: 100%; min-height: 42px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; }
        textarea.form-control { min-height: 96px; resize: vertical; }
        .form-control:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .form-control[readonly] { background-color: #f1f5f9; color: #64748b; cursor: not-allowed; }
        .button { min-height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid transparent; padding: 10px 14px; font: inherit; font-weight: 700; text-decoration: none; cursor: pointer; }
        .button-primary { background: #1d4ed8; color: #ffffff; width: 100%; margin-top: 10px; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #ffffff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .message { margin-bottom: 18px; border-radius: 6px; padding: 12px 14px; font-weight: 700; }
        .message-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
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
        <nav class="nav">
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
                <h1>Edit Customer</h1>
                <p>Update contact details for customer <%= customer.getId() %>.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/customers">Cancel</a>
            </div>
        </header>

        <div class="form-card">
            <% if (request.getAttribute("error") != null) { %>
            <div class="message message-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="/customers/edit/<%= customer.getId() %>" method="post">
                <div class="form-group">
                    <label for="id">Customer ID</label>
                    <input type="text" id="id" class="form-control" value="<%= customer.getId() %>" readonly>
                </div>

                <div class="form-group">
                    <label for="name">Customer Name</label>
                    <input type="text" id="name" name="name" class="form-control" required value="<%= customer.getName() %>">
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required value="<%= customer.getEmail() %>">
                </div>

                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-control" required value="<%= customer.getPhone() %>">
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-control"><%= customer.getAddress() == null ? "" : customer.getAddress() %></textarea>
                </div>

                <button type="submit" class="button button-primary">Update Customer</button>
            </form>
        </div>
    </main>
</div>
</body>
</html>
