<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | SIMS</title>
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
        }

        .shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 240px 1fr;
        }

        .sidebar {
            background: #17324d;
            color: #ffffff;
            padding: 28px 22px;
        }

        .brand {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 34px;
        }

        .nav {
            display: grid;
            gap: 10px;
        }

        .nav a {
            color: #d7e4ef;
            text-decoration: none;
            padding: 12px 14px;
            border-radius: 6px;
        }

        .nav a.active,
        .nav a:hover {
            background: #244b70;
            color: #ffffff;
        }

        .main {
            padding: 34px;
        }

        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 28px;
        }

        h1 {
            margin: 0 0 8px;
            font-size: 30px;
        }

        p {
            margin: 0;
            color: #5e6b7d;
            line-height: 1.6;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
            padding: 0 16px;
            border-radius: 6px;
            background: #17324d;
            color: #ffffff;
            text-decoration: none;
            font-weight: 700;
            border: 0;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
        }

        .card {
            background: #ffffff;
            border: 1px solid #d9e1ea;
            border-radius: 8px;
            padding: 22px;
            min-height: 150px;
            box-shadow: 0 12px 30px rgba(25, 40, 70, 0.08);
        }

        .card h2 {
            margin: 0 0 10px;
            font-size: 18px;
        }

        .card a {
            display: inline-flex;
            margin-top: 18px;
            color: #0f5c9e;
            font-weight: 700;
            text-decoration: none;
        }

        @media (max-width: 760px) {
            .shell {
                grid-template-columns: 1fr;
            }

            .sidebar {
                padding: 20px;
            }

            .nav {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .main {
                padding: 24px;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="shell">
    <aside class="sidebar">
        <div class="brand">SIMS</div>
        <nav class="nav" aria-label="Main navigation">
            <a href="/dashboard" class="active">Dashboard</a>
            <a href="/users">Users</a>
            <a href="/users/register">Register</a>
            <a href="/users/login">Logout</a>
        </nav>
    </aside>

    <main class="main">
        <div class="topbar">
            <div>
                <h1>Dashboard</h1>
                <p>Welcome to the Stock Inventory Management System.</p>
            </div>
            <a class="button" href="/users/login">Logout</a>
        </div>

        <section class="grid" aria-label="Dashboard modules">
            <div class="card">
                <h2>User Management</h2>
                <p>Open user records and manage system accounts.</p>
                <a href="/users">View users</a>
            </div>
            <div class="card">
                <h2>Products</h2>
                <p>Product management module placeholder.</p>
            </div>
            <div class="card">
                <h2>Stock</h2>
                <p>Stock movement module placeholder.</p>
            </div>
        </section>
    </main>
</div>
</body>
</html>
