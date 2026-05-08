<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Supplier | SIMS</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: Arial, Helvetica, sans-serif; color: #172033; background: #eef2f6; display: flex; align-items: center; justify-content: center; padding: 24px; }
        .shell { width: min(100%, 1080px); display: grid; grid-template-columns: 0.9fr 1.1fr; background: #fff; border: 1px solid #d9e1ea; border-radius: 8px; overflow: hidden; box-shadow: 0 18px 48px rgba(25, 40, 70, 0.12); }
        .info-panel { background: #12333f; color: #fff; padding: 42px; display: flex; flex-direction: column; justify-content: space-between; min-height: 680px; }
        .brand { font-size: 14px; font-weight: 700; text-transform: uppercase; }
        .info-panel h1 { margin: 96px 0 16px; font-size: 34px; line-height: 1.15; }
        .info-panel p { margin: 0; line-height: 1.7; color: #d8e8ec; }
        .note { margin-top: 32px; padding: 18px; border: 1px solid rgba(255, 255, 255, 0.18); border-radius: 8px; background: rgba(255, 255, 255, 0.08); color: #ecfeff; }
        .form-panel { padding: 44px 48px; }
        .form-panel h2 { margin: 0 0 8px; font-size: 28px; color: #111827; }
        .subtitle { margin: 0 0 28px; color: #64748b; line-height: 1.5; }
        .alert { display: none; margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; border: 1px solid #bbf7d0; color: #166534; background: #f0fdf4; font-size: 14px; }
        .alert[style], .alert:not(:empty) { display: block; }
        form { display: grid; gap: 18px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        label { display: grid; gap: 8px; font-weight: 700; color: #263548; font-size: 14px; }
        input, select, textarea { width: 100%; min-height: 46px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px 12px; font: inherit; color: #111827; background: #fff; }
        textarea { min-height: 120px; resize: vertical; }
        input:focus, select:focus, textarea:focus { border-color: #2563eb; outline: 3px solid rgba(37, 99, 235, 0.16); }
        .full-width { grid-column: 1 / -1; }
        .checkbox-label { display: flex; align-items: flex-start; gap: 10px; font-weight: 400; color: #475569; line-height: 1.5; }
        .checkbox-label input { width: 16px; height: 16px; min-height: 16px; padding: 0; margin-top: 3px; flex: 0 0 auto; }
        button { min-height: 48px; border: 0; border-radius: 6px; background: #1d4ed8; color: #fff; font: inherit; font-weight: 700; cursor: pointer; }
        button:hover { background: #1e40af; }
        a { color: #1d4ed8; text-decoration: none; font-weight: 700; }
        a:hover { text-decoration: underline; }
        .switch-link { margin: 24px 0 0; color: #64748b; text-align: center; }
        @media (max-width: 840px) {
            body { align-items: stretch; padding: 0; }
            .shell { grid-template-columns: 1fr; width: 100%; min-height: 100vh; border: 0; border-radius: 0; }
            .info-panel { min-height: auto; padding: 28px; }
            .info-panel h1 { margin: 42px 0 14px; font-size: 30px; }
            .form-panel { padding: 34px 28px; }
        }
        @media (max-width: 560px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <main class="shell">
        <section class="info-panel" aria-label="Supplier information">
            <div>
                <div class="brand">SIMS</div>
                <h1>Create a supplier profile</h1>
                <p>Capture supplier company data, contact details, and sourcing information for inventory operations.</p>
                <div class="note">Use this form for both local and import suppliers. Mark the supplier as active once approval is completed.</div>
            </div>
        </section>
        <section class="form-panel">
            <h2>Add Supplier</h2>
            <p class="subtitle">Enter supplier information to create a new record.</p>
            <div class="alert">${message}</div>
            <form action="/suppliers/register" method="post">
                <div class="form-grid">
                    <label>
                        Company name
                        <input type="text" name="companyName" placeholder="ABC Distributors" required>
                    </label>
                    <label>
                        Supplier category
                        <select name="category" required>
                            <option value="">Select category</option>
                            <option value="LOCAL">Local</option>
                            <option value="IMPORT">Import</option>
                        </select>
                    </label>
                    <label>
                        Contact person
                        <input type="text" name="contactPerson" placeholder="Nimal Perera" required>
                    </label>
                    <label>
                        Phone number
                        <input type="tel" name="phone" placeholder="0771234567" required>
                    </label>
                    <label class="full-width">
                        Email address
                        <input type="email" name="email" placeholder="supplier@sims.com" required>
                    </label>
                    <label>
                        City
                        <input type="text" name="city" placeholder="Colombo">
                    </label>
                    <label>
                        Supply lead time
                        <input type="text" name="leadTime" placeholder="3 working days">
                    </label>
                    <label class="full-width">
                        Address
                        <textarea name="address" placeholder="Enter supplier address"></textarea>
                    </label>
                    <label class="full-width">
                        Notes
                        <textarea name="notes" placeholder="Product range, payment terms, delivery conditions, or approval notes"></textarea>
                    </label>
                </div>
                <label class="checkbox-label">
                    <input type="checkbox" name="active" checked>
                    Mark this supplier as active and available for purchasing.
                </label>
                <button type="submit">Save supplier</button>
            </form>
            <p class="switch-link">Need to review records first? <a href="/suppliers">Back to suppliers</a></p>
        </section>
    </main>
</body>
</html>
