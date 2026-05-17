<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.inventory.sims.user.User" %>
<%@ page import="com.inventory.sims.user.UserType" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%!
    private String text(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value);
    }

    private String attribute(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value, "UTF-8");
    }

    private long longValue(Object value) {
        return value instanceof Number number ? number.longValue() : 0L;
    }

    private String firstLetter(User user) {
        if (user == null || user.getFirstName() == null || user.getFirstName().isBlank()) {
            return "U";
        }
        return user.getFirstName().trim().substring(0, 1).toUpperCase();
    }

    private String fullName(User user) {
        if (user == null) {
            return "";
        }
        String first = user.getFirstName() == null ? "" : user.getFirstName().trim();
        String last = user.getLastName() == null ? "" : user.getLastName().trim();
        return (first + " " + last).trim();
    }
%>
<%
    List<User> users = (List<User>) request.getAttribute("users");
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
                <div class="summary-card" style="border-left: 4px solid #6366F1;">
                    <span>Total users</span>
                    <strong><%= totalUsers %></strong>
                </div>
                <div class="summary-card" style="border-left: 4px solid #ef4444;">
                    <span>Admin users</span>
                    <strong><%= adminUsers %></strong>
                </div>
                <div class="summary-card" style="border-left: 4px solid #3b82f6;">
                    <span>Staff users</span>
                    <strong><%= staffUsers %></strong>
                </div>
                <div class="summary-card" style="border-left: 4px solid #10b981;">
                    <span>Active users</span>
                    <strong><%= activeUsers %></strong>
                </div>
            </section>

            <% if (message != null) { %>
                <div class="flash"><%= text(message.toString()) %></div>
            <% } %>

            <section aria-label="Users table">
                <div class="toolbar">
                    <form class="search" action="/users" method="get" onsubmit="event.preventDefault();">
                        <i class="ph ph-magnifying-glass search-icon"></i>
                        <input type="search" id="searchInput" name="keyword" placeholder="Search by name, email, phone, role, or ID..." value="<%= attribute(keyword) %>" onkeyup="filterTable()">
                        <button type="submit" style="display: none;">Search</button>
                        <% if (keyword != null && !keyword.isEmpty()) { %>
                        <a href="/users" class="button button-secondary" style="white-space: nowrap;">Clear Filters</a>
                        <% } %>
                    </form>
                    <div id="usersCount" style="font-size: 14px; color: var(--text-muted); font-weight: 500;">
                        <%= filteredUsers %> users found
                    </div>
                </div>

                <div class="table-wrap">
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
                                    <td colspan="6" class="empty-state">No users found.</td>
                                </tr>
                            <% } else { %>
                                <% for (User user : users) { %>
                                    <tr>
                                        <td><%= text(user.getId()) %></td>
                                        <td>
                                            <div class="user-cell">
                                                <span class="avatar"><%= text(firstLetter(user)) %></span>
                                                <div>
                                                    <span class="user-name"><%= text(fullName(user)) %></span>
                                                    <span class="user-email"><%= text(user.getEmail()) %></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%= text(user.getPhone()) %></td>
                                        <td>
                                            <% boolean staff = user.getRole() == UserType.STAFF; %>
                                            <span class="badge <%= staff ? "badge-staff" : "badge-admin" %>"><%= text(user.getRole() == null ? "" : user.getRole().name()) %></span>
                                        </td>
                                        <td>
                                            <span class="badge <%= user.isActive() ? "badge-active" : "badge-inactive" %>"><%= user.isActive() ? "Active" : "Inactive" %></span>
                                        </td>
                                        <td>
                                            <div class="row-actions">
                                                <a href="/users/details/<%= attribute(user.getId()) %>" title="View"><i class="ph ph-eye"></i></a>
                                                <a href="/users/edit/<%= attribute(user.getId()) %>" title="Edit"><i class="ph ph-pencil-simple"></i></a>
                                                <form action="/users/delete/<%= attribute(user.getId()) %>" method="post" onsubmit="return confirm('Delete this user account?');" style="margin:0;">
                                                    <button type="submit" title="Delete"><i class="ph ph-trash"></i></button>
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
                    var filter = input.value.toUpperCase();
                    var table = document.getElementById("usersTable");
                    var tbody = table.getElementsByTagName("tbody")[0];
                    var tr = tbody.getElementsByTagName("tr");
                    var visibleCount = 0;

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
            </script>

        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
