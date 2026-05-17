<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Viewproducts | Products" />
    <jsp:param name="activeMenu" value="products" />
</jsp:include>

<style>
    /* Card Styles matching Users page */
    .summary-card {
        border-left: none !important;
        border-radius: 20px !important;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05) !important;
        transition: transform 0.3s ease, box-shadow 0.3s ease !important;
        border: 1px solid rgba(255, 255, 255, 0.5) !important;
        backdrop-filter: blur(10px) !important;
        padding: 28px !important;
    }

    .summary-card:hover {
        transform: translateY(-5px) !important;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08) !important;
    }

    .summary-card span {
        font-size: 14px !important;
        color: #475569 !important;
        font-weight: 600 !important;
        text-transform: capitalize !important;
        letter-spacing: normal !important;
    }

    .summary-card strong {
        font-size: 36px !important;
        font-weight: 800 !important;
        color: #0f172a !important;
        display: block;
        margin-top: 8px;
    }

    .card-purple {
        background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%) !important;
    }

    .card-red {
        background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%) !important;
    }

    .card-blue {
        background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%) !important;
    }

    .card-green {
        background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%) !important;
    }

    /* Toolbar inside table-wrap */
    .toolbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 24px 32px;
        border-bottom: 1px solid rgba(226, 232, 240, 0.8);
    }

    section[aria-label="Products table"] {
        margin-top: 0;
    }

    .search {
        position: relative;
        flex: 1;
        max-width: 500px;
    }

    .search input[type="search"] {
        width: 100%;
        padding: 14px 48px 14px 48px;
        border-radius: 100px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
        font-size: 15px;
        color: #1e293b;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
    }

    .search input[type="search"]:focus {
        background: #ffffff;
        border-color: #818cf8;
        box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        outline: none;
    }

    .search .search-icon {
        position: absolute;
        left: 18px;
        top: 50%;
        transform: translateY(-50%);
        color: #64748b;
        font-size: 20px;
        pointer-events: none;
        z-index: 1;
    }

    .search .clear-btn {
        position: absolute;
        right: 18px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: #94a3b8;
        cursor: pointer;
        font-size: 18px;
        padding: 4px;
        display: none;
        transition: color 0.2s ease;
        z-index: 1;
    }

    .search .clear-btn:hover {
        color: #ef4444;
    }

    /* Search and Table Section */
    .table-wrap {
        border-radius: 24px;
        overflow: hidden;
        border: 1px solid rgba(226, 232, 240, 0.8);
        background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.03);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }

    th {
        padding: 16px 24px;
        font-weight: 700;
        font-size: 13px;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
        border-bottom: 2px solid rgba(226, 232, 240, 0.8);
    }

    td {
        padding: 16px 24px;
        border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        color: #334155;
        font-size: 14px;
        font-weight: 500;
    }

    tbody tr {
        transition: all 0.2s ease;
        background: #ffffff;
    }

    tbody tr:hover {
        background: #f8fafc;
        transform: scale(1.001);
    }
    
    .table-actions {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .table-actions a,
    .table-actions button {
        width: 36px;
        height: 36px;
        border-radius: 10px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s ease;
        background: #f1f5f9;
        color: #64748b;
        border: none;
        cursor: pointer;
    }

    .table-actions a:hover {
        background: #e0e7ff;
        color: #4f46e5;
        transform: translateY(-2px);
    }

    .table-actions button:hover {
        background: #fee2e2;
        color: #ef4444;
        transform: translateY(-2px);
    }
</style>

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
            <div class="summary-card card-purple">
                <span>Total Products</span>
                <strong><%= request.getAttribute("totalProducts") %></strong>
            </div>
            <div class="summary-card card-blue">
                <span>Electronics</span>
                <strong><%= request.getAttribute("electronicsCount") %></strong>
            </div>
            <div class="summary-card card-green">
                <span>Food Items</span>
                <strong><%= request.getAttribute("foodCount") %></strong>
            </div>
            <div class="summary-card card-red">
                <span>Low Stock Alert</span>
                <strong><%= request.getAttribute("lowStockCount") %></strong>
            </div>
        </section>

        <section aria-label="Products table">
            <div class="table-wrap">
                <div class="toolbar">
                    <form class="search" onsubmit="event.preventDefault();">
                        <i class="ph ph-magnifying-glass search-icon"></i>
                        <input type="search" id="searchInput" placeholder="Search by Product Name or ID..." onkeyup="filterTable()">
                        <button type="button" class="clear-btn" id="clearSearchBtn" onclick="clearSearch()" title="Clear search"><i class="ph ph-x"></i></button>
                    </form>
                    <div id="productsCount" style="font-size: 14px; color: var(--text-muted); font-weight: 500; background: rgba(255,255,255,0.8); padding: 8px 16px; border-radius: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.02);">
                        <%= request.getAttribute("totalProducts") %> products found
                    </div>
                </div>
                <table id="productTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Supplier ID</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Unit Price (LKR)</th>
                        <th>Initial Quantity</th>
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
                                    extraDetails = "Warranty: " + ((com.inventory.sims.product.ElectronicsProduct) product).getWarrantyMonths() + " months";
                                } else if (product instanceof com.inventory.sims.product.FoodProduct) {
                                    typeBadgeClass = "badge-food";
                                    String exp = ((com.inventory.sims.product.FoodProduct) product).getExpirationDate();
                                    extraDetails = "Initial Expiry: " + (exp != null && !exp.isEmpty() ? exp : "N/A");
                                }

                                boolean isLowStock = product.getQuantity() <= 5;
                    %>
                    <tr class="<%= isLowStock ? "low-stock" : "" %>">
                        <td><%= product.getId() %></td>
                        <td><span class="badge" style="background:#eef2f6; color:#475569;"><%= product.getSupplierId() %></span></td>
                        <td><%= product.getName() %></td>
                        <td><span class="badge <%= typeBadgeClass %>"><%= product.getClass().getSimpleName() %></span></td>
                        <!-- $ sign removed! -->
                        <td><%= String.format("%.2f", product.getPrice()) %></td>
                        <td><%= product.getQuantity() %></td>
                        <td style="color: #64748b; font-size: 13px; font-weight: bold;"><%= extraDetails %></td>
                        <td>
                            <div class="table-actions">
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
                        <td colspan="8" style="text-align: center; padding: 20px; color: #64748b;">No products found. Click "Add Product" to create one!</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <script>
            function filterTable() {
                var input = document.getElementById("searchInput");
                var clearBtn = document.getElementById("clearSearchBtn");
                var filter = input.value.toUpperCase();
                var table = document.getElementById("productTable");
                var tbody = table.getElementsByTagName("tbody")[0];
                var tr = tbody.getElementsByTagName("tr");
                var visibleCount = 0;

                if (filter.length > 0) {
                    clearBtn.style.display = "block";
                } else {
                    clearBtn.style.display = "none";
                }

                for (var i = 0; i < tr.length; i++) {
                    if (tr[i].getElementsByTagName("td").length === 1) continue; // Skip empty state row
                    
                    var textContent = tr[i].textContent || tr[i].innerText;
                    
                    if (textContent.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                        visibleCount++;
                    } else {
                        tr[i].style.display = "none";
                    }
                }
                
                document.getElementById('productsCount').innerText = visibleCount + " products found";
            }

            function clearSearch() {
                var input = document.getElementById("searchInput");
                input.value = "";
                filterTable();
            }

            window.onload = function () {
                filterTable();
            };
        </script>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
