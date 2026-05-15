<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.inventory.sims.user.User" %>
<%@ page import="com.inventory.sims.user.UserType" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%!
    private String text(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value);
    }

    private String attribute(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value, "UTF-8");
    }

    private long longValue(Object value) {
        return value instanceof Number number ? number.longValue() : 0L;
    }

    private String firstLetter(User user) {
        if (user == null || user.getFirstName() == null || user.getFirstName().isBlank()) {
            return "U";
        }
        return user.getFirstName().trim().substring(0, 1).toUpperCase();
    }

    private String fullName(User user) {
        if (user == null) {
            return "";
        }
        String first = user.getFirstName() == null ? "" : user.getFirstName().trim();
        String last = user.getLastName() == null ? "" : user.getLastName().trim();
        return (first + " " + last).trim();
    }
%>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) {
        users = Collections.emptyList();
    }

    String keyword = (String) request.getAttribute("keyword");
    long totalUsers = longValue(request.getAttribute("totalUsers"));
    long adminUsers = longValue(request.getAttribute("adminUsers"));
    long staffUsers = longValue(request.getAttribute("staffUsers"));
    long activeUsers = longValue(request.getAttribute("activeUsers"));
    long filteredUsers = longValue(request.getAttribute("filteredUsers"));
    Object message = request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users | SIMS</title>
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
            grid-template-columns: repeat(4, minmax(0, 1fr));
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
            display: flex;
            width: min(100%, 460px);
            gap: 10px;
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

        .result-count {
            color: #64748b;
            font-size: 14px;
            white-space: nowrap;
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
            min-width: 940px;
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

        .user-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 38px;
            height: 38px;
            border-radius: 999px;
            background: #dbeafe;
            color: #1d4ed8;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            flex: 0 0 auto;
        }

        .user-name {
            display: block;
            font-weight: 700;
            color: #111827;
        }

        .user-email {
            display: block;
            color: #64748b;
            font-size: 14px;
            margin-top: 3px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            min-height: 28px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
        }

        .badge-admin {
            color: #7c2d12;
            background: #ffedd5;
        }

        .badge-staff {
            color: #075985;
            background: #e0f2fe;
        }

        .badge-active {
            color: #166534;
            background: #dcfce7;
        }

        .badge-inactive {
            color: #991b1b;
            background: #fee2e2;
        }

        .row-actions {
            display: flex;
            gap: 8px;
        }

        .row-actions a {
            min-height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #93c5fd;
            border-radius: 6px;
            background: #eff6ff;
            color: #1d4ed8;
            padding: 7px 11px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
        }

        .row-actions a:hover {
            background: #dbeafe;
        }

        .flash {
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 6px;
            border: 1px solid #bbf7d0;
            color: #166534;
            background: #f0fdf4;
        }

        .empty-state {
            padding: 34px 16px;
            text-align: center;
            color: #64748b;
        }

        @media (max-width: 960px) {
            .summary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 760px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding: 18px;
            }

            .brand {
                margin-bottom: 16px;
            }

            .nav {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .main {
                padding: 24px 18px;
            }

            .topbar,
            .toolbar,
            .search {
                align-items: stretch;
                flex-direction: column;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .actions,
            .button,
            .search {
                width: 100%;
            }

            .result-count {
                white-space: normal;
            }
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
                <a href="/stockout">Stock Out</a>
                <a href="/alerts">Alerts</a>
                <a href="/users" class="active">Users</a>
            </nav>
        </aside>

        <main class="main">
            <header class="topbar">
                <div class="page-title">
                    <h1>Users</h1>
                    <p>View registered system accounts and access roles.</p>
                </div>
                <div class="actions">
                    <a class="button button-secondary" href="/users/login">Logout</a>
                    <a class="button button-primary" href="/users/register">Add user</a>
                </div>
            </header>

            <section class="summary-grid" aria-label="User summary">
                <div class="summary-card">
                    <span>Total users</span>
                    <strong><%= totalUsers %></strong>
                </div>
                <div class="summary-card">
                    <span>Admin users</span>
                    <strong><%= adminUsers %></strong>
                </div>
                <div class="summary-card">
                    <span>Staff users</span>
                    <strong><%= staffUsers %></strong>
                </div>
                <div class="summary-card">
                    <span>Active users</span>
                    <strong><%= activeUsers %></strong>
                </div>
            </section>

            <% if (message != null) { %>
                <div class="flash"><%= text(message.toString()) %></div>
            <% } %>

            <section aria-label="Users table">
                <div class="toolbar">
                    <form class="search" action="/users" method="get">
                        <input type="search" name="keyword" placeholder="Search by name, email, phone, role, or ID" value="<%= attribute(keyword) %>">
                        <button class="button button-primary" type="submit">Search</button>
                    </form>
                    <div class="actions">
                        <span class="result-count"><%= filteredUsers %> shown</span>
                        <a class="button button-secondary" href="/users">Clear</a>
                    </div>
                </div>

                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (users.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="empty-state">No users found.</td>
                                </tr>
                            <% } else { %>
                                <% for (User user : users) { %>
                                    <tr>
                                        <td><%= text(user.getId()) %></td>
                                        <td>
                                            <div class="user-cell">
                                                <span class="avatar"><%= text(firstLetter(user)) %></span>
                                                <div>
                                                    <span class="user-name"><%= text(fullName(user)) %></span>
                                                    <span class="user-email"><%= text(user.getEmail()) %></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%= text(user.getPhone()) %></td>
                                        <td>
                                            <% boolean staff = user.getRole() == UserType.STAFF; %>
                                            <span class="badge <%= staff ? "badge-staff" : "badge-admin" %>"><%= text(user.getRole() == null ? "" : user.getRole().name()) %></span>
                                        </td>
                                        <td>
                                            <span class="badge <%= user.isActive() ? "badge-active" : "badge-inactive" %>"><%= user.isActive() ? "Active" : "Inactive" %></span>
                                        </td>
                                        <td>
                                            <div class="row-actions">
                                                <a href="/users/edit/<%= attribute(user.getId()) %>">Update</a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
