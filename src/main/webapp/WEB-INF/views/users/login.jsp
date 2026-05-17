<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | InventoryPro</title>
    <!-- Google Fonts: Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Phosphor Icons -->
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --primary: #6366F1;
            --primary-hover: #4f46e5;
            --secondary: #06B6D4;
            --bg-main: #f8fafc;
            --card-bg: #ffffff;
            --border-color: #e2e8f0;
            --text-main: #0f172a;
            --text-muted: #64748B;
            --gradient-start: #eef2ff;
            --gradient-end: #ecfeff;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-main);
            color: var(--text-main);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 24px;
        }

        .auth-shell {
            width: min(100%, 1000px);
            min-height: 600px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.04);
        }

        .auth-panel {
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            padding: 48px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
        }

        .brand {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .auth-panel h1 {
            margin: 60px 0 16px;
            font-size: 40px;
            font-weight: 700;
            line-height: 1.2;
            color: var(--text-main);
        }
        
        .auth-panel h1 span {
            color: var(--primary);
        }

        .auth-panel p {
            font-size: 16px;
            line-height: 1.6;
            color: var(--text-muted);
            max-width: 360px;
        }

        .status-list {
            display: grid;
            gap: 16px;
            margin-top: 40px;
        }

        .status-item {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--text-main);
            font-weight: 500;
            font-size: 15px;
        }

        .status-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .form-panel {
            padding: 60px 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-panel h2 {
            margin: 0 0 8px;
            font-size: 32px;
            font-weight: 700;
            color: var(--text-main);
        }

        .form-panel .subtitle {
            margin: 0 0 32px;
            color: var(--text-muted);
            font-size: 15px;
        }

        .alert {
            display: none;
            margin-bottom: 24px;
            padding: 14px 16px;
            border-radius: 8px;
            border: 1px solid #fecaca;
            color: #991b1b;
            background: #fff1f2;
            font-size: 14px;
            font-weight: 500;
        }

        .alert[style],
        .alert:not(:empty) {
            display: block;
        }

        form {
            display: grid;
            gap: 20px;
        }

        label {
            display: grid;
            gap: 8px;
            font-weight: 600;
            color: var(--text-main);
            font-size: 14px;
        }

        input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-family: 'Outfit', sans-serif;
            font-size: 15px;
            color: var(--text-main);
            background: var(--bg-main);
            transition: all 0.2s ease;
            outline: none;
        }

        input:focus {
            border-color: var(--primary);
            background: var(--card-bg);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 14px;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            color: var(--text-muted);
            cursor: pointer;
        }

        .checkbox-label input {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--primary);
        }

        a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        a:hover {
            color: var(--primary-hover);
        }

        button {
            margin-top: 8px;
            padding: 14px;
            border: none;
            border-radius: 12px;
            background: var(--primary);
            color: white;
            font-family: 'Outfit', sans-serif;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
        }

        button:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        .switch-link {
            margin-top: 32px;
            color: var(--text-muted);
            text-align: center;
            font-size: 15px;
        }

        @media (max-width: 860px) {
            .auth-shell {
                grid-template-columns: 1fr;
            }
            .auth-panel {
                padding: 32px;
                min-height: 400px;
            }
            .form-panel {
                padding: 40px 32px;
            }
        }
    </style>
</head>
<body>
    <main class="auth-shell">
        <section class="auth-panel" aria-label="System information">
            <div>
                <div class="brand"><i class="ph ph-squares-four"></i> InventoryPro</div>
                <h1>Inventory access for <span>your team</span></h1>
                <p>Sign in to manage products, suppliers, stock movements, alerts, and user accounts from one vibrant system.</p>
            </div>
            <div class="status-list" aria-label="Available modules">
                <div class="status-item"><div class="status-icon"><i class="ph ph-trend-up"></i></div><span>Live Stock monitoring</span></div>
                <div class="status-item"><div class="status-icon"><i class="ph ph-truck"></i></div><span>Supplier records</span></div>
                <div class="status-item"><div class="status-icon"><i class="ph ph-users"></i></div><span>User management</span></div>
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
                </div>

                <button type="submit">Sign in</button>
            </form>

        </section>
    </main>
</body>
</html>
