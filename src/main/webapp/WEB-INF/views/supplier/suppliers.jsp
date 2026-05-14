<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.inventory.sims.supplier.Supplier" %>
<%@ page import="java.util.List" %>
<%
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
    String keyword = (String) request.getAttribute("keyword");
    Object message = request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Records | SIMS</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: Arial, Helvetica, sans-serif; color: #172033; background: #eef2f6; }
        .layout { min-height: 100vh; display: grid; grid-template-columns: 250px 1fr; }
        .sidebar { background: #17324d; color: #fff; padding: 28px 22px; }
        .brand { font-size: 18px; font-weight: 700; margin-bottom: 34px; }
        .nav { display: grid; gap: 8px; }
        .nav a { display: block; padding: 12px 14px; color: #d7e4ef; text-decoration: none; border-radius: 6px; font-weight: 700; }
        .nav a:hover, .nav a.active { color: #fff; background: rgba(255, 255, 255, 0.12); }
        .main { padding: 32px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 18px; margin-bottom: 20px; }
        .page-title h1 { margin: 0 0 6px; font-size: 30px; color: #111827; }
        .page-title p { margin: 0; color: #64748b; }
        .actions { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .button { min-height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid transparent; padding: 10px 14px; font: inherit; font-weight: 700; text-decoration: none; cursor: pointer; }
        .button-primary { background: #1d4ed8; color: #fff; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #fff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .summary-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; margin-bottom: 20px; }
        .summary-card { background: #fff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 16px; }
        .summary-card span { display: block; color: #64748b; font-size: 14px; margin-bottom: 8px; }
        .summary-card strong { display: block; color: #111827; font-size: 24px; }
        .toolbar { display: flex; align-items: center; justify-content: flex-start; gap: 16px; background: #fff; border: 1px solid #d9e1ea; border-radius: 8px 8px 0 0; padding: 14px; }
        .search { width: min(100%, 420px); display: flex; gap: 8px; }
        .search input { flex: 1; min-height: 40px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; }
        .search input:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .table-wrap { overflow-x: auto; background: #fff; border: 1px solid #d9e1ea; border-top: 0; border-radius: 0 0 8px 8px; }
        table { width: 100%; border-collapse: collapse; min-width: 1160px; }
        th, td { padding: 12px 14px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: middle; }
        th { color: #475569; background: #f8fafc; font-size: 12px; text-transform: uppercase; letter-spacing: 0; }
        tbody tr:hover { background: #f8fafc; }
        tbody tr:last-child td { border-bottom: 0; }
        .muted { color: #64748b; }
        .badge { display: inline-flex; align-items: center; min-height: 26px; padding: 3px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
        .badge-local { color: #075985; background: #e0f2fe; }
        .badge-import { color: #7c2d12; background: #ffedd5; }
        .badge-active { color: #166534; background: #dcfce7; }
        .badge-pending { color: #92400e; background: #fef3c7; }
        .row-actions { display: flex; gap: 6px; }
        .row-actions a, .row-actions button { min-height: 32px; border: 1px solid #cbd5e1; border-radius: 6px; background: #fff; color: #334155; padding: 6px 10px; font: inherit; font-size: 13px; text-decoration: none; font-weight: 700; cursor: pointer; }
        .row-actions a:hover, .row-actions button:hover { background: #f8fafc; }
        .row-actions form { margin: 0; }
        .action-update { color: #1d4ed8 !important; border-color: #93c5fd !important; background: #eff6ff !important; }
        .action-delete { color: #b91c1c !important; border-color: #fecaca !important; background: #fef2f2 !important; }
        .empty { text-align: center; color: #64748b; padding: 26px 14px; }
        .flash { margin-bottom: 16px; padding: 10px 12px; border-radius: 6px; border: 1px solid #bbf7d0; color: #166534; background: #f0fdf4; }
        @media (max-width: 980px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 18px; }
            .brand { margin-bottom: 16px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 20px 16px; }
            .topbar, .toolbar { align-items: stretch; flex-direction: column; }
            .summary-grid { grid-template-columns: 1fr; }
            .actions, .button, .search { width: 100%; }
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
            <a href="/suppliers" class="active">Suppliers</a>
            <a href="/stockin">Stock In</a>
            <a href="/stockout">Stock Out</a>
            <a href="/alerts">Alerts</a>
            <a href="/users">Users</a>
        </nav>
    </aside>

    <main class="main">
        <header class="topbar">
            <div class="page-title">
                <h1>Supplier Records</h1>
                <p>Manage each supplier as a row record with direct actions.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/dashboard">Back to dashboard</a>
                <a class="button button-primary" href="/suppliers/register">Add supplier</a>
            </div>
        </header>

        <% if (message != null) { %>
        <div class="flash"><%= message %></div>
        <% } %>

        <section class="summary-grid" aria-label="Supplier summary">
            <div class="summary-card"><span>Total records</span><strong>${totalSuppliers}</strong></div>
            <div class="summary-card"><span>Active</span><strong>${activeSuppliers}</strong></div>
            <div class="summary-card"><span>Pending</span><strong>${pendingSuppliers}</strong></div>
        </section>

        <section aria-label="Supplier records table">
            <div class="toolbar">
                <form class="search" action="/suppliers" method="get">
                    <input type="search" name="keyword" placeholder="Search by id, company, email, phone, status..." value="<%= keyword == null ? "" : keyword %>">
                    <button class="button button-secondary" type="submit">Search</button>
                </form>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Company</th>
                        <th>Contact</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>City</th>
                        <th>Lead time</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (suppliers == null || suppliers.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="10" class="empty">No supplier records found.</td>
                    </tr>
                    <%
                        } else {
                            for (Supplier supplier : suppliers) {
                                String categoryClass = "IMPORT".equalsIgnoreCase(supplier.getCategory()) ? "badge badge-import" : "badge badge-local";
                                String statusClass = "PENDING".equalsIgnoreCase(supplier.getStatus()) ? "badge badge-pending" : "badge badge-active";
                    %>
                    <tr>
                        <td><%= supplier.getId() %></td>
                        <td><%= supplier.getCompanyName() %></td>
                        <td><%= supplier.getContactPerson() %></td>
                        <td><%= supplier.getPhone() %></td>
                        <td class="muted"><%= supplier.getEmail() %></td>
                        <td><%= supplier.getCity() %></td>
                        <td><%= supplier.getLeadTime() %></td>
                        <td><span class="<%= categoryClass %>"><%= supplier.getCategory() %></span></td>
                        <td><span class="<%= statusClass %>"><%= supplier.getStatus() %></span></td>
                        <td>
                            <div class="row-actions">
                                <a href="/suppliers/details/<%= supplier.getId() %>">View</a>
                                <a class="action-update" href="/suppliers/edit/<%= supplier.getId() %>">Update</a>
                                <form action="/suppliers/delete/<%= supplier.getId() %>" method="post" onsubmit="return confirm('Delete this supplier record?');">
                                    <button class="action-delete" type="submit">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
