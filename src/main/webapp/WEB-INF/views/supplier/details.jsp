<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Details | SIMS</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: Arial, Helvetica, sans-serif; color: #172033; background: #eef2f6; }
        .layout { min-height: 100vh; display: grid; grid-template-columns: 250px 1fr; }
        .sidebar { background: #17324d; color: #fff; padding: 28px 22px; }
        .brand { font-size: 18px; font-weight: 700; margin-bottom: 34px; }
        .nav { display: grid; gap: 8px; }
        .nav a { display: block; padding: 12px 14px; color: #d7e4ef; text-decoration: none; border-radius: 6px; font-weight: 700; }
        .nav a:hover, .nav a.active { color: #fff; background: rgba(255, 255, 255, 0.12); }
        .main { padding: 32px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 18px; margin-bottom: 26px; flex-wrap: wrap; }
        .page-title h1 { margin: 0 0 6px; font-size: 30px; color: #111827; }
        .page-title p { margin: 0; color: #64748b; }
        .actions { display: flex; gap: 12px; flex-wrap: wrap; }
        .button { min-height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid transparent; padding: 10px 14px; font: inherit; font-weight: 700; text-decoration: none; cursor: pointer; }
        .button-primary { background: #1d4ed8; color: #fff; }
        .button-primary:hover { background: #1e40af; }
        .button-secondary { background: #fff; color: #334155; border-color: #cbd5e1; }
        .button-secondary:hover { background: #f8fafc; }
        .hero { background: linear-gradient(135deg, #17324d 0%, #245b7f 100%); color: #fff; border-radius: 10px; padding: 28px; margin-bottom: 24px; }
        .hero h2 { margin: 0 0 8px; font-size: 30px; }
        .hero p { margin: 0; color: #d7e4ef; line-height: 1.6; }
        .hero-meta { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 18px; }
        .badge { display: inline-flex; align-items: center; min-height: 28px; padding: 4px 10px; border-radius: 999px; font-size: 13px; font-weight: 700; }
        .badge-local { color: #075985; background: #e0f2fe; }
        .badge-import { color: #7c2d12; background: #ffedd5; }
        .badge-active { color: #166534; background: #dcfce7; }
        .badge-pending { color: #92400e; background: #fef3c7; }
        .grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 18px; }
        .card { background: #fff; border: 1px solid #d9e1ea; border-radius: 8px; padding: 22px; }
        .card h3 { margin: 0 0 18px; font-size: 18px; color: #111827; }
        .detail-list { display: grid; gap: 16px; }
        .detail-item span { display: block; color: #64748b; font-size: 14px; margin-bottom: 6px; }
        .detail-item strong, .detail-item p { margin: 0; color: #111827; line-height: 1.6; }
        @media (max-width: 860px) {
            .layout { grid-template-columns: 1fr; }
            .sidebar { padding: 18px; }
            .brand { margin-bottom: 16px; }
            .nav { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .main { padding: 24px 18px; }
            .grid { grid-template-columns: 1fr; }
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
                <a href="/suppliers" class="active">Suppliers</a>
                <a href="/stockin">Stock In</a>
                <a href="/stockout">Stock Out</a>
                <a href="/alerts">Alerts</a>
                <a href="/users">Users</a>
            </nav>
        </aside>
        <main class="main">
            <header class="topbar">
                <div class="page-title">
                    <h1>Supplier Profile</h1>
                    <p>Review supplier information before placing orders or updating records.</p>
                </div>
                <div class="actions">
                    <a class="button button-secondary" href="/suppliers">Back to suppliers</a>
                    <a class="button button-primary" href="/suppliers/edit/${supplier.id}">Edit supplier</a>
                </div>
            </header>
            <section class="hero">
                <h2>${supplier.companyName}</h2>
                <p>${supplier.notes}</p>
                <div class="hero-meta">
                    <span class="badge ${supplier.category eq 'IMPORT' ? 'badge-import' : 'badge-local'}">${supplier.category}</span>
                    <span class="badge ${supplier.status eq 'PENDING' ? 'badge-pending' : 'badge-active'}">${supplier.status}</span>
                </div>
            </section>
            <section class="grid" aria-label="Supplier details">
                <article class="card">
                    <h3>Contact Information</h3>
                    <div class="detail-list">
                        <div class="detail-item"><span>Contact person</span><strong>${supplier.contactPerson}</strong></div>
                        <div class="detail-item"><span>Email address</span><strong>${supplier.email}</strong></div>
                        <div class="detail-item"><span>Phone number</span><strong>${supplier.phone}</strong></div>
                        <div class="detail-item"><span>Address</span><p>${supplier.address}</p></div>
                    </div>
                </article>
                <article class="card">
                    <h3>Supply Information</h3>
                    <div class="detail-list">
                        <div class="detail-item"><span>City</span><strong>${supplier.city}</strong></div>
                        <div class="detail-item"><span>Lead time</span><strong>${supplier.leadTime}</strong></div>
                        <div class="detail-item"><span>Category</span><strong>${supplier.category}</strong></div>
                        <div class="detail-item"><span>Status</span><strong>${supplier.status}</strong></div>
                    </div>
                </article>
            </section>
        </main>
    </div>
</body>
</html>
