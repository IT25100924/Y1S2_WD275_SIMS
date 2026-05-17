<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Viewproducts | Products" />
    <jsp:param name="activeMenu" value="products" />
</jsp:include>

        <header class="page-header">
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
                    <i class="ph ph-magnifying-glass search-icon"></i>
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
                        <th>Default Sell Price (LKR)</th>
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
                                    int wm = ((com.inventory.sims.product.ElectronicsProduct) product).getWarrantyMonths();
                                    extraDetails = wm > 0 ? "Warranty: " + wm + " months" : "-";
                                } else if (product instanceof com.inventory.sims.product.FoodProduct) {
                                    typeBadgeClass = "badge-food";
                                    String exp = ((com.inventory.sims.product.FoodProduct) product).getExpirationDate();
                                    extraDetails = (exp != null && !exp.trim().isEmpty()) ? "Initial Expiry: " + exp : "-";
                                }

                                boolean isLowStock = product.getQuantity() <= 5;
                    %>
                    <tr class="<%= isLowStock ? "low-stock" : "" %>">
                        <td><%= product.getId() %></td>
                        <td><span class="badge" style="background:#eef2f6; color:#475569;"><%= product.getSupplierId() %></span></td>
                        <td><%= product.getName() %></td>
                        <td><span class="badge <%= typeBadgeClass %>"><%= product.getClass().getSimpleName() %></span></td>
                        <!-- $ sign removed! -->
                        <td><%= String.format("%.2f", product.getMrp()) %></td>
                        <td style="color: #64748b; font-size: 13px; font-weight: bold;"><%= extraDetails %></td>
                        <td>
                            <div class="table-actions">
                                <a href="/products/details/<%= product.getId() %>" title="View Details"><i class="ph ph-eye"></i></a>
                                <a href="/products/edit/<%= product.getId() %>" title="Edit"><i class="ph ph-pencil-simple"></i></a>
                                <form action="/products/delete/<%= product.getId() %>" method="post" onsubmit="return confirm('Are you sure you want to delete this product?');" style="margin:0;">
                                    <button type="submit" title="Delete"><i class="ph ph-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px; color: #64748b;">No products found. Click "Add Product" to create one!</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <script>
            function filterTable() {
                var input = document.getElementById("searchInput");
                var filter = input.value.toUpperCase();
                var table = document.getElementById("productTable");
                var tbody = table.getElementsByTagName("tbody")[0];
                var tr = tbody.getElementsByTagName("tr");

                for (var i = 0; i < tr.length; i++) {
                    if (tr[i].getElementsByTagName("td").length === 1) continue; // Skip empty state row
                    
                    var tdId = tr[i].getElementsByTagName("td")[0];
                    var tdName = tr[i].getElementsByTagName("td")[2];
                    
                    if (tdId && tdName) {
                        var txtValueId = tdId.textContent || tdId.innerText;
                        var txtValueName = tdName.textContent || tdName.innerText;
                        
                        if (txtValueId.toUpperCase().indexOf(filter) > -1 || txtValueName.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        </script>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
