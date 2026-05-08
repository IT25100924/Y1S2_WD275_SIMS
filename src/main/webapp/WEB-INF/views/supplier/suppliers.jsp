<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Suppliers | SIMS</title>
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
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 18px; margin-bottom: 26px; }
        .page-title h1 { margin: 0 0 6px; font-size: 30px; color: #111827; }
        .page-title p { margin: 0; color: #64748b; }
        .actions { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .button { min-height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid transparent; padding: 10px 14px; font: inherit; font-weight: 700; text-decoration: none; cursor: pointer; }
        .button-primary { background: #1d4ed8; color: #fff; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #fff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .summary-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .summary-card { background: #fff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 18px; }
        .summary-card span { display: block; color: #64748b; font-size: 14px; margin-bottom: 10px; }
        .summary-card strong { display: block; color: #111827; font-size: 28px; }
        .toolbar { display: flex; align-items: center; justify-content: space-between; gap: 16px; background: #fff; border: 1px solid #d9e1ea; border-radius: 8px 8px 0 0; padding: 16px; }
        .search { width: min(100%, 360px); }
        .search input { width: 100%; min-height: 42px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; }
        .search input:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .table-wrap { overflow-x: auto; background: #fff; border: 1px solid #d9e1ea; border-top: 0; border-radius: 0 0 8px 8px; }
        table { width: 100%; border-collapse: collapse; min-width: 820px; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: middle; }
        th { color: #475569; background: #f8fafc; font-size: 13px; text-transform: uppercase; }
        tbody tr:hover { background: #f8fafc; }
        tbody tr:last-child td { border-bottom: 0; }
        .supplier-cell { display: flex; align-items: center; gap: 12px; }
        .supplier-badge { width: 40px; height: 40px; border-radius: 999px; background: #dcfce7; color: #166534; display: inline-flex; align-items: center; justify-content: center; font-weight: 700; flex: 0 0 auto; }
        .supplier-name { display: block; font-weight: 700; color: #111827; }
        .supplier-meta { display: block; color: #64748b; font-size: 14px; margin-top: 3px; }
        .badge { display: inline-flex; align-items: center; min-height: 28px; padding: 4px 10px; border-radius: 999px; font-size: 13px; font-weight: 700; }
        .badge-local { color: #075985; background: #e0f2fe; }
        .badge-import { color: #7c2d12; background: #ffedd5; }
        .badge-active { color: #166534; background: #dcfce7; }
        .badge-pending { color: #92400e; background: #fef3c7; }
        .table-actions { display: flex; gap: 8px; }
        .table-actions a { min-height: 34px; border: 1px solid #cbd5e1; border-radius: 6px; background: #fff; color: #334155; padding: 7px 10px; font: inherit; font-size: 14px; text-decoration: none; cursor: pointer; }
        .table-actions a:hover { background: #f8fafc; }
        @media (max-width: 860px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 18px; }
            .brand { margin-bottom: 16px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px 18px; }
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
                    <h1>Suppliers</h1>
                    <p>Track supplier records, contact details, and supply status.</p>
                </div>
                <div class="actions">
                    <a class="button button-secondary" href="/dashboard">Back to dashboard</a>
                    <a class="button button-primary" href="/suppliers/register">Add supplier</a>
                </div>
            </header>
            <section class="summary-grid" aria-label="Supplier summary">
                <div class="summary-card"><span>Total suppliers</span><strong th:text="${totalSuppliers}">24</strong></div>
                <div class="summary-card"><span>Active suppliers</span><strong th:text="${activeSuppliers}">18</strong></div>
                <div class="summary-card"><span>Pending review</span><strong th:text="${pendingSuppliers}">6</strong></div>
            </section>
            <section aria-label="Suppliers table">
                <div class="toolbar">
                    <form class="search" action="/suppliers" method="get">
                        <input type="search" name="keyword" placeholder="Search suppliers" th:value="${keyword}">
                    </form>
                    <a class="button button-secondary" href="/suppliers">Clear filters</a>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Supplier</th>
                                <th>Contact person</th>
                                <th>Phone</th>
                                <th>Category</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr th:each="supplier : ${suppliers}">
                                <td>
                                    <div class="supplier-cell">
                                        <span class="supplier-badge" th:text="${#strings.substring(supplier.companyName, 0, 1)}">A</span>
                                        <div>
                                            <span class="supplier-name" th:text="${supplier.companyName}">ABC Distributors</span>
                                            <span class="supplier-meta" th:text="${supplier.email}">abc@supplier.com</span>
                                        </div>
                                    </div>
                                </td>
                                <td th:text="${supplier.contactPerson}">Nimal Perera</td>
                                <td th:text="${supplier.phone}">0771234567</td>
                                <td><span class="badge badge-local" th:class="${supplier.category == 'IMPORT'} ? 'badge badge-import' : 'badge badge-local'" th:text="${supplier.category}">LOCAL</span></td>
                                <td><span class="badge badge-active" th:class="${supplier.status == 'PENDING'} ? 'badge badge-pending' : 'badge badge-active'" th:text="${supplier.status}">ACTIVE</span></td>
                                <td>
                                    <div class="table-actions">
                                        <a th:href="@{/suppliers/details/{id}(id=${supplier.id})}" href="/suppliers/details/1">View</a>
                                        <a th:href="@{/suppliers/edit/{id}(id=${supplier.id})}" href="/suppliers/edit/1">Edit</a>
                                    </div>
                                </td>
                            </tr>
                            <tr th:remove="all">
                                <td><div class="supplier-cell"><span class="supplier-badge">A</span><div><span class="supplier-name">ABC Distributors</span><span class="supplier-meta">abc@supplier.com</span></div></div></td>
                                <td>Nimal Perera</td>
                                <td>0771234567</td>
                                <td><span class="badge badge-local">LOCAL</span></td>
                                <td><span class="badge badge-active">ACTIVE</span></td>
                                <td><div class="table-actions"><a href="/suppliers/details/1">View</a><a href="/suppliers/edit/1">Edit</a></div></td>
                            </tr>
                            <tr th:remove="all">
                                <td><div class="supplier-cell"><span class="supplier-badge">G</span><div><span class="supplier-name">Global Imports</span><span class="supplier-meta">imports@global.com</span></div></div></td>
                                <td>Sarah Silva</td>
                                <td>0712345678</td>
                                <td><span class="badge badge-import">IMPORT</span></td>
                                <td><span class="badge badge-pending">PENDING</span></td>
                                <td><div class="table-actions"><a href="/suppliers/details/2">View</a><a href="/suppliers/edit/2">Edit</a></div></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
