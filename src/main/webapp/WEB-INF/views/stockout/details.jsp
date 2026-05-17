<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.stockout.StockOut stockOut =
            (com.inventory.sims.stockout.StockOut) request.getAttribute("stockOut");
    com.inventory.sims.product.Product product =
            (com.inventory.sims.product.Product) request.getAttribute("product");

    String note = stockOut.getNote() == null || stockOut.getNote().isBlank() ? "-" : stockOut.getNote();
    String productType = "Standard";
    String productDetails = "-";
    if (product instanceof com.inventory.sims.product.FoodProduct) {
        productType = "Food";
        String expirationDate = ((com.inventory.sims.product.FoodProduct) product).getExpirationDate();
        productDetails = expirationDate == null || expirationDate.isBlank() ? "Expiration date not set" : "Expires on " + expirationDate;
    } else if (product instanceof com.inventory.sims.product.ElectronicsProduct) {
        productType = "Electronics";
        productDetails = ((com.inventory.sims.product.ElectronicsProduct) product).getWarrantyMonths() + " months warranty";
    } else if (product == null) {
        productDetails = "Product record not found";
    }
    double totalValue = stockOut.getQuantity() * stockOut.getUnitPrice();
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Stockout" />
    <jsp:param name="activeMenu" value="stockout" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Stockout Details</h1>
                <p>Review the full outgoing stock record before updating or deleting it.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/stockout">Back to records</a>
                <a class="button button-primary" href="/stockout/update/<%= stockOut.getId() %>">Edit record</a>
            </div>
        </header>

        <section class="hero">
            <h2><%= stockOut.getProductName() %></h2>
            <p><%= note %></p>
            <div class="hero-meta">
                <span class="badge badge-red"><%= stockOut.getId() %></span>
                <span class="badge"><%= productType %></span>
                <span class="badge badge-amber"><%= stockOut.getStockOutDate() == null ? "-" : stockOut.getStockOutDate() %></span>
            </div>
        </section>

        <section class="grid" aria-label="Stockout details">
            <article class="card">
                <h3>Stock Movement</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Stockout ID</span><strong><%= stockOut.getId() %></strong></div>
                    <div class="detail-item"><span>Stockout date</span><strong><%= stockOut.getStockOutDate() == null ? "-" : stockOut.getStockOutDate() %></strong></div>
                    <div class="detail-item"><span>Issued to</span><strong><%= stockOut.getIssuedTo() %></strong></div>
                    <div class="detail-item"><span>Reason</span><strong><%= stockOut.getReason() %></strong></div>
                </div>
            </article>

            <article class="card">
                <h3>Product Information</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Product ID</span><strong><%= stockOut.getProductId() %></strong></div>
                    <div class="detail-item"><span>Product name</span><strong><%= stockOut.getProductName() %></strong></div>
                    <div class="detail-item"><span>Product type</span><strong><%= productType %></strong></div>
                    <div class="detail-item"><span>Product details</span><strong><%= productDetails %></strong></div>
                </div>
            </article>

            <article class="card">
                <h3>Value Details</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Quantity out</span><strong><%= stockOut.getQuantity() %></strong></div>
                    <div class="detail-item"><span>Unit price</span><strong>LKR <%= String.format("%.2f", stockOut.getUnitPrice()) %></strong></div>
                    <div class="detail-item"><span>Total value</span><strong>LKR <%= String.format("%.2f", totalValue) %></strong></div>
                </div>
            </article>

            <article class="card">
                <h3>Record Note</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Note</span><p><%= note %></p></div>
                </div>
            </article>
        </section>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

