<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | SIMS</title>
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

        .auth-shell {
            width: min(100%, 980px);
            min-height: 560px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: #ffffff;
            border: 1px solid #d9e1ea;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 18px 48px rgba(25, 40, 70, 0.12);
        }

        .auth-panel {
            background: #17324d;
            color: #ffffff;
            padding: 44px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .brand {
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0;
            text-transform: uppercase;
        }

        .auth-panel h1 {
            margin: 96px 0 16px;
            font-size: 36px;
            line-height: 1.15;
        }

        .auth-panel p {
            margin: 0;
            max-width: 360px;
            line-height: 1.7;
            color: #d7e4ef;
        }

        .status-list {
            display: grid;
            gap: 14px;
            margin-top: 34px;
        }

        .status-item {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #eef7ff;
            font-size: 14px;
        }

        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 999px;
            background: #38bdf8;
            flex: 0 0 auto;
        }

        .form-panel {
            padding: 56px 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-panel h2 {
            margin: 0 0 8px;
            font-size: 28px;
            color: #111827;
        }

        .form-panel .subtitle {
            margin: 0 0 32px;
            color: #64748b;
            line-height: 1.5;
        }

        .alert {
            display: none;
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 6px;
            border: 1px solid #fecaca;
            color: #991b1b;
            background: #fff1f2;
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

        label {
            display: grid;
            gap: 8px;
            font-weight: 700;
            color: #263548;
            font-size: 14px;
        }

        input {
            width: 100%;
            min-height: 46px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 10px 12px;
            font: inherit;
            color: #111827;
            background: #ffffff;
        }

        input:focus {
            border-color: #2563eb;
            outline: 3px solid rgba(37, 99, 235, 0.16);
        }

        .row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            font-size: 14px;
        }

        .checkbox-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 400;
            color: #475569;
        }

        .checkbox-label input {
            width: 16px;
            height: 16px;
            min-height: 16px;
            padding: 0;
        }

        a {
            color: #1d4ed8;
            text-decoration: none;
            font-weight: 700;
        }

        a:hover {
            text-decoration: underline;
        }

        button {
            min-height: 48px;
            border: 0;
            border-radius: 6px;
            background: #1d4ed8;
            color: #ffffff;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
        }

        button:hover {
            background: #1e40af;
        }

        .switch-link {
            margin-top: 26px;
            color: #64748b;
            text-align: center;
        }

        @media (max-width: 760px) {
            body {
                align-items: stretch;
                padding: 0;
            }

            .auth-shell {
                min-height: 100vh;
                grid-template-columns: 1fr;
                border: 0;
                border-radius: 0;
            }

            .auth-panel {
                padding: 28px;
            }

            .auth-panel h1 {
                margin: 44px 0 14px;
                font-size: 30px;
            }

            .form-panel {
                padding: 36px 28px;
            }
        }
    </style>
</head>
<body>
    <main class="auth-shell">
        <section class="auth-panel" aria-label="System information">
            <div>
                <div class="brand">SIMS</div>
                <h1>Inventory access for your team</h1>
                <p>Sign in to manage products, suppliers, stock movements, alerts, and user accounts from one system.</p>
            </div>
            <div class="status-list" aria-label="Available modules">
                <div class="status-item"><span class="status-dot"></span><span>Stock monitoring</span></div>
                <div class="status-item"><span class="status-dot"></span><span>Supplier records</span></div>
                <div class="status-item"><span class="status-dot"></span><span>User management</span></div>
            </div>
        </section>

        <section class="form-panel">
            <h2>Login</h2>
            <p class="subtitle">Use your registered email and password.</p>

            <div class="alert">${error}${message}</div>

            <form action="/users/login" method="post">
                <label>
                    Email address
                    <input type="email" name="email" autocomplete="email" placeholder="admin@sims.com" required>
                </label>

                <label>
                    Password
                    <input type="password" name="password" autocomplete="current-password" placeholder="Enter password" required>
                </label>

                <div class="row">
                    <label class="checkbox-label">
                        <input type="checkbox" name="rememberMe">
                        Remember me
                    </label>
                    <a href="/users/register">Create account</a>
                </div>

                <button type="submit">Sign in</button>
            </form>

            <p class="switch-link">New user? <a href="/users/register">Register here</a></p>
        </section>
    </main>
</body>
</html>
