<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ page import="com.inventory.sims.user.User" %>
        <%@ page import="com.inventory.sims.user.UserType" %>
            <%@ page import="java.util.Collections" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="org.springframework.web.util.HtmlUtils" %>
                        <%! private String text(String value) { return HtmlUtils.htmlEscape(value==null ? "" : value); }
                            private String attribute(String value) { return HtmlUtils.htmlEscape(value==null ? "" :
                            value, "UTF-8" ); } private long longValue(Object value) { return value instanceof Number
                            number ? number.longValue() : 0L; } private String firstLetter(User user) { if (user==null
                            || user.getFirstName()==null || user.getFirstName().isBlank()) { return "U" ; } return
                            user.getFirstName().trim().substring(0, 1).toUpperCase(); } private String fullName(User
                            user) { if (user==null) { return "" ; } String first=user.getFirstName()==null ? "" :
                            user.getFirstName().trim(); String last=user.getLastName()==null ? "" :
                            user.getLastName().trim(); return (first + " " + last).trim(); } %>
                            <% List<User> users = (List<User>) request.getAttribute("users");
                                    if (users == null) {
                                    users = Collections.emptyList();
                                    }

                                    String keyword = (String) request.getAttribute("keyword");
                                    long totalUsers = longValue(request.getAttribute("totalUsers"));
                                    long adminUsers = longValue(request.getAttribute("adminUsers"));
                                    long staffUsers = longValue(request.getAttribute("staffUsers"));
                                    long activeUsers = longValue(request.getAttribute("activeUsers"));
                                    long filteredUsers = longValue(request.getAttribute("filteredUsers"));
                                    Object message = request.getAttribute("message");
                                    %>
                                    <jsp:include page="/WEB-INF/views/layout/header.jsp">
                                        <jsp:param name="pageTitle" value="Users | Users" />
                                        <jsp:param name="activeMenu" value="users" />
                                    </jsp:include>

                                    <style>
                                        .summary-card {
                                            border-radius: 20px !important;
                                            border: none !important;
                                            padding: 24px !important;
                                            transition: transform 0.2s ease, box-shadow 0.2s ease !important;
                                            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02) !important;
                                        }

                                        .summary-card:hover {
                                            transform: translateY(-2px);
                                            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.04) !important;
                                        }

                                        .summary-card span {
                                            font-size: 15px !important;
                                            color: #475569 !important;
                                            font-weight: 600 !important;
                                            text-transform: capitalize !important;
                                            letter-spacing: normal !important;
                                        }

                                        .summary-card strong {
                                            font-size: 36px !important;
                                            font-weight: 800 !important;
                                            color: #0f172a !important;
                                            display: block;
                                            margin-top: 8px;
                                        }

                                        .card-purple {
                                            background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%) !important;
                                        }

                                        .card-red {
                                            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%) !important;
                                        }

                                        .card-blue {
                                            background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%) !important;
                                        }

                                        .card-green {
                                            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%) !important;
                                        }

                                        /* Toolbar inside table-wrap */
                                        .toolbar {
                                            display: flex;
                                            align-items: center;
                                            justify-content: space-between;
                                            padding: 24px 32px;
                                            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
                                        }

                                        /* Table Section */
                                        section[aria-label="Users table"] {
                                            margin-top: 0;
                                        }

                                        .search {
                                            position: relative;
                                            flex: 1;
                                            max-width: 500px;
                                        }

                                        .search input[type="search"] {
                                            width: 100%;
                                            padding: 14px 48px 14px 48px;
                                            border-radius: 100px;
                                            border: 1px solid rgba(226, 232, 240, 0.8);
                                            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
                                            font-size: 15px;
                                            color: #1e293b;
                                            transition: all 0.3s ease;
                                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                                        }

                                        .search input[type="search"]:focus {
                                            background: #ffffff;
                                            border-color: #818cf8;
                                            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                                            outline: none;
                                        }

                                        .search .search-icon {
                                            position: absolute;
                                            left: 18px;
                                            top: 50%;
                                            transform: translateY(-50%);
                                            color: #64748b;
                                            font-size: 20px;
                                            pointer-events: none;
                                            z-index: 1;
                                        }

                                        .search .clear-btn {
                                            position: absolute;
                                            right: 18px;
                                            top: 50%;
                                            transform: translateY(-50%);
                                            background: transparent;
                                            border: none;
                                            color: #94a3b8;
                                            font-size: 18px;
                                            cursor: pointer;
                                            padding: 4px;
                                            border-radius: 50%;
                                            display: none;
                                            transition: all 0.2s ease;
                                            z-index: 2;
                                        }

                                        .search .clear-btn:hover {
                                            color: #ef4444;
                                            background: rgba(239, 68, 68, 0.1);
                                        }

                                        .table-wrap {
                                            border-radius: 24px;
                                            overflow: hidden;
                                            border: 1px solid rgba(226, 232, 240, 0.8);
                                            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
                                            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.03);
                                        }

                                        #usersTable {
                                            width: 100%;
                                            border-collapse: collapse;
                                        }

                                        #usersTable th {
                                            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                                            padding: 16px 24px;
                                            text-align: left;
                                            font-size: 13px;
                                            font-weight: 700;
                                            color: #475569;
                                            text-transform: uppercase;
                                            letter-spacing: 0.5px;
                                            border-bottom: 2px solid #e2e8f0;
                                        }

                                        #usersTable td {
                                            padding: 16px 24px;
                                            border-bottom: 1px solid #f1f5f9;
                                            vertical-align: middle;
                                            font-size: 14px;
                                            color: #334155;
                                        }

                                        #usersTable tbody tr {
                                            transition: all 0.2s ease;
                                        }

                                        #usersTable tbody tr:hover {
                                            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                                        }

                                        .user-cell {
                                            display: flex;
                                            align-items: center;
                                            gap: 16px;
                                        }

                                        .user-cell .avatar {
                                            width: 44px;
                                            height: 44px;
                                            border-radius: 12px;
                                            background: linear-gradient(135deg, #818cf8 0%, #4f46e5 100%);
                                            color: white;
                                            display: flex;
                                            align-items: center;
                                            justify-content: center;
                                            font-size: 18px;
                                            font-weight: 700;
                                            box-shadow: 0 4px 10px rgba(79, 70, 229, 0.2);
                                        }

                                        .user-name {
                                            display: block;
                                            font-weight: 700;
                                            color: #0f172a;
                                            margin-bottom: 2px;
                                        }

                                        .user-email {
                                            display: block;
                                            font-size: 13px;
                                            color: #64748b;
                                        }

                                        .row-actions {
                                            display: flex;
                                            align-items: center;
                                        }

                                        .row-actions a,
                                        .row-actions button {
                                            width: 36px;
                                            height: 36px;
                                            border-radius: 10px;
                                            display: inline-flex;
                                            align-items: center;
                                            justify-content: center;
                                            transition: all 0.2s ease;
                                            background: #f1f5f9;
                                            color: #64748b;
                                            border: none;
                                            cursor: pointer;
                                            margin-right: 8px;
                                            text-decoration: none;
                                        }

                                        .row-actions a:hover,
                                        .row-actions button:hover {
                                            transform: translateY(-2px);
                                        }

                                        .row-actions a[title="View"] {
                                            background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
                                            color: #4f46e5;
                                        }

                                        .row-actions a[title="View"]:hover {
                                            box-shadow: 0 4px 10px rgba(79, 70, 229, 0.2);
                                        }

                                        .row-actions a[title="Edit"] {
                                            background: linear-gradient(135deg, #ffedd5 0%, #fed7aa 100%);
                                            color: #ea580c;
                                        }

                                        .row-actions a[title="Edit"]:hover {
                                            box-shadow: 0 4px 10px rgba(234, 88, 12, 0.2);
                                        }

                                        .row-actions button[title="Delete"] {
                                            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
                                            color: #dc2626;
                                        }

                                        .row-actions button[title="Delete"]:hover {
                                            box-shadow: 0 4px 10px rgba(220, 38, 38, 0.2);
                                        }
                                    </style>

                                    <header class="page-header">
                                        <div class="page-title">
                                            <h1>Users</h1>
                                            <p>Manage registered system accounts and access roles.</p>
                                        </div>
                                        <div class="actions">
                                            <a class="button button-primary" href="/users/register">Add User</a>
                                        </div>
                                    </header>

                                    <section class="summary-grid" aria-label="User summary">
                                        <div class="summary-card card-purple">
                                            <span>Total users</span>
                                            <strong>
                                                <%= totalUsers %>
                                            </strong>
                                        </div>
                                        <div class="summary-card card-red">
                                            <span>Admin users</span>
                                            <strong>
                                                <%= adminUsers %>
                                            </strong>
                                        </div>
                                        <div class="summary-card card-blue">
                                            <span>Staff users</span>
                                            <strong>
                                                <%= staffUsers %>
                                            </strong>
                                        </div>
                                        <div class="summary-card card-green">
                                            <span>Active users</span>
                                            <strong>
                                                <%= activeUsers %>
                                            </strong>
                                        </div>
                                    </section>

                                    <% if (message !=null) { %>
                                        <div class="flash">
                                            <%= text(message.toString()) %>
                                        </div>
                                        <% } %>

                                            <section aria-label="Users table">
                                                <div class="table-wrap">
                                                    <div class="toolbar">
                                                        <form class="search" action="/users" method="get"
                                                            onsubmit="event.preventDefault();">
                                                            <i class="ph ph-magnifying-glass search-icon"></i>
                                                            <input type="search" id="searchInput" name="keyword"
                                                                placeholder="Search by name, email, phone, role, or ID..."
                                                                value="<%= attribute(keyword) %>"
                                                                onkeyup="filterTable()">
                                                            <button type="button" class="clear-btn" id="clearSearchBtn"
                                                                onclick="clearSearch()" title="Clear search"><i
                                                                    class="ph ph-x"></i></button>
                                                            <button type="submit" style="display: none;">Search</button>
                                                        </form>
                                                        <div id="usersCount"
                                                            style="font-size: 14px; color: var(--text-muted); font-weight: 500; background: rgba(255,255,255,0.8); padding: 8px 16px; border-radius: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.02);">
                                                            <%= filteredUsers %> users found
                                                        </div>
                                                    </div>
                                                    <table id="usersTable">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>User</th>
                                                                <th>Phone</th>
                                                                <th>Role</th>
                                                                <th>Status</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% if (users.isEmpty()) { %>
                                                                <tr>
                                                                    <td colspan="6" class="empty-state">No users found.
                                                                    </td>
                                                                </tr>
                                                                <% } else { %>
                                                                    <% for (User user : users) { %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= text(user.getId()) %>
                                                                            </td>
                                                                            <td>
                                                                                <div class="user-cell">
                                                                                    <span class="avatar">
                                                                                        <%= text(firstLetter(user)) %>
                                                                                    </span>
                                                                                    <div>
                                                                                        <span class="user-name">
                                                                                            <%= text(fullName(user)) %>
                                                                                        </span>
                                                                                        <span class="user-email">
                                                                                            <%= text(user.getEmail()) %>
                                                                                        </span>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <%= text(user.getPhone()) %>
                                                                            </td>
                                                                            <td>
                                                                                <% boolean
                                                                                    staff=user.getRole()==UserType.STAFF;
                                                                                    %>
                                                                                    <span class="badge <%= staff ? "badge-staff" : "badge-admin" %>"><%=
                                                                                            text(user.getRole()==null
                                                                                            ? "" :
                                                                                            user.getRole().name()) %>
                                                                                    </span>
                                                                            </td>
                                                                            <td>
                                                                                <span
                                                                                    class="badge <%= user.isActive() ? "badge-active" : "badge-inactive" %>"><%= user.isActive() ? "Active"
                                                                                        : "Inactive" %></span>
                                                                            </td>
                                                                            <td>
                                                                                <div class="row-actions">
                                                                                    <a href="/users/details/<%= attribute(user.getId()) %>"
                                                                                        title="View"><i
                                                                                            class="ph ph-eye"></i></a>
                                                                                    <a href="/users/edit/<%= attribute(user.getId()) %>"
                                                                                        title="Edit"><i
                                                                                            class="ph ph-pencil-simple"></i></a>
                                                                                    <form
                                                                                        action="/users/delete/<%= attribute(user.getId()) %>"
                                                                                        method="post"
                                                                                        onsubmit="return confirm('Delete this user account?');"
                                                                                        style="margin:0;">
                                                                                        <button type="submit"
                                                                                            title="Delete"><i
                                                                                                class="ph ph-trash"></i></button>
                                                                                    </form>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                            <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </section>

                                            <script>
                                                function filterTable() {
                                                    var input = document.getElementById("searchInput");
                                                    var clearBtn = document.getElementById("clearSearchBtn");
                                                    var filter = input.value.toUpperCase();
                                                    var table = document.getElementById("usersTable");
                                                    var tbody = table.getElementsByTagName("tbody")[0];
                                                    var tr = tbody.getElementsByTagName("tr");
                                                    var visibleCount = 0;

                                                    if (filter.length > 0) {
                                                        clearBtn.style.display = "block";
                                                    } else {
                                                        clearBtn.style.display = "none";
                                                    }

                                                    for (var i = 0; i < tr.length; i++) {
                                                        if (tr[i].getElementsByTagName("td").length === 1) continue; // Skip empty state row

                                                        var textContent = tr[i].textContent || tr[i].innerText;

                                                        if (textContent.toUpperCase().indexOf(filter) > -1) {
                                                            tr[i].style.display = "";
                                                            visibleCount++;
                                                        } else {
                                                            tr[i].style.display = "none";
                                                        }
                                                    }

                                                    document.getElementById('usersCount').innerText = visibleCount + " users found";
                                                }

                                                function clearSearch() {
                                                    var input = document.getElementById("searchInput");
                                                    input.value = "";
                                                    filterTable();
                                                    if (window.history.replaceState) {
                                                        window.history.replaceState(null, null, window.location.pathname);
                                                    }
                                                }

                                                window.onload = function () {
                                                    filterTable();
                                                };
                                            </script>

                                            <jsp:include page="/WEB-INF/views/layout/footer.jsp" />