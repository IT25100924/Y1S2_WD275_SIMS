<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.stockin.StockIn stockIn =
            (com.inventory.sims.stockin.StockIn) request.getAttribute("stockIn");
    java.util.List<com.inventory.sims.product.Product> products =
            (java.util.List<com.inventory.sims.product.Product>) request.getAttribute("products");
    java.util.List<com.inventory.sims.supplier.Supplier> suppliers =
            (java.util.List<com.inventory.sims.supplier.Supplier>) request.getAttribute("suppliers");
    String error = (String) request.getAttribute("error");
    String today = (String) request.getAttribute("today");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Stock In | SIMS</title>
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
        .button-primary { background: #1d4ed8; color: #ffffff; width: 100%; margin-top: 6px; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #ffffff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .form-card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 24px; max-width: 760px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: grid; gap: 8px; margin-bottom: 18px; }
        .full-width { grid-column: 1 / -1; }
        .form-group label { font-weight: 700; color: #334155; font-size: 14px; }
        .form-control { width: 100%; min-height: 42px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; background: #ffffff; }
        textarea.form-control { min-height: 96px; resize: vertical; }
        .form-control:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .form-control[readonly] { background-color: #f1f5f9; cursor: not-allowed; color: #64748b; }
        .hidden { display: none; }
        .alert { margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; font-size: 14px; font-weight: 700; }
        .alert-error { color: #991b1b; background: #fee2e2; border: 1px solid #fecaca; }

        @media (max-width: 900px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 18px; }
            .brand { margin-bottom: 16px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px 18px; }
            .topbar { align-items: stretch; flex-direction: column; }
            .form-grid { grid-template-columns: 1fr; }
            .actions, .button-secondary { width: 100%; }
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
            <a href="/stockin" class="active">Stock In</a>
            <a href="/stockout">Stock Out</a>
            <a href="/alerts">Alerts</a>
            <a href="/users">Users</a>
        </nav>
    </aside>

    <main class="main">
        <header class="topbar">
            <div class="page-title">
                <h1>Edit Stock In</h1>
                <p>Update stock-in record <%= stockIn.getId() %>.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/stockin/view">Cancel</a>
            </div>
        </header>

        <% if (error != null && !error.isBlank()) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <section class="form-card" aria-label="Edit stock in form">
            <form action="/stockin/edit/<%= stockIn.getId() %>" method="post">
                <div class="form-group full-width">
                    <label for="stockInId">Stock In ID</label>
                    <input type="text" id="stockInId" class="form-control" value="<%= stockIn.getId() %>" readonly>
                </div>

                <div class="form-group full-width">
                    <label for="productId">Product</label>
                    <select id="productId" name="productId" class="form-control" required>
                        <option value="">Select product</option>
                        <%
                            if (products != null) {
                                for (com.inventory.sims.product.Product product : products) {
                                    String selected = product.getId().equals(stockIn.getProductId()) ? "selected" : "";
                                    String productType = "General";
                                    String expirationDate = "";
                                    int warrantyMonths = 0;
                                    if (product instanceof com.inventory.sims.product.FoodProduct) {
                                        productType = "Food";
                                        expirationDate = ((com.inventory.sims.product.FoodProduct) product).getExpirationDate();
                                        if (expirationDate == null) {
                                            expirationDate = "";
                                        }
                                    } else if (product instanceof com.inventory.sims.product.ElectronicsProduct) {
                                        productType = "Electronics";
                                        warrantyMonths = ((com.inventory.sims.product.ElectronicsProduct) product).getWarrantyMonths();
                                    }
                        %>
                        <option value="<%= product.getId() %>" <%= selected %>
                                data-product-type="<%= productType %>"
                                data-expiration-date="<%= expirationDate %>"
                                data-warranty-months="<%= warrantyMonths %>">
                            <%= product.getId() %> - <%= product.getName() %> (Current: <%= product.getQuantity() %>)
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="supplierId">Supplier</label>
                        <select id="supplierId" name="supplierId" class="form-control" required>
                            <option value="">Select supplier</option>
                            <%
                                if (suppliers != null) {
                                    for (com.inventory.sims.supplier.Supplier supplier : suppliers) {
                                        String selected = supplier.getCompanyName().equals(stockIn.getSupplierName()) ? "selected" : "";
                            %>
                            <option value="<%= supplier.getId() %>" <%= selected %>>
                                <%= supplier.getId() %> - <%= supplier.getCompanyName() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="receivedDate">Received Date</label>
                        <input type="date" id="receivedDate" name="receivedDate" class="form-control" value="<%= stockIn.getReceivedDate() %>" min="<%= today == null ? "" : today %>" required>
                    </div>

                    <div class="form-group">
                        <label for="quantity">Quantity In</label>
                        <input type="number" id="quantity" name="quantity" class="form-control" min="1" required value="<%= stockIn.getQuantity() %>">
                    </div>

                    <div class="form-group">
                        <label for="unitCost">Unit Cost (LKR)</label>
                        <input type="number" id="unitCost" name="unitCost" class="form-control" step="0.01" min="0" required value="<%= stockIn.getUnitCost() %>">
                    </div>

                    <div class="form-group hidden" id="expirationDateGroup">
                        <label for="expirationDate">Expiration Date</label>
                        <input type="date" id="expirationDate" name="expirationDate" class="form-control" min="<%= today == null ? "" : today %>" value="<%= stockIn.getExpirationDate() == null ? "" : stockIn.getExpirationDate() %>">
                    </div>

                    <div class="form-group hidden" id="warrantyMonthsGroup">
                        <label for="warrantyMonths">Warranty (Months)</label>
                        <input type="number" id="warrantyMonths" name="warrantyMonths" class="form-control" min="0" value="<%= stockIn.getWarrantyMonths() %>">
                    </div>

                    <div class="form-group full-width">
                        <label for="note">Note</label>
                        <textarea id="note" name="note" class="form-control"><%= stockIn.getNote() == null ? "" : stockIn.getNote() %></textarea>
                    </div>
                </div>

                <button type="submit" class="button button-primary">Update Stock In</button>
            </form>
        </section>
    </main>
</div>
<script>
    const productSelect = document.getElementById("productId");
    const receivedDateInput = document.getElementById("receivedDate");
    const expirationGroup = document.getElementById("expirationDateGroup");
    const expirationInput = document.getElementById("expirationDate");
    const warrantyGroup = document.getElementById("warrantyMonthsGroup");
    const warrantyInput = document.getElementById("warrantyMonths");
    const initialProductId = "<%= stockIn.getProductId() %>";
    const initialExpirationDate = "<%= stockIn.getExpirationDate() == null ? "" : stockIn.getExpirationDate() %>";
    const initialWarrantyMonths = "<%= stockIn.getWarrantyMonths() %>";

    function toggleProductDetails() {
        const selectedOption = productSelect.options[productSelect.selectedIndex];
        const productType = selectedOption ? selectedOption.dataset.productType : "";

        expirationGroup.classList.add("hidden");
        warrantyGroup.classList.add("hidden");
        expirationInput.required = false;
        warrantyInput.required = false;
        expirationInput.value = "";
        warrantyInput.value = "";

        if (productType === "Food") {
            expirationGroup.classList.remove("hidden");
            expirationInput.required = true;
            expirationInput.min = receivedDateInput.value || "<%= today == null ? "" : today %>";
            expirationInput.value = selectedOption.value === initialProductId
                    ? (initialExpirationDate || selectedOption.dataset.expirationDate || "")
                    : (selectedOption.dataset.expirationDate || "");
        } else if (productType === "Electronics") {
            warrantyGroup.classList.remove("hidden");
            warrantyInput.required = true;
            warrantyInput.value = selectedOption.value === initialProductId
                    ? (initialWarrantyMonths !== "0" ? initialWarrantyMonths : (selectedOption.dataset.warrantyMonths || ""))
                    : (selectedOption.dataset.warrantyMonths || "");
        }
    }

    productSelect.addEventListener("change", toggleProductDetails);
    receivedDateInput.addEventListener("change", function () {
        expirationInput.min = receivedDateInput.value || "<%= today == null ? "" : today %>";
    });
    toggleProductDetails();
</script>
</body>
</html>
