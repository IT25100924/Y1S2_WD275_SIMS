<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.stockin.StockIn stockIn =
            (com.inventory.sims.stockin.StockIn) request.getAttribute("stockIn");
    String productType = stockIn.getProductType();
    if (productType == null || productType.isBlank()) {
        productType = "Standard";
    } else if ("General".equalsIgnoreCase(productType)) {
        productType = "Standard";
    }
    String note = stockIn.getNote() == null || stockIn.getNote().isBlank() ? "-" : stockIn.getNote();
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Stockin" />
    <jsp:param name="activeMenu" value="stockin" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Stock In Details</h1>
                <p>Review the full incoming stock record before updating or deleting it.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/stockin/view">Back to records</a>
                <a class="button button-primary" href="/stockin/edit/<%= stockIn.getId() %>">Edit record</a>
            </div>
        </header>

        <section class="hero">
            <h2><%= stockIn.getProductName() %></h2>
            <p><%= note %></p>
            <div class="hero-meta">
                <span class="badge badge-green"><%= stockIn.getId() %></span>
                <span class="badge"><%= productType %></span>
                <span class="badge badge-amber"><%= stockIn.getReceivedDate() %></span>
            </div>
        </section>

        <section class="grid" aria-label="Stock in details">
            <article class="card">
                <h3>Stock Movement</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Stock In ID</span><strong><%= stockIn.getId() %></strong></div>
                    <div class="detail-item"><span>Received date</span><strong><%= stockIn.getReceivedDate() %></strong></div>
                    <div class="detail-item"><span>Supplier</span><strong><%= stockIn.getSupplierName() %></strong></div>
                    <div class="detail-item"><span>Quantity in</span><strong><%= stockIn.getQuantity() %></strong></div>
                </div>
            </article>

            <article class="card">
                <h3>Product Information</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Product ID</span><strong><%= stockIn.getProductId() %></strong></div>
                    <div class="detail-item"><span>Product name</span><strong><%= stockIn.getProductName() %></strong></div>
                    <div class="detail-item"><span>Product type</span><strong><%= productType %></strong></div>
                    <div class="detail-item"><span>Product details</span><strong><%= stockIn.getSpecialDetails() %></strong></div>
                </div>
            </article>

            <article class="card">
                <h3>Cost Details</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Unit cost</span><strong>LKR <%= String.format("%.2f", stockIn.getUnitCost()) %></strong></div>
                    <div class="detail-item"><span>Total cost</span><strong>LKR <%= String.format("%.2f", stockIn.getTotalCost()) %></strong></div>
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

