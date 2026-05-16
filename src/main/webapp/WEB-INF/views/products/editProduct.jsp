<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // Safely extract the product and its specific fields using Polymorphism
    com.inventory.sims.product.Product p = (com.inventory.sims.product.Product) request.getAttribute("product");
    String typeStr = p.getClass().getSimpleName();
    int warranty = 0;
    String expiration = "";

    if (p instanceof com.inventory.sims.product.ElectronicsProduct) {
        warranty = ((com.inventory.sims.product.ElectronicsProduct) p).getWarrantyMonths();
    } else if (p instanceof com.inventory.sims.product.FoodProduct) {
        expiration = ((com.inventory.sims.product.FoodProduct) p).getExpirationDate();
        if (expiration == null) expiration = "";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product | SIMS</title>
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

        .form-card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 24px; max-width: 600px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 700; color: #334155; font-size: 14px; }
        .form-control { width: 100%; min-height: 42px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; }
        .form-control:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .form-control[readonly] { background-color: #f1f5f9; cursor: not-allowed; color: #64748b; }

        .button { min-height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid transparent; padding: 10px 14px; font: inherit; font-weight: 700; text-decoration: none; cursor: pointer; }
        .button-primary { background: #1d4ed8; color: #ffffff; width: 100%; margin-top: 10px; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #ffffff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }

        .hidden { display: none; }
    </style>
</head>
<body onload="toggleFields()">
<div class="layout">
    <aside class="sidebar">
        <div class="brand">SIMS</div>
        <nav class="nav">
            <a href="/dashboard">Dashboard</a>
            <a href="/products" class="active">Products</a>
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
                <h1>Edit Product</h1>
                <p>Update the details for item: <%= p.getName() %></p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/products">Cancel</a>
            </div>
        </header>

        <div class="form-card">
            <form action="/products/edit/<%= p.getId() %>" method="post" id="productForm">
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; border: 1px solid #fecaca; color: #b91c1c; background: #fef2f2; font-weight: bold;">
                    <%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>
                <div class="form-group">
                    <label for="type">Product Type</label>
                    <select id="type" name="type" class="form-control" onchange="toggleFields()">
                        <option value="General" <%= "Product".equals(typeStr) ? "selected" : "" %>>Standard Product</option>
                        <option value="Electronics" <%= "ElectronicsProduct".equals(typeStr) ? "selected" : "" %>>Electronics Product</option>
                        <option value="Food" <%= "FoodProduct".equals(typeStr) ? "selected" : "" %>>Food Product</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="id">Product ID</label>
                    <input type="text" id="id" class="form-control" value="<%= p.getId() %>" disabled>
                </div>

                <div class="form-group">
                    <label for="supplierIdDisplay">Supplier</label>
                    <!-- Disabled select so it's grayed out and unchangeable -->
                    <select id="supplierIdDisplay" class="form-control" disabled>
                        <%
                            java.util.List<com.inventory.sims.supplier.Supplier> editSuppliers = (java.util.List<com.inventory.sims.supplier.Supplier>) request.getAttribute("suppliers");
                            if (editSuppliers != null) {
                                for(com.inventory.sims.supplier.Supplier s : editSuppliers) {
                        %>
                        <option value="<%= s.getId() %>" <%= s.getId().equals(p.getSupplierId()) ? "selected" : "" %>><%= s.getId() %> - <%= s.getCompanyName() %></option>
                        <%      }
                        }
                        %>
                    </select>
                    <!-- Hidden input to submit the actual supplier value since disabled inputs don't submit -->
                    <input type="hidden" name="supplierId" value="<%= p.getSupplierId() %>">
                </div>

                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" class="form-control" required value="<%= p.getName() %>">
                </div>

                <div class="form-group">
                    <label for="price">Unit Price (LKR)</label>
                    <input type="number" id="price" name="price" class="form-control" step="0.01" min="0" value="<%= p.getPrice() %>">
                </div>

                <div class="form-group">
                    <label for="quantity">Initial Quantity</label>
                    <input type="number" id="quantity" name="quantity" class="form-control" min="0" value="<%= p.getQuantity() %>">
                </div>

                <div class="form-group hidden" id="warrantyGroup">
                    <label for="warrantyMonths">Warranty (Months)</label>
                    <input type="number" id="warrantyMonths" name="warrantyMonths" class="form-control" min="0" value="<%= warranty %>">
                </div>

                <div class="form-group hidden" id="expirationGroup">
                    <label for="expirationDate">Expiration Date</label>
                    <input type="date" id="expirationDate" name="expirationDate" class="form-control" value="<%= expiration %>">
                </div>

                <button type="submit" class="button button-primary">Update Product</button>
            </form>
        </div>
    </main>
</div>

<script>
    function toggleFields() {
        const type = document.getElementById("type").value;
        const warrantyGroup = document.getElementById("warrantyGroup");
        const expirationGroup = document.getElementById("expirationGroup");

        warrantyGroup.classList.add("hidden");
        expirationGroup.classList.add("hidden");

        if (type === "Electronics") {
            warrantyGroup.classList.remove("hidden");
        } else if (type === "Food") {
            expirationGroup.classList.remove("hidden");
        }
    }
</script>
</body>
</html>
