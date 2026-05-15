<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products | SIMS</title>
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

        /* Summary Cards CSS */
        .summary-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .summary-card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 18px; }
        .summary-card span { display: block; color: #64748b; font-size: 14px; margin-bottom: 10px; font-weight: bold; }
        .summary-card strong { display: block; color: #111827; font-size: 28px; }

        /* Search Bar CSS */
        .toolbar { display: flex; align-items: center; justify-content: space-between; gap: 16px; background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px 8px 0 0; padding: 16px; }
        .search { display: flex; width: min(100%, 460px); gap: 10px; }
        .search input { width: 100%; min-height: 42px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; }
        .search input:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }

        /* Table CSS */
        .table-wrap { overflow-x: auto; background: #ffffff; border: 1px solid #d9e1ea; border-top: 0; border-radius: 0 0 8px 8px; }
        table { width: 100%; border-collapse: collapse; min-width: 900px; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: middle; }
        th { color: #475569; background: #f8fafc; font-size: 13px; text-transform: uppercase; }
        tbody tr:hover { background: #f8fafc; }
        tbody tr:last-child td { border-bottom: 0; }
        .table-actions { display: flex; gap: 8px; }
        .table-actions a { min-height: 34px; border: 1px solid #cbd5e1; border-radius: 6px; background: #ffffff; color: #334155; padding: 7px 10px; font: inherit; font-size: 14px; text-decoration: none; cursor: pointer; }
        .table-actions a:hover { background: #f8fafc; }

        /* Dynamic Badge & Row Colors */
        .badge { display: inline-flex; align-items: center; min-height: 28px; padding: 4px 10px; border-radius: 999px; font-size: 13px; font-weight: 700; }
        .badge-electronics { background: #f3e8ff; color: #7e22ce; }
        .badge-food { background: #dcfce7; color: #166534; }
        .badge-general { background: #e0f2fe; color: #075985; }
        .low-stock { background-color: #fef2f2 !important; }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">SIMS</div>
        <nav class="nav" aria-label="Main navigation">
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
                <h1>Products</h1>
                <p>Manage your inventory items and details.</p>
            </div>
            <div class="actions">
                <a class="button button-primary" href="/products/add">Add Product</a>
            </div>
        </header>

        <section class="summary-grid" aria-label="Product summary">
            <div class="summary-card" style="border-left: 4px solid #075985;">
                <span>Total Products</span>
                <strong><%= request.getAttribute("totalProducts") %></strong>
            </div>
            <div class="summary-card" style="border-left: 4px solid #7e22ce;">
                <span>Electronics</span>
                <strong><%= request.getAttribute("electronicsCount") %></strong>
            </div>
            <div class="summary-card" style="border-left: 4px solid #166534;">
                <span>Food Items</span>
                <strong><%= request.getAttribute("foodCount") %></strong>
            </div>
            <div class="summary-card" style="border-left: 4px solid #b91c1c;">
                <span style="color: #b91c1c;">Low Stock Alert</span>
                <strong style="color: #b91c1c;"><%= request.getAttribute("lowStockCount") %></strong>
            </div>
        </section>

        <section aria-label="Products table">
            <div class="toolbar">
                <div class="search">
                    <input type="search" id="searchInput" placeholder="Search by Product Name or ID..." onkeyup="filterTable()">
                </div>
            </div>

            <div class="table-wrap">
                <table id="productTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Supplier ID</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Unit Price (LKR)</th>
                        <th>Initial Quantity</th>
                        <th>Special Details</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        java.util.List<com.inventory.sims.product.Product> productList = (java.util.List<com.inventory.sims.product.Product>) request.getAttribute("products");
                        if (productList != null && !productList.isEmpty()) {
                            for (com.inventory.sims.product.Product product : productList) {
                                // Polymorphism at work: Determine the badge color and extra details based on the object's actual class
                                String typeBadgeClass = "badge-general";
                                String extraDetails = "-";

                                if (product instanceof com.inventory.sims.product.ElectronicsProduct) {
                                    typeBadgeClass = "badge-electronics";
                                    extraDetails = "Warranty: " + ((com.inventory.sims.product.ElectronicsProduct) product).getWarrantyMonths() + " months";
                                } else if (product instanceof com.inventory.sims.product.FoodProduct) {
                                    typeBadgeClass = "badge-food";
                                    String exp = ((com.inventory.sims.product.FoodProduct) product).getExpirationDate();
                                    extraDetails = "Initial Expiry: " + (exp != null && !exp.isEmpty() ? exp : "N/A");
                                }

                                boolean isLowStock = product.getQuantity() <= 5;
                    %>
                    <tr class="<%= isLowStock ? "low-stock" : "" %>">
                        <td><%= product.getId() %></td>
                        <td><span class="badge" style="background:#eef2f6; color:#475569;"><%= product.getSupplierId() %></span></td>
                        <td><%= product.getName() %></td>
                        <td><span class="badge <%= typeBadgeClass %>"><%= product.getClass().getSimpleName() %></span></td>
                        <!-- $ sign removed! -->
                        <td><%= String.format("%.2f", product.getPrice()) %></td>
                        <td><%= product.getQuantity() %></td>
                        <td style="color: #64748b; font-size: 13px; font-weight: bold;"><%= extraDetails %></td>
                        <td>
                            <div class="table-actions">
                                <a href="/products/edit/<%= product.getId() %>">Edit</a>
                                <a href="/products/delete/<%= product.getId() %>" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 20px; color: #64748b;">No products found. Click "Add Product" to create one!</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<script>
    function filterTable() {
        let input = document.getElementById("searchInput");
        let filter = input.value.toUpperCase();
        let table = document.getElementById("productTable");
        let tr = table.getElementsByTagName("tr");

        for (let i = 1; i < tr.length; i++) {
            let tdId = tr[i].getElementsByTagName("td")[0];
            let tdName = tr[i].getElementsByTagName("td")[2];

            if (tdId || tdName) {
                let txtValueId = tdId.textContent || tdId.innerText;
                let txtValueName = tdName.textContent || tdName.innerText;

                if (txtValueId.toUpperCase().indexOf(filter) > -1 || txtValueName.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }
</script>
</body>
</html>
