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
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Editproduct | Products" />
    <jsp:param name="activeMenu" value="products" />
</jsp:include>

        <header class="page-header">
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
                    <select id="supplierId" name="supplierId" class="form-control" required>
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
<%--                    <input type="hidden" name="supplierId" value="<%= p.getSupplierId() %>">--%>
                </div>

                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" class="form-control" required value="<%= p.getName() %>">
                </div>

                <div class="form-group">
                    <label for="mrp">MRP / Default Sell Price (LKR)</label>
                    <input type="number" id="mrp" name="mrp" class="form-control" step="0.01" min="0" required value="<%= p.getMrp() %>">
                </div>
                <div class="form-group">
                    <label for="defaultStockInPrice">Default Stock-In Price (LKR)</label>
                    <input type="number" id="defaultStockInPrice" name="defaultStockInPrice" class="form-control" step="0.01" min="0" value="<%= p.getDefaultStockInPrice() %>">
                </div>
                <div class="form-group">
                    <label for="defaultStockOutPrice">Default Stock-Out Price (LKR)</label>
                    <input type="number" id="defaultStockOutPrice" name="defaultStockOutPrice" class="form-control" step="0.01" min="0" value="<%= p.getDefaultStockOutPrice() %>">
                </div>


            <%--                <div class="form-group">--%>
<%--                    <label for="price">Unit Price (LKR)</label>--%>
<%--                    <input type="number" id="price" name="price" class="form-control" step="0.01" min="0" value="<%= p.getPrice() %>">--%>
<%--                </div>--%>

<%--                <div class="form-group">--%>
<%--                    <label for="quantity">Initial Quantity</label>--%>
<%--                    <input type="number" id="quantity" name="quantity" class="form-control" min="0" value="<%= p.getQuantity() %>">--%>
<%--                </div>--%>

                <div class="form-group hidden" id="warrantyGroup">
                    <label for="warrantyMonths">Warranty (Months)</label>
                    <input type="number" id="warrantyMonths" name="warrantyMonths" class="form-control" min="0" value="<%= warranty %>">
                </div>

                <div class="form-group hidden" id="expirationGroup">
                    <label for="expirationDate">Expiration Date</label>
                    <input type="date" id="expirationDate" name="expirationDate" class="form-control" value="<%= expiration %>" min="<%= java.time.LocalDate.now().toString() %>">
                </div>

                <script>
                    function toggleFields() {
                        var type = document.getElementById('type').value;
                        var warrantyGroup = document.getElementById('warrantyGroup');
                        var expirationGroup = document.getElementById('expirationGroup');

                        if (warrantyGroup && expirationGroup) {
                            warrantyGroup.classList.add('hidden');
                            expirationGroup.classList.add('hidden');

                            if (type === 'Electronics') {
                                warrantyGroup.classList.remove('hidden');
                            } else if (type === 'Food') {
                                expirationGroup.classList.remove('hidden');
                            }
                        }
                    }

                    document.addEventListener("DOMContentLoaded", toggleFields);
                </script>

                <button type="submit" class="button button-primary">Update Product</button>
            </form>
        </div>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

