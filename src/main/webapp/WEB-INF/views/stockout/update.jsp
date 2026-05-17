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
                    <div class="form-group">
                        <label>Stockout ID</label>
                        <input type="text" class="form-control" value="<%= stockOut.getId() %>" readonly>
                    </div>

                    <div class="form-group full-width">
                        <label>Product</label>
                        <select id="productId" name="productId" class="form-control" required>
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
                    </div>

                    <div class="form-group hidden" id="expirationDateGroup">
                        <label>Expiration date</label>
                        <input type="text" id="expirationDateDisplay" class="form-control" readonly>
                    </div>

                    <div class="form-group hidden" id="warrantyMonthsGroup">
                        <label>Warranty</label>
                        <input type="text" id="warrantyMonthsDisplay" class="form-control" readonly>
                    </div>

                    <div class="form-group">
                        <label>Quantity</label>
                        <input type="number" id="quantity" name="quantity" class="form-control" min="1" step="1" value="<%= stockOut.getQuantity() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Unit price (LKR)</label>
                        <input type="number" name="unitPrice" class="form-control" min="0" step="0.01" value="<%= stockOut.getUnitPrice() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Stockout date</label>
                        <input type="date" name="stockOutDate" class="form-control" value="<%= stockOutDate %>" min="<%= today == null ? "" : today %>">
                    </div>

                    <div class="form-group">
                        <label>Issued to</label>
                        <select name="issuedTo" class="form-control" required>
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
                    </div>

                    <div class="form-group">
                        <label>Reason</label>
                        <select name="reason" class="form-control" required>
                            <option value="">Select reason</option>
                            <option value="Sale" <%= "Sale".equals(stockOut.getReason()) ? "selected" : "" %>>Sale</option>
                            <option value="Internal use" <%= "Internal use".equals(stockOut.getReason()) ? "selected" : "" %>>Internal use</option>
                            <option value="Damaged item" <%= "Damaged item".equals(stockOut.getReason()) ? "selected" : "" %>>Damaged item</option>
                            <option value="Returned to supplier" <%= "Returned to supplier".equals(stockOut.getReason()) ? "selected" : "" %>>Returned to supplier</option>
                            <option value="Other" <%= "Other".equals(stockOut.getReason()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label>Note</label>
                        <textarea name="note" class="form-control"><%= note %></textarea>
                    </div>
                </div>

                <div class="actions" style="margin-top: 24px; display: flex; gap: 12px;">
                    <button type="submit" class="button button-primary">Update stockout</button>
                    <a class="button button-secondary" href="/stockout">Cancel</a>
                </div>
            </form>
        </section>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

