<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Stockout | SIMS</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: #172033;
            background: #eef2f6;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .stockout-shell {
            width: min(100%, 1060px);
            display: grid;
            grid-template-columns: 0.9fr 1.1fr;
            background: #ffffff;
            border: 1px solid #d9e1ea;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 18px 48px rgba(25, 40, 70, 0.12);
        }

        .info-panel {
            background: #12333f;
            color: #ffffff;
            padding: 42px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 640px;
        }

        .brand {
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .info-panel h1 {
            margin: 96px 0 16px;
            font-size: 34px;
            line-height: 1.15;
        }

        .info-panel p {
            margin: 0;
            line-height: 1.7;
            color: #d8e8ec;
        }

        .stock-note {
            margin-top: 32px;
            padding: 18px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.08);
            color: #ecfeff;
        }

        .form-panel {
            padding: 44px 48px;
        }

        .form-panel h2 {
            margin: 0 0 8px;
            font-size: 28px;
            color: #111827;
        }

        .subtitle {
            margin: 0 0 28px;
            color: #64748b;
            line-height: 1.5;
        }

        .alert {
            display: none;
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 6px;
            border: 1px solid #bbf7d0;
            color: #166534;
            background: #f0fdf4;
            font-size: 14px;
        }

        .alert[style],
        .alert:not(:empty) {
            display: block;
        }

        form {
            display: grid;
            gap: 18px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        label {
            display: grid;
            gap: 8px;
            font-weight: 700;
            color: #263548;
            font-size: 14px;
        }

        input,
        select,
        textarea {
            width: 100%;
            min-height: 46px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 10px 12px;
            font: inherit;
            color: #111827;
            background: #ffffff;
        }

        textarea {
            min-height: 98px;
            resize: vertical;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #2563eb;
            outline: 3px solid rgba(37, 99, 235, 0.16);
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .button,
        button {
            min-height: 48px;
            border-radius: 6px;
            padding: 12px 16px;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        button {
            border: 0;
            background: #1d4ed8;
            color: #ffffff;
        }

        button:hover {
            background: #1e40af;
        }

        .button-secondary {
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: #334155;
        }

        .button-secondary:hover {
            background: #f8fafc;
        }

        @media (max-width: 840px) {
            body {
                align-items: stretch;
                padding: 0;
            }

            .stockout-shell {
                grid-template-columns: 1fr;
                width: 100%;
                min-height: 100vh;
                border: 0;
                border-radius: 0;
            }

            .info-panel {
                min-height: auto;
                padding: 28px;
            }

            .info-panel h1 {
                margin: 42px 0 14px;
                font-size: 30px;
            }

            .form-panel {
                padding: 34px 28px;
            }
        }

        @media (max-width: 560px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .actions {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <main class="stockout-shell">
        <section class="info-panel" aria-label="Stockout information">
            <div>
                <div class="brand">SIMS</div>
                <h1>Create a stockout record</h1>
                <p>Record inventory items issued from stock for sales, internal use, returns, or damage adjustments.</p>
                <div class="stock-note">Use accurate product and quantity details so stock movement history stays clear.</div>
            </div>
        </section>

        <section class="form-panel">
            <h2>New stockout</h2>
            <p class="subtitle">Enter the stock issue details and submit the record.</p>

            <div class="alert">${message}</div>

            <form action="/stockout/create" method="post">
                <div class="form-grid">
                    <label>
                        Product ID
                        <input type="text" name="productId" placeholder="P001" required>
                    </label>

                    <label>
                        Product name
                        <input type="text" name="productName" placeholder="Product name" required>
                    </label>

                    <label>
                        Quantity
                        <input type="number" name="quantity" min="1" step="1" placeholder="1" required>
                    </label>

                    <label>
                        Stockout date
                        <input type="date" name="stockOutDate">
                    </label>

                    <label>
                        Issued to
                        <input type="text" name="issuedTo" placeholder="Customer, staff, or department" required>
                    </label>

                    <label>
                        Reason
                        <select name="reason" required>
                            <option value="">Select reason</option>
                            <option value="Sale">Sale</option>
                            <option value="Internal use">Internal use</option>
                            <option value="Damaged item">Damaged item</option>
                            <option value="Returned to supplier">Returned to supplier</option>
                            <option value="Other">Other</option>
                        </select>
                    </label>

                    <label class="full-width">
                        Note
                        <textarea name="note" placeholder="Optional stockout note"></textarea>
                    </label>
                </div>

                <div class="actions">
                    <button type="submit">Create stockout</button>
                    <a class="button button-secondary" href="/dashboard">Back to dashboard</a>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
