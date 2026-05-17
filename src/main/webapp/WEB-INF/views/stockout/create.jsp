<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    java.util.List<com.inventory.sims.product.Product> products =
            (java.util.List<com.inventory.sims.product.Product>) request.getAttribute("products");
    java.util.List<com.inventory.sims.customer.Customer> customers =
            (java.util.List<com.inventory.sims.customer.Customer>) request.getAttribute("customers");
    String today = (String) request.getAttribute("today");
    String message = (String) request.getAttribute("message");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Create Stock Out | Stock Out" />
    <jsp:param name="activeMenu" value="stockout" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Create Stock Out</h1>
                <p>Record inventory items issued from stock for sales, internal use, returns, or damage adjustments.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/stockout">View Records</a>
                <a class="button button-secondary" href="/products">View Products</a>
            </div>
        </header>

        <% if (message != null && !message.isBlank()) { %>
        <div class="alert alert-error"><%= message %></div>
        <% } %>

        <div class="content-grid">
            <section class="form-card" aria-label="Stock out form">
                <form action="/stockout/create" method="post">
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
                                    data-available-quantity="<%= product.getQuantity() %>">
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
                                %>
                                <option value="<%= customer.getId() %>">
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
                            <input type="date" id="stockOutDate" name="stockOutDate" class="form-control" value="<%= today == null ? "" : today %>" min="<%= today == null ? "" : today %>" required>
                        </div>

                        <div class="form-group">
                            <label for="quantity">Quantity Out</label>
                            <input type="number" id="quantity" name="quantity" class="form-control" min="1" step="1" required placeholder="0">
                        </div>

                        <div class="form-group">
                            <label for="unitPrice">Unit Price (LKR)</label>
                            <input type="number" id="unitPrice" name="unitPrice" class="form-control" step="0.01" min="0" required placeholder="0.00">
                        </div>

                        <div class="form-group">
                            <label for="reason">Reason</label>
                            <select id="reason" name="reason" class="form-control" required>
                                <option value="">Select reason</option>
                                <option value="Sale">Sale</option>
                                <option value="Internal use">Internal use</option>
                                <option value="Damaged item">Damaged item</option>
                                <option value="Returned to supplier">Returned to supplier</option>
                                <option value="Other">Other</option>
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
                            <textarea id="note" name="note" class="form-control" placeholder="Optional stock out note"></textarea>
                        </div>
                    </div>

                    <button type="submit" class="button button-primary">Create Stock Out</button>
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

            function showSelectedProductDetails() {
                const selectedOption = productSelect.options[productSelect.selectedIndex];
                if (!selectedOption || selectedOption.value === "") {
                    expirationGroup.classList.add("hidden");
                    warrantyGroup.classList.add("hidden");
                    quantityInput.removeAttribute("max");
                    quantityInput.placeholder = "0";
                    return;
                }
                
                const productType = selectedOption.dataset.productType || "";

                expirationGroup.classList.add("hidden");
                warrantyGroup.classList.add("hidden");
                expirationDisplay.value = "";
                warrantyDisplay.value = "";
                quantityInput.removeAttribute("max");
                quantityInput.placeholder = "1";

                if (productType === "Food") {
                    expirationDisplay.value = selectedOption.dataset.expirationDate || "Not set";
                    expirationGroup.classList.remove("hidden");
                } else if (productType === "Electronics") {
                    warrantyDisplay.value = (selectedOption.dataset.warrantyMonths || "0") + " months";
                    warrantyGroup.classList.remove("hidden");
                }

                if (selectedOption.dataset.availableQuantity) {
                    quantityInput.max = selectedOption.dataset.availableQuantity;
                    quantityInput.placeholder = "Max " + selectedOption.dataset.availableQuantity;
                    if (Number(quantityInput.value) > Number(selectedOption.dataset.availableQuantity)) {
                        quantityInput.value = selectedOption.dataset.availableQuantity;
                    }
                }
            }

            // Initialization on page load
            document.addEventListener("DOMContentLoaded", showSelectedProductDetails);
        </script>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
