<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.stockout.StockOut stockOut =
            (com.inventory.sims.stockout.StockOut) request.getAttribute("stockOut");
    String stockOutDate = stockOut.getStockOutDate() == null ? "" : stockOut.getStockOutDate().toString();
    String note = stockOut.getNote() == null ? "" : stockOut.getNote();
    java.util.List<com.inventory.sims.product.Product> products =
            (java.util.List<com.inventory.sims.product.Product>) request.getAttribute("products");
    java.util.List<com.inventory.sims.customer.Customer> customers =
            (java.util.List<com.inventory.sims.customer.Customer>) request.getAttribute("customers");
    String today = (String) request.getAttribute("today");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Stockout | SIMS</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: Arial, Helvetica, sans-serif; color: #172033; background: #eef2f6; }
        .layout { min-height: 100vh; display: grid; grid-template-columns: 250px 1fr; }
        .sidebar { background: #17324d; color: #ffffff; padding: 28px 22px; }
        .brand { font-size: 18px; font-weight: 700; margin-bottom: 34px; }
        .nav { display: grid; gap: 8px; }
        .nav a { display: block; padding: 12px 14px; color: #d7e4ef; text-decoration: none; border-radius: 6px; font-weight: 700; }
        .nav a:hover, .nav a.active { color: #ffffff; background: rgba(255, 255, 255, 0.12); }
        .main { padding: 32px; min-width: 0; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 18px; margin-bottom: 26px; }
        .page-title h1 { margin: 0 0 6px; font-size: 30px; color: #111827; }
        .page-title p { margin: 0; color: #64748b; line-height: 1.5; }
        .form-card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 24px; max-width: 760px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        label { display: grid; gap: 8px; font-weight: 700; color: #263548; font-size: 14px; }
        input, select, textarea { width: 100%; min-height: 46px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; color: #111827; background: #ffffff; }
        input[readonly] { background: #f1f5f9; color: #64748b; cursor: not-allowed; }
        textarea { min-height: 98px; resize: vertical; }
        input:focus, select:focus, textarea:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .full-width { grid-column: 1 / -1; }
        .hidden { display: none; }
        .actions { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin-top: 22px; }
        .button, button { min-height: 46px; border-radius: 6px; padding: 11px 16px; font: inherit; font-weight: 700; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        button { border: 0; background: #1d4ed8; color: #ffffff; }
        button:hover { background: #1e40af; }
        .button-secondary { border: 1px solid #cbd5e1; background: #ffffff; color: #334155; }
        .button-secondary:hover { background: #f8fafc; }
        .alert { margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; border: 1px solid #fecaca; color: #991b1b; background: #fef2f2; font-size: 14px; font-weight: 700; }
        .alert:empty { display: none; }

        @media (max-width: 820px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 20px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px; }
            .topbar { align-items: flex-start; flex-direction: column; }
            .form-grid { grid-template-columns: 1fr; }
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
            <a href="/stockout" class="active">Stock Out</a>
            <a href="/alerts">Alerts</a>
            <a href="/users">Users</a>
        </nav>
    </aside>

    <main class="main">
        <header class="topbar">
            <div class="page-title">
                <h1>Update Stockout</h1>
                <p>Edit stockout record <strong><%= stockOut.getId() %></strong>.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/stockout">Back to records</a>
            </div>
        </header>

        <section class="form-card" aria-label="Update stockout form">
            <div class="alert">${message}</div>

            <form action="/stockout/update/<%= stockOut.getId() %>" method="post">
                <div class="form-grid">
                    <label>
                        Stockout ID
                        <input type="text" value="<%= stockOut.getId() %>" readonly>
                    </label>

                    <label class="full-width">
                        Product
                        <select id="productId" name="productId" required>
                            <option value="">Select product</option>
                            <%
                                if (products != null) {
                                    for (com.inventory.sims.product.Product product : products) {
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
                            <option value="<%= product.getId() %>"
                                    data-product-type="<%= productType %>"
                                    data-expiration-date="<%= expirationDate %>"
                                    data-warranty-months="<%= warrantyMonths %>"
                                    data-available-quantity="<%= product.getQuantity() %>"
                                    <%= product.getId().equals(stockOut.getProductId()) ? "selected" : "" %>>
                                <%= product.getName() %> (Available: <%= product.getQuantity() %>)
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </label>

                    <label id="expirationDateGroup" class="hidden">
                        Expiration date
                        <input type="text" id="expirationDateDisplay" readonly>
                    </label>

                    <label id="warrantyMonthsGroup" class="hidden">
                        Warranty
                        <input type="text" id="warrantyMonthsDisplay" readonly>
                    </label>

                    <label>
                        Quantity
                        <input type="number" id="quantity" name="quantity" min="1" step="1" value="<%= stockOut.getQuantity() %>" required>
                    </label>

                    <label>
                        Unit price (LKR)
                        <input type="number" name="unitPrice" min="0" step="0.01" value="<%= stockOut.getUnitPrice() %>" required>
                    </label>

                    <label>
                        Stockout date
                        <input type="date" name="stockOutDate" value="<%= stockOutDate %>" min="<%= today == null ? "" : today %>">
                    </label>

                    <label>
                        Issued to
                        <select name="issuedTo" required>
                            <option value="">Select customer</option>
                            <%
                                if (customers != null) {
                                    for (com.inventory.sims.customer.Customer customer : customers) {
                                        boolean selectedCustomer = customer.getId().equals(stockOut.getIssuedTo())
                                                || customer.getName().equals(stockOut.getIssuedTo());
                            %>
                            <option value="<%= customer.getId() %>" <%= selectedCustomer ? "selected" : "" %>>
                                <%= customer.getName() %> (<%= customer.getId() %>)
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </label>

                    <label>
                        Reason
                        <select name="reason" required>
                            <option value="">Select reason</option>
                            <option value="Sale" <%= "Sale".equals(stockOut.getReason()) ? "selected" : "" %>>Sale</option>
                            <option value="Internal use" <%= "Internal use".equals(stockOut.getReason()) ? "selected" : "" %>>Internal use</option>
                            <option value="Damaged item" <%= "Damaged item".equals(stockOut.getReason()) ? "selected" : "" %>>Damaged item</option>
                            <option value="Returned to supplier" <%= "Returned to supplier".equals(stockOut.getReason()) ? "selected" : "" %>>Returned to supplier</option>
                            <option value="Other" <%= "Other".equals(stockOut.getReason()) ? "selected" : "" %>>Other</option>
                        </select>
                    </label>

                    <label class="full-width">
                        Note
                        <textarea name="note"><%= note %></textarea>
                    </label>
                </div>

                <div class="actions">
                    <button type="submit">Update stockout</button>
                    <a class="button button-secondary" href="/stockout">Cancel</a>
                </div>
            </form>
        </section>
    </main>
</div>
<script>
    const productSelect = document.getElementById("productId");
    const quantityInput = document.getElementById("quantity");
    const expirationGroup = document.getElementById("expirationDateGroup");
    const expirationDisplay = document.getElementById("expirationDateDisplay");
    const warrantyGroup = document.getElementById("warrantyMonthsGroup");
    const warrantyDisplay = document.getElementById("warrantyMonthsDisplay");

    function showSelectedProductDetails() {
        const selectedOption = productSelect.options[productSelect.selectedIndex];
        const productType = selectedOption ? selectedOption.dataset.productType : "";

        expirationGroup.classList.add("hidden");
        warrantyGroup.classList.add("hidden");
        expirationDisplay.value = "";
        warrantyDisplay.value = "";
        quantityInput.removeAttribute("max");

        if (productType === "Food") {
            expirationDisplay.value = selectedOption.dataset.expirationDate || "Not set";
            expirationGroup.classList.remove("hidden");
        } else if (productType === "Electronics") {
            warrantyDisplay.value = (selectedOption.dataset.warrantyMonths || "0") + " months";
            warrantyGroup.classList.remove("hidden");
        }

        if (selectedOption && selectedOption.dataset.availableQuantity) {
            quantityInput.max = selectedOption.dataset.availableQuantity;
            if (Number(quantityInput.value) > Number(selectedOption.dataset.availableQuantity)) {
                quantityInput.value = selectedOption.dataset.availableQuantity;
            }
        }
    }

    productSelect.addEventListener("change", showSelectedProductDetails);
    showSelectedProductDetails();
</script>
</body>
</html>
