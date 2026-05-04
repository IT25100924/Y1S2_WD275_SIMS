<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alerts | SIMS</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: #172033;
            background: #eef2f6;
        }

        .layout {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 250px 1fr;
        }

        .sidebar {
            background: #17324d;
            color: #ffffff;
            padding: 28px 22px;
        }

        .brand {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 34px;
        }

        .nav {
            display: grid;
            gap: 8px;
        }

        .nav a {
            display: block;
            padding: 12px 14px;
            color: #d7e4ef;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 700;
        }

        .nav a:hover,
        .nav a.active {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.12);
        }

        .main {
            padding: 32px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 26px;
        }

        .page-title h1 {
            margin: 0 0 6px;
            font-size: 30px;
            color: #111827;
        }

        .page-title p {
            margin: 0;
            color: #64748b;
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .button {
            min-height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            border: 1px solid transparent;
            padding: 10px 14px;
            font: inherit;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        .button-primary {
            background: #1d4ed8;
            color: #ffffff;
        }

        .button-primary:hover {
            background: #1e40af;
        }

        .button-secondary {
            background: #ffffff;
            color: #334155;
            border-color: #cbd5e1;
        }

        .button-secondary:hover {
            background: #f8fafc;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }

        .summary-card {
            background: #ffffff;
            border: 1px solid #d9e1ea;
            border-radius: 8px;
            padding: 18px;
        }

        .summary-card span {
            display: block;
            color: #64748b;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .summary-card strong {
            display: block;
            color: #111827;
            font-size: 28px;
        }

        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            background: #ffffff;
            border: 1px solid #d9e1ea;
            border-radius: 8px 8px 0 0;
            padding: 16px;
        }

        .search {
            width: min(100%, 360px);
        }

        .search input {
            width: 100%;
            min-height: 42px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 10px 12px;
            font: inherit;
        }

        .search input:focus {
            border-color: #2563eb;
            outline: 3px solid rgba(37, 99, 235, 0.16);
        }

        .table-wrap {
            overflow-x: auto;
            background: #ffffff;
            border: 1px solid #d9e1ea;
            border-top: 0;
            border-radius: 0 0 8px 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 920px;
        }

        th,
        td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
        }

        th {
            color: #475569;
            background: #f8fafc;
            font-size: 13px;
            text-transform: uppercase;
        }

        tbody tr:hover {
            background: #f8fafc;
        }

        tbody tr:last-child td {
            border-bottom: 0;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            padding: 6px 10px;
            font-weight: 700;
            font-size: 12px;
            letter-spacing: 0.02em;
            border: 1px solid transparent;
            text-transform: uppercase;
        }

        .badge-open {
            background: #eff6ff;
            color: #1d4ed8;
            border-color: #bfdbfe;
        }

        .badge-resolved {
            background: #f0fdf4;
            color: #166534;
            border-color: #bbf7d0;
        }

        .badge-critical {
            background: #fef2f2;
            color: #b91c1c;
            border-color: #fecaca;
        }

        .badge-warning {
            background: #fffbeb;
            color: #b45309;
            border-color: #fde68a;
        }

        .badge-info {
            background: #f1f5f9;
            color: #334155;
            border-color: #cbd5e1;
        }

        .table-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .table-actions a,
        .table-actions button {
            font: inherit;
            font-weight: 700;
            color: #1d4ed8;
            background: none;
            border: 0;
            padding: 0;
            cursor: pointer;
            text-decoration: none;
        }

        .table-actions a:hover,
        .table-actions button:hover {
            text-decoration: underline;
        }

        .empty-state {
            padding: 26px 16px;
            color: #64748b;
        }

        @media (max-width: 960px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                position: sticky;
                top: 0;
                z-index: 10;
            }
        }

        @media (max-width: 640px) {
            .main {
                padding: 20px;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="layout">
        <aside class="sidebar">
            <div class="brand">SIMS</div>
            <nav class="nav" aria-label="Primary navigation">
                <a href="/dashboard">Dashboard</a>
                <a href="/products">Products</a>
                <a href="/suppliers">Suppliers</a>
                <a href="/stockin">Stock In</a>
                <a href="/stockout">Stock Out</a>
                <a href="/alerts" class="active">Alerts</a>
                <a href="/users">Users</a>
            </nav>
        </aside>

        <main class="main">
            <header class="topbar">
                <div class="page-title">
                    <h1>Alerts</h1>
                    <p>Track low stock warnings and system notifications.</p>
                </div>
                <div class="actions">
                    <a class="button button-secondary" href="/users/login">Logout</a>
                    <a class="button button-primary" href="/alerts/add">Add alert</a>
                </div>
            </header>

            <section class="summary-grid" aria-label="Alert summary">
                <div class="summary-card">
                    <span>Total alerts</span>
                    <strong th:text="${totalAlerts}">0</strong>
                </div>
                <div class="summary-card">
                    <span>Open</span>
                    <strong th:text="${openAlerts}">0</strong>
                </div>
                <div class="summary-card">
                    <span>Resolved</span>
                    <strong th:text="${resolvedAlerts}">0</strong>
                </div>
            </section>

            <section aria-label="Alerts table">
                <div class="toolbar">
                    <form class="search" action="/alerts" method="get">
                        <input type="search" name="q" placeholder="Search alerts..." aria-label="Search alerts">
                    </form>
                </div>

                <div class="table-wrap">
                    <table aria-label="Alerts list">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Type</th>
                                <th>Message</th>
                                <th>Created</th>
                                <th>Status</th>
                                <th>Severity</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr th:each="alert : ${alerts}">
                                <td th:text="${alert.id}">ALT-001</td>
                                <td th:text="${alert.type}">LOW_STOCK</td>
                                <td th:text="${alert.message}">Product is below reorder level.</td>
                                <td th:text="${alert.createdAt}">2026-04-30</td>
                                <td>
                                    <span class="badge badge-open"
                                          th:class="${alert.resolved} ? 'badge badge-resolved' : 'badge badge-open'"
                                          th:text="${alert.resolved} ? 'Resolved' : 'Open'">Open</span>
                                </td>
                                <td>
                                    <span class="badge badge-info"
                                          th:class="${alert.severity} == 'CRITICAL' ? 'badge badge-critical' : (${alert.severity} == 'WARNING' ? 'badge badge-warning' : 'badge badge-info')"
                                          th:text="${alert.severity}">INFO</span>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <a th:href="@{/alerts/update/{id}(id=${alert.id})}" href="/alerts/update/ALT-001">Update</a>
                                        <form th:action="@{/alerts/delete/{id}(id=${alert.id})}" action="/alerts/delete/ALT-001" method="post">
                                            <button type="submit">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>

                            <tr th:if="${alerts == null || #lists.isEmpty(alerts)}">
                                <td colspan="7" class="empty-state">No alerts yet. Create one using “Add alert”.</td>
                            </tr>

                            <tr th:remove="all">
                                <td>ALT-001</td>
                                <td>LOW_STOCK</td>
                                <td>USB keyboard stock is below reorder level.</td>
                                <td>2026-04-30</td>
                                <td><span class="badge badge-open">Open</span></td>
                                <td><span class="badge badge-warning">WARNING</span></td>
                                <td>
                                    <div class="table-actions">
                                        <a href="/alerts/update/ALT-001">Update</a>
                                        <form action="/alerts/delete/ALT-001" method="post">
                                            <button type="submit">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
