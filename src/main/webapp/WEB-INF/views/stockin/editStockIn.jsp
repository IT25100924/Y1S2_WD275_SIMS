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
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Editstockin | Stockin" />
    <jsp:param name="activeMenu" value="stockin" />
</jsp:include>

        <header class="page-header">
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
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

