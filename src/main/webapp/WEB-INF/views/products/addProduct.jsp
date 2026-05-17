<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Addproduct | Products" />
    <jsp:param name="activeMenu" value="products" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Add New Product</h1>
                <p>Enter the details for the new inventory item.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/products">Cancel</a>
            </div>
        </header>

        <div class="form-card">
            <form action="/products/add" method="post" id="productForm">
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; border: 1px solid #fecaca; color: #b91c1c; background: #fef2f2; font-weight: bold;">
                    <%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>
                <div class="form-group">
                    <label for="type">Product Type</label>
                    <select id="type" name="type" class="form-control" onchange="toggleFields()">
                        <option value="General">Standard Product</option>
                        <option value="Electronics">Electronics Product</option>
                        <option value="Food">Food Product</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="id">Product ID</label>
                    <!-- Automatically displays the ID securely passed from the backend controller -->
                    <input type="text" id="id" name="id" class="form-control" value="${nextId}" readonly style="background-color: #f1f5f9; cursor: not-allowed; color: #64748b;">
                </div>

                <div class="form-group">
                    <label for="supplierId">Supplier</label>
                    <select id="supplierId" name="supplierId" class="form-control" required>
                        <option value="" disabled selected>Select a Supplier</option>
                        <%
                            java.util.List<com.inventory.sims.supplier.Supplier> suppliers = (java.util.List<com.inventory.sims.supplier.Supplier>) request.getAttribute("suppliers");
                            if (suppliers != null) {
                                for(com.inventory.sims.supplier.Supplier s : suppliers) {
                        %>
                        <option value="<%= s.getId() %>"><%= s.getId() %> - <%= s.getCompanyName() %></option>
                        <%      }
                        }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="mrp">MRP / Default Sell Price (LKR)</label>
                    <input type="number" id="mrp" name="mrp" class="form-control" step="0.01" min="0" required>
                </div>

                <!-- Checkbox 1 -->
                <div class="form-group" style="margin-top: 20px;">
                    <label>
                        <input type="checkbox" id="configurePrices" name="configurePrices" onchange="togglePriceFields()">
                        Configure Default Product Prices
                    </label>
                </div>
                <div id="priceGroup" class="hidden" style="margin-left: 20px; border-left: 2px solid #e2e8f0; padding-left: 15px;">
                    <div class="form-group">
                        <label for="defaultStockInPrice">Default Stock-In Price (LKR)</label>
                        <input type="number" id="defaultStockInPrice" name="defaultStockInPrice" class="form-control" step="0.01" min="0">
                    </div>
                    <div class="form-group">
                        <label for="defaultStockOutPrice">Default Stock-Out Price (LKR)</label>
                        <input type="number" id="defaultStockOutPrice" name="defaultStockOutPrice" class="form-control" step="0.01" min="0">
                    </div>
                </div>
                <!-- Checkbox 2 -->
                <div class="form-group" style="margin-top: 20px;">
                    <label>
                        <input type="checkbox" id="initializeStock" name="initializeStock" onchange="toggleStockFields()">
                        Initialize First Stock-In Order
                    </label>
                </div>
                <div id="stockGroup" class="hidden" style="margin-left: 20px; border-left: 2px solid #e2e8f0; padding-left: 15px;">
                    <div class="form-group">
                        <label for="quantity">Initial Quantity</label>
                        <input type="number" id="quantity" name="quantity" class="form-control" min="1">
                    </div>

                    <!-- Dynamic Field for Electronics -->
                    <div class="form-group hidden" id="warrantyGroup">
                        <label for="warrantyMonths">Warranty (Months)</label>
                        <input type="number" id="warrantyMonths" name="warrantyMonths" class="form-control" min="0">
                    </div>
                    <!-- Dynamic Field for Food -->
                    <div class="form-group hidden" id="expirationGroup">
                        <label for="expirationDate">Expiration Date</label>
                        <input type="date" id="expirationDate" name="expirationDate" class="form-control">
                    </div>
                </div>
                <script>
                    function togglePriceFields() {
                        document.getElementById('priceGroup').classList.toggle('hidden', !document.getElementById('configurePrices').checked);
                    }

                    function toggleStockFields() {
                        document.getElementById('stockGroup').classList.toggle('hidden', !document.getElementById('initializeStock').checked);
                        toggleFields(); // Re-trigger the product type logic for warranty/exp date
                    }
                    function toggleFields() {
                        var type = document.getElementById('type').value;
                        var initChecked = document.getElementById('initializeStock').checked;

                        document.getElementById('warrantyGroup').classList.add('hidden');
                        document.getElementById('expirationGroup').classList.add('hidden');

                        if (initChecked) {
                            if (type === 'Electronics') document.getElementById('warrantyGroup').classList.remove('hidden');
                            if (type === 'Food') document.getElementById('expirationGroup').classList.remove('hidden');
                        }
                    }
                </script>

<%--                <div class="form-group">--%>
<%--                    <label for="price">Unit Price (LKR)</label>--%>
<%--                    <input type="number" id="price" name="price" class="form-control" step="0.01" min="0">--%>
<%--                </div>--%>

<%--                <div class="form-group">--%>
<%--                    <label for="quantity">Initial Quantity</label>--%>
<%--                    <input type="number" id="quantity" name="quantity" class="form-control" min="0">--%>
<%--                </div>--%>

<%--                <!-- Dynamic Field for Electronics -->--%>
<%--                <div class="form-group hidden" id="warrantyGroup">--%>
<%--                    <label for="warrantyMonths">Warranty (Months)</label>--%>
<%--                    <input type="number" id="warrantyMonths" name="warrantyMonths" class="form-control" min="0">--%>
<%--                </div>--%>

<%--                <!-- Dynamic Field for Food -->--%>
<%--                <div class="form-group hidden" id="expirationGroup">--%>
<%--                    <label for="expirationDate">Expiration Date</label>--%>
<%--                    <input type="date" id="expirationDate" name="expirationDate" class="form-control">--%>
<%--                </div>--%>

                <button type="submit" class="button button-primary">Save Product</button>
            </form>
        </div>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

