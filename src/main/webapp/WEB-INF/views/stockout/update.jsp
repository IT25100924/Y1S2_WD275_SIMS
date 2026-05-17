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
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Update | Stockout" />
    <jsp:param name="activeMenu" value="stockout" />
</jsp:include>

        <header class="page-header">
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
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

