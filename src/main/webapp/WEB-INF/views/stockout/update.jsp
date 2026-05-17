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
    String message = (String) request.getAttribute("message");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Update Stock Out | Stock Out" />
    <jsp:param name="activeMenu" value="stockout" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Update Stock Out</h1>
                <p>Edit stock out record <%= stockOut.getId() %>.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/stockout">Cancel</a>
            </div>
        </header>

        <% if (message != null && !message.isBlank()) { %>
        <div class="alert alert-error"><%= message %></div>
        <% } %>

        <div class="content-grid">
            <section class="form-card" aria-label="Update stock out form">
                <form action="/stockout/update/<%= stockOut.getId() %>" method="post">
                    <div class="form-group full-width">
                        <label for="stockOutId">Stock Out ID</label>
                        <input type="text" id="stockOutId" class="form-control" value="<%= stockOut.getId() %>" readonly style="background-color: #f8fafc; cursor: not-allowed; color: #64748b;">
                    </div>

                    <div class="form-group full-width">
                        <label for="productId">Product</label>
                        <select id="productId" name="productId" class="form-control" required onchange="showSelectedProductDetails()">
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
                                <%= product.getId() %> - <%= product.getName() %> (Available: <%= product.getQuantity() %>)
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="issuedTo">Issued To</label>
                            <select id="issuedTo" name="issuedTo" class="form-control" required>
                                <option value="">Select customer</option>
                                <%
                                    if (customers != null) {
                                        for (com.inventory.sims.customer.Customer customer : customers) {
                                            boolean selectedCustomer = customer.getId().equals(stockOut.getIssuedTo())
                                                    || customer.getName().equals(stockOut.getIssuedTo());
                                %>
                                <option value="<%= customer.getId() %>" <%= selectedCustomer ? "selected" : "" %>>
                                    <%= customer.getId() %> - <%= customer.getName() %>
                                </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="stockOutDate">Stock Out Date</label>
                            <input type="date" id="stockOutDate" name="stockOutDate" class="form-control" value="<%= stockOutDate %>" min="<%= today == null ? "" : today %>" required>
                        </div>

                        <div class="form-group">
                            <label for="quantity">Quantity Out</label>
                            <input type="number" id="quantity" name="quantity" class="form-control" min="1" step="1" value="<%= stockOut.getQuantity() %>" required>
                        </div>

                        <div class="form-group">
                            <label for="unitPrice">Unit Price (LKR)</label>
                            <input type="number" id="unitPrice" name="unitPrice" class="form-control" step="0.01" min="0" value="<%= stockOut.getUnitPrice() %>" required>
                        </div>

                        <div class="form-group">
                            <label for="reason">Reason</label>
                            <select id="reason" name="reason" class="form-control" required>
                                <option value="">Select reason</option>
                                <option value="Sale" <%= "Sale".equals(stockOut.getReason()) ? "selected" : "" %>>Sale</option>
                                <option value="Internal use" <%= "Internal use".equals(stockOut.getReason()) ? "selected" : "" %>>Internal use</option>
                                <option value="Damaged item" <%= "Damaged item".equals(stockOut.getReason()) ? "selected" : "" %>>Damaged item</option>
                                <option value="Returned to supplier" <%= "Returned to supplier".equals(stockOut.getReason()) ? "selected" : "" %>>Returned to supplier</option>
                                <option value="Other" <%= "Other".equals(stockOut.getReason()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>

                        <div class="form-group hidden" id="expirationDateGroup">
                            <label>Expiration Date</label>
                            <input type="text" id="expirationDateDisplay" class="form-control" readonly style="background-color: #f8fafc; cursor: not-allowed; color: #64748b;">
                        </div>

                        <div class="form-group hidden" id="warrantyMonthsGroup">
                            <label>Warranty</label>
                            <input type="text" id="warrantyMonthsDisplay" class="form-control" readonly style="background-color: #f8fafc; cursor: not-allowed; color: #64748b;">
                        </div>

                        <div class="form-group full-width">
                            <label for="note">Note</label>
                            <textarea id="note" name="note" class="form-control"><%= note %></textarea>
                        </div>
                    </div>

                    <button type="submit" class="button button-primary">Update Stock Out</button>
                </form>
            </section>
        </div>

        <script>
            const productSelect = document.getElementById("productId");
            const quantityInput = document.getElementById("quantity");
            const expirationGroup = document.getElementById("expirationDateGroup");
            const expirationDisplay = document.getElementById("expirationDateDisplay");
            const warrantyGroup = document.getElementById("warrantyMonthsGroup");
            const warrantyDisplay = document.getElementById("warrantyMonthsDisplay");

            // We need to keep track of the original stockout quantity to properly adjust max quantity limits
            const originalQuantity = <%= stockOut.getQuantity() %>;
            const originalProductId = "<%= stockOut.getProductId() %>";

            function showSelectedProductDetails() {
                const selectedOption = productSelect.options[productSelect.selectedIndex];
                if (!selectedOption || selectedOption.value === "") {
                    expirationGroup.classList.add("hidden");
                    warrantyGroup.classList.add("hidden");
                    quantityInput.removeAttribute("max");
                    return;
                }

                const productType = selectedOption.dataset.productType || "";
                
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

                if (selectedOption.dataset.availableQuantity) {
                    let maxAvailable = Number(selectedOption.dataset.availableQuantity);
                    // If this is the original product, max available should include the quantity currently tied to this stock-out
                    if (selectedOption.value === originalProductId) {
                        maxAvailable += originalQuantity;
                    }

                    quantityInput.max = maxAvailable;
                    // Don't auto-reset the input value here on edit to preserve user input, just enforce the max
                    if (Number(quantityInput.value) > maxAvailable) {
                        quantityInput.value = maxAvailable;
                    }
                }
            }

            // Initialization on page load
            document.addEventListener("DOMContentLoaded", showSelectedProductDetails);
        </script>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
