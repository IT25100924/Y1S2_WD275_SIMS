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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stockout Details | SIMS</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: Arial, Helvetica, sans-serif; color: #172033; background: #eef2f6; }
        .layout { min-height: 100vh; display: grid; grid-template-columns: 250px 1fr; }
        .sidebar { background: #17324d; color: #ffffff; padding: 28px 22px; }
        .brand { font-size: 18px; font-weight: 700; margin-bottom: 34px; }
        .nav { display: grid; gap: 8px; }
        .nav a { display: block; padding: 12px 14px; color: #d7e4ef; text-decoration: none; border-radius: 6px; font-weight: 700; }
        .nav a:hover, .nav a.active { color: #ffffff; background: rgba(255, 255, 255, 0.12); }
        .main { padding: 32px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 18px; margin-bottom: 26px; flex-wrap: wrap; }
        .page-title h1 { margin: 0 0 6px; font-size: 30px; color: #111827; }
        .page-title p { margin: 0; color: #64748b; }
        .actions { display: flex; gap: 12px; flex-wrap: wrap; }
        .button { min-height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid transparent; padding: 10px 14px; font: inherit; font-weight: 700; text-decoration: none; cursor: pointer; }
        .button-primary { background: #1d4ed8; color: #ffffff; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #ffffff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .hero { background: linear-gradient(135deg, #17324d 0%, #245b7f 100%); color: #ffffff; border-radius: 10px; padding: 28px; margin-bottom: 24px; }
        .hero h2 { margin: 0 0 8px; font-size: 30px; }
        .hero p { margin: 0; color: #d7e4ef; line-height: 1.6; }
        .hero-meta { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 18px; }
        .badge { display: inline-flex; align-items: center; min-height: 28px; padding: 4px 10px; border-radius: 999px; font-size: 13px; font-weight: 700; color: #075985; background: #e0f2fe; }
        .badge-red { color: #991b1b; background: #fee2e2; }
        .badge-amber { color: #92400e; background: #fef3c7; }
        .grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 18px; }
        .card { background: #ffffff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 22px; }
        .card h3 { margin: 0 0 18px; font-size: 18px; color: #111827; }
        .detail-list { display: grid; gap: 16px; }
        .detail-item span { display: block; color: #64748b; font-size: 14px; margin-bottom: 6px; }
        .detail-item strong, .detail-item p { margin: 0; color: #111827; line-height: 1.6; overflow-wrap: anywhere; }
        @media (max-width: 860px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 18px; }
            .brand { margin-bottom: 16px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px 18px; }
            .grid { grid-template-columns: 1fr; }
            .actions, .button { width: 100%; }
        }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">SIMS</div>
        <nav class="nav" aria-label="Main navigation">
            <a href="/dashboard">Dashboard</a>
            <a href="/products">Products</a>
            <a href="/suppliers">Suppliers</a>
            <a href="/stockin">Stock In</a>
            <a href="/stockout" class="active">Stock Out</a>
            <a href="/alerts">Alerts</a>
            <a href="/users">Users</a>
        </nav>
    </aside>

    <main class="main">
        <header class="topbar">
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
    </main>
</div>
</body>
</html>
