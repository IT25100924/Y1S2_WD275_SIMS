<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.sims.user.User" %>
<%!
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }
        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String firstLetter(String value) {
        if (value == null || value.isBlank()) {
            return "";
        }
        return escapeHtml(value.trim().substring(0, 1).toUpperCase());
    }
%>
<%
    String pageTitle = request.getParameter("pageTitle");
    if (pageTitle == null || pageTitle.isEmpty()) pageTitle = "InventoryPro";
    
    String activeMenu = request.getParameter("activeMenu");
    if (activeMenu == null) activeMenu = "";

    User loggedUser = (User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> | InventoryPro</title>
    <!-- Google Fonts: Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Phosphor Icons -->
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --primary: #6366F1;
            --primary-hover: #4f46e5;
            --secondary: #06B6D4;
            --tertiary: #F59E0B;
            --neutral: #64748B;
            --neutral-dark: #1e293b;
            --bg-main: #f8fafc;
            --bg-sidebar: #f1f5f9;
            --card-bg: #ffffff;
            --border-color: #e2e8f0;
            --text-main: #0f172a;
            --text-muted: #64748B;
            --danger: #ef4444;
            --danger-bg: #fef2f2;
            --success: #10b981;
            --success-bg: #ecfdf5;
            --warning: #f59e0b;
            --warning-bg: #fffbeb;
            --info: #3b82f6;
            --info-bg: #eff6ff;
            --gradient-start: #eef2ff;
            --gradient-end: #ecfeff;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-main);
            color: var(--text-main);
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background-color: var(--bg-sidebar);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            padding: 24px 16px;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 100;
        }

        .brand {
            margin-bottom: 32px;
            padding: 12px 16px;
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            display: flex;
            align-items: center;
            gap: 14px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.02);
            transition: all 0.2s ease;
            text-decoration: none; /* In case it becomes a link */
        }

        .brand:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(99, 102, 241, 0.08);
            border-color: rgba(99, 102, 241, 0.2);
        }

        .brand-logo {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            object-fit: cover;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.15);
        }

        .brand-text {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .brand-text h2 {
            color: var(--primary);
            font-size: 22px;
            font-weight: 800;
            line-height: 1;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
        }

        .nav-menu {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex-grow: 1;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            text-decoration: none;
            color: var(--text-muted);
            font-weight: 500;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            background-color: rgba(99, 102, 241, 0.05);
            color: var(--primary);
        }

        .nav-link.active {
            background-color: var(--primary);
            color: white;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .nav-link i {
            font-size: 20px;
        }

        .nav-bottom {
            margin-top: auto;
            border-top: 1px solid var(--border-color);
            padding-top: 24px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        /* Main Content */
        .main-content, .main {
            flex-grow: 1;
            margin-left: 260px;
            padding: 40px;
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 12px 0 12px;
            border-top: 1px solid var(--border-color);
            margin-top: 16px;
            cursor: pointer;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--neutral-dark);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

        .user-info h4 {
            font-size: 14px;
            font-weight: 600;
        }

        .user-info p {
            font-size: 12px;
            color: var(--text-muted);
        }

        /* GLOBALS for internal pages */
        .page-title h1 {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 4px;
        }
        
        .page-title p {
            font-size: 14px;
            color: var(--text-muted);
        }

        .actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .button, .btn-primary {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-family: 'Outfit', sans-serif;
            font-weight: 600;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
        }

        .button:hover, .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .button-secondary {
            background-color: var(--card-bg);
            color: var(--text-main);
            border: 1px solid var(--border-color);
            box-shadow: none;
        }
        
        .button-secondary:hover {
            background-color: var(--bg-main);
            transform: translateY(-1px);
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .summary-card {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
            border: 1px solid var(--border-color);
        }

        .summary-card span {
            display: block;
            color: var(--text-muted);
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .summary-card strong {
            display: block;
            color: var(--text-main);
            font-size: 32px;
            font-weight: 700;
        }

        /* Toolbar / Table controls */
        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: var(--card-bg);
            padding: 20px;
            border-radius: 16px 16px 0 0;
            border: 1px solid var(--border-color);
            border-bottom: none;
            gap: 16px;
        }

        .search {
            position: relative;
            display: flex;
            align-items: center;
            width: 100%;
            max-width: 500px;
            gap: 12px;
        }

        .search-icon {
            position: absolute;
            left: 18px;
            color: var(--text-muted);
            font-size: 18px;
            pointer-events: none;
            transition: color 0.3s ease;
        }

        .search input {
            width: 100%;
            padding: 12px 20px 12px 48px !important;
            border-radius: 30px;
            border: 1px solid var(--border-color);
            background-color: var(--bg-sidebar);
            font-family: 'Outfit', sans-serif;
            font-size: 14px;
            color: var(--text-main);
            outline: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .search input:hover {
            border-color: #cbd5e1;
            background-color: var(--card-bg);
        }

        .search input:focus {
            border-color: var(--primary);
            background-color: var(--card-bg);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.15);
            transform: translateY(-1px);
        }

        .search input:focus + .search-icon, .search input:focus ~ .search-icon {
            color: var(--primary);
        }

        /* Tables */
        .table-wrap {
            overflow-x: auto;
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 0 0 16px 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            background-color: var(--bg-main);
            padding: 16px 20px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid var(--border-color);
            border-top: 1px solid var(--border-color);
        }

        td {
            padding: 16px 20px;
            font-size: 14px;
            color: var(--text-main);
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        tbody tr {
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background-color: rgba(99, 102, 241, 0.02);
        }

        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-admin { background-color: var(--danger-bg); color: var(--danger); }
        .badge-staff { background-color: var(--info-bg); color: var(--info); }
        .badge-electronics { background-color: #f3e8ff; color: #7e22ce; }

        /* Detail Cards & Grid */
        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }

        @media (max-width: 900px) {
            .grid {
                grid-template-columns: 1fr;
            }
        }

        .card {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 32px;
            border: 1px solid var(--border-color);
        }

        .card h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-main);
            margin: 0 0 16px 0;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border-color);
        }

        /* Hero Section for Details Pages */
        .hero {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 24px;
            border: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .hero h2 {
            font-size: 28px;
            color: var(--text-main);
            margin: 0;
        }
        
        .hero p {
            color: var(--text-muted);
            font-size: 15px;
            margin: 0;
        }
        
        .hero-meta {
            display: flex;
            gap: 12px;
            margin-top: 8px;
            align-items: center;
        }

        /* Detail List */
        .detail-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
            margin-top: 16px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .detail-item span {
            font-size: 13px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .detail-item strong, .detail-item p {
            font-size: 15px;
            color: var(--text-main);
            font-weight: 500;
            margin: 0;
        }

        /* Badge additions */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.3px;
            text-transform: uppercase;
        }
        .badge-active { background: var(--success-bg); color: var(--success); }
        .badge-inactive { background: var(--danger-bg); color: var(--danger); }
        
        .user-cell { display: flex; align-items: center; gap: 14px; }
        .avatar { width: 42px; height: 42px; border-radius: 50%; background: linear-gradient(135deg, var(--info), var(--primary)); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 16px; flex-shrink: 0; box-shadow: 0 4px 10px rgba(99, 102, 241, 0.2); text-transform: uppercase; }
        .user-name { font-weight: 600; color: var(--text-main); display: block; margin-bottom: 2px; font-size: 14px; }
        .user-email { font-size: 13px; color: var(--text-muted); display: block; }

        /* Row Actions */
        .row-actions, .table-actions {
            display: flex;
            gap: 8px;
        }

        .row-actions a, .table-actions a,
        .row-actions button, .table-actions button {
            width: 36px;
            height: 36px;
            padding: 0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
            font-family: 'Outfit', sans-serif;
            text-decoration: none;
        }

        .row-actions a, .table-actions a {
            background-color: #dbeafe;
            color: #2563eb;
        }

        .row-actions a:hover, .table-actions a:hover {
            background-color: #2563eb;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2);
        }

        .row-actions a[title="Edit"], .table-actions a[title="Edit"] {
            background-color: #fef3c7;
            color: #d97706;
        }

        .row-actions a[title="Edit"]:hover, .table-actions a[title="Edit"]:hover {
            background-color: #d97706;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(217, 119, 6, 0.2);
        }

        .row-actions button, .table-actions button {
            background-color: #fee2e2;
            color: #dc2626;
        }
        
        .row-actions button:hover, .table-actions button:hover {
            background-color: #dc2626;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(220, 38, 38, 0.2);
        }

        /* Form elements */
        form { margin: 0; }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            font-size: 14px;
            color: var(--text-main);
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-family: 'Outfit', sans-serif;
            font-size: 14px;
            outline: none;
            transition: all 0.2s ease;
        }
        
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .card {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
            border: 1px solid var(--border-color);
        }

        .form-card {
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
            border: 1px solid var(--border-color);
            max-width: 600px;
        }

        .message {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-weight: 500;
        }
        
        .message-success {
            background-color: var(--success-bg);
            color: var(--success);
            border: 1px solid #a7f3d0;
        }

        .message-error {
            background-color: var(--danger-bg);
            color: var(--danger);
            border: 1px solid #fecaca;
        }
        
        .hidden {
            display: none !important;
        }

        .flash {
            padding: 16px;
            border-radius: 8px;
            background-color: var(--success-bg);
            color: var(--success);
            border: 1px solid #a7f3d0;
            margin-bottom: 24px;
            font-weight: 500;
        }

        /* Page Header wrapper for subpages */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .page-header .page-title h1 {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 4px;
        }

        .page-header .page-title p {
            font-size: 14px;
            color: var(--text-muted);
        }

        @media (max-width: 1024px) {
            .metrics-grid, .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

    </style>
</head>
<body>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <img src="/images/logo.jpg" alt="SIMS Logo" class="brand-logo">
            <div class="brand-text">
                <h2>SIMS</h2>
            </div>
        </div>
        
        <nav class="nav-menu">
            <a href="/dashboard" class="nav-link <%= activeMenu.equals("dashboard") ? "active" : "" %>">
                <i class="ph ph-squares-four"></i> Dashboard
            </a>
            <a href="/users" class="nav-link <%= activeMenu.equals("users") ? "active" : "" %>">
                <i class="ph ph-users"></i> Users
            </a>
            <a href="/products" class="nav-link <%= activeMenu.equals("products") ? "active" : "" %>">
                <i class="ph ph-package"></i> Products
            </a>
            <a href="/suppliers" class="nav-link <%= activeMenu.equals("suppliers") ? "active" : "" %>">
                <i class="ph ph-truck"></i> Suppliers
            </a>
            <a href="/stockin" class="nav-link <%= activeMenu.equals("stockin") ? "active" : "" %>">
                <i class="ph ph-arrow-square-in"></i> Stock-in
            </a>
            <a href="/stockout" class="nav-link <%= activeMenu.equals("stockout") ? "active" : "" %>">
                <i class="ph ph-arrow-square-out"></i> Stock-out
            </a>
            <a href="/customers" class="nav-link <%= activeMenu.equals("customers") ? "active" : "" %>">
                <i class="ph ph-user-circle"></i> Customers
            </a>
        </nav>

        <div class="nav-bottom">
            <a href="/users/logout" class="nav-link">
                <i class="ph ph-sign-out"></i> Logout
            </a>
            <% if (loggedUser != null) { %>
            <div class="user-profile">
                <div class="user-avatar"><%= firstLetter(loggedUser.getFirstName()) %><%= firstLetter(loggedUser.getLastName()) %></div>
                <div class="user-info">
                    <h4><%= escapeHtml(loggedUser.getFirstName()) %> <%= escapeHtml(loggedUser.getLastName()) %></h4>
                    <p><%= escapeHtml(loggedUser.getRole()) %></p>
                </div>
            </div>
            <% } %>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
