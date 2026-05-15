<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.inventory.sims.user.User" %>
<%@ page import="com.inventory.sims.user.UserType" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%!
    private String text(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value);
    }

    private String attribute(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value, "UTF-8");
    }
%>
<%
    User user = (User) request.getAttribute("user");
    Object message = request.getAttribute("message");
    String fullName = user == null ? "" : ((user.getFirstName() == null ? "" : user.getFirstName()) + " " + (user.getLastName() == null ? "" : user.getLastName())).trim();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User | SIMS</title>
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
            width: 100%;
            min-height: 48px;
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

        .form-card {
            width: min(100%, 780px);
            background: #ffffff;
            border: 1px solid #d9e1ea;
            border-radius: 8px;
            padding: 24px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        label {
            display: grid;
            gap: 8px;
            font-weight: 700;
            color: #263548;
            font-size: 14px;
        }

        input,
        select {
            width: 100%;
            min-height: 46px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 10px 12px;
            font: inherit;
            color: #111827;
            background: #ffffff;
        }

        input:focus,
        select:focus {
            border-color: #2563eb;
            outline: 3px solid rgba(37, 99, 235, 0.16);
        }

        input[readonly] {
            color: #64748b;
            background: #f1f5f9;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .checkbox-label {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin: 18px 0;
            font-weight: 400;
            color: #475569;
            line-height: 1.5;
        }

        .checkbox-label input {
            width: 16px;
            height: 16px;
            min-height: 16px;
            padding: 0;
            margin-top: 3px;
            flex: 0 0 auto;
        }

        .alert {
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 6px;
            border: 1px solid #fecaca;
            color: #991b1b;
            background: #fff1f2;
            font-size: 14px;
        }

        .form-note {
            margin: 0 0 20px;
            color: #64748b;
            line-height: 1.5;
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

            .topbar {
                align-items: stretch;
                flex-direction: column;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .button {
                width: 100%;
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
                    <h1>Edit User</h1>
                    <p>Update account details for <%= text(fullName.isBlank() ? user.getId() : fullName) %>.</p>
                </div>
                <a class="button button-secondary" href="/users">Back to users</a>
            </header>

            <section class="form-card">
                <% if (message != null) { %>
                    <div class="alert"><%= text(message.toString()) %></div>
                <% } %>

                <p class="form-note">Leave password fields blank to keep the current password.</p>

                <form action="/users/edit/<%= attribute(user.getId()) %>" method="post">
                    <div class="form-grid">
                        <label>
                            User ID
                            <input type="text" value="<%= attribute(user.getId()) %>" readonly>
                        </label>

                        <label>
                            User role
                            <select name="role" required>
                                <option value="ADMIN" <%= user.getRole() == UserType.ADMIN ? "selected" : "" %>>Admin</option>
                                <option value="STAFF" <%= user.getRole() == UserType.STAFF ? "selected" : "" %>>Staff</option>
                            </select>
                        </label>

                        <label>
                            First name
                            <input type="text" name="firstName" value="<%= attribute(user.getFirstName()) %>" required>
                        </label>

                        <label>
                            Last name
                            <input type="text" name="lastName" value="<%= attribute(user.getLastName()) %>" required>
                        </label>

                        <label class="full-width">
                            Email address
                            <input type="email" name="email" value="<%= attribute(user.getEmail()) %>" required>
                        </label>

                        <label class="full-width">
                            Phone number
                            <input type="tel" name="phone" value="<%= attribute(user.getPhone()) %>">
                        </label>

                        <label>
                            New password
                            <input type="password" name="password" minlength="6" autocomplete="new-password">
                        </label>

                        <label>
                            Confirm new password
                            <input type="password" name="confirmPassword" minlength="6" autocomplete="new-password">
                        </label>
                    </div>

                    <label class="checkbox-label">
                        <input type="checkbox" name="active" <%= user.isActive() ? "checked" : "" %>>
                        Keep this user account active.
                    </label>

                    <button class="button button-primary" type="submit">Update user</button>
                </form>
            </section>
        </main>
    </div>
</body>
</html>
