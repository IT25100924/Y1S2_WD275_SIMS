<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | SIMS</title>
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
            width: min(100%, 1060px);
            display: grid;
            grid-template-columns: 0.9fr 1.1fr;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.04);
        }

        .info-panel {
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

        .info-panel h1 {
            margin: 60px 0 16px;
            font-size: 40px;
            font-weight: 700;
            line-height: 1.2;
            color: var(--text-main);
        }

        .info-panel p {
            font-size: 16px;
            line-height: 1.6;
            color: var(--text-muted);
            max-width: 360px;
        }

        .role-note {
            margin-top: 40px;
            padding: 24px;
            border-radius: 12px;
            background: rgba(99, 102, 241, 0.1);
            color: var(--text-main);
            font-size: 15px;
            line-height: 1.6;
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

        .subtitle {
            margin: 0 0 32px;
            color: var(--text-muted);
            font-size: 15px;
        }

        .alert {
            display: none;
            margin-bottom: 24px;
            padding: 14px 16px;
            border-radius: 8px;
            border: 1px solid #bbf7d0;
            color: #166534;
            background: #f0fdf4;
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        label {
            display: grid;
            gap: 8px;
            font-weight: 600;
            color: var(--text-main);
            font-size: 14px;
        }

        input,
        select {
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

        input:focus,
        select:focus {
            border-color: var(--primary);
            background: var(--card-bg);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .full-width {
            grid-column: 1 / -1;
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

        a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        a:hover {
            color: var(--primary-hover);
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
            .info-panel {
                padding: 32px;
                min-height: 400px;
            }
            .form-panel {
                padding: 40px 32px;
            }
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <main class="auth-shell">
        <section class="info-panel" aria-label="Registration information">
            <div>
                <div class="brand"><i class="ph ph-squares-four"></i> SIMS</div>
                <h1>Create a <span>system user</span></h1>
                <p>Add a staff or admin account for the Stock Inventory Management System.</p>
                <div class="role-note">Admin users can manage users and system records. Staff users can work with day-to-day inventory tasks.</div>
            </div>
        </section>

        <section class="form-panel">
            <h2>Register</h2>
            <p class="subtitle">Enter the user details and choose an account role.</p>

            <div class="alert">${message}</div>

            <form action="/users/register" method="post">
                <div class="form-grid">
                    <label>
                        First name
                        <input type="text" name="firstName" autocomplete="given-name" placeholder="First name" required>
                    </label>

                    <label>
                        Last name
                        <input type="text" name="lastName" autocomplete="family-name" placeholder="Last name" required>
                    </label>

                    <label class="full-width">
                        Email address
                        <input type="email" name="email" autocomplete="email" placeholder="user@sims.com" required>
                    </label>

                    <label>
                        Phone number
                        <input type="tel" name="phone" autocomplete="tel" placeholder="0771234567">
                    </label>

                    <label>
                        User role
                        <select name="role" required>
                            <option value="">Select role</option>
                            <option value="ADMIN">Admin</option>
                            <option value="STAFF">Staff</option>
                        </select>
                    </label>

                    <label>
                        Password
                        <input type="password" name="password" autocomplete="new-password" placeholder="Create password" minlength="6" required>
                    </label>

                    <label>
                        Confirm password
                        <input type="password" name="confirmPassword" autocomplete="new-password" placeholder="Repeat password" minlength="6" required>
                    </label>
                </div>

                <label class="checkbox-label">
                    <input type="checkbox" name="active" checked>
                    Activate this user account immediately.
                </label>

                <button type="submit">Create user</button>
            </form>

            <p class="switch-link">Already registered? <a href="/users/login">Back to login</a></p>
        </section>
    </main>
</body>
</html>
