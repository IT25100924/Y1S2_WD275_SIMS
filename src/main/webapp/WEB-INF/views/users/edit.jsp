<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.inventory.sims.user.User" %>
<%@ page import="com.inventory.sims.user.UserType" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%!
    private String text(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value);
    }

    private String attribute(String value) {
        return HtmlUtils.htmlEscape(value == null ? "" : value, "UTF-8");
    }
%>
<%
    User user = (User) request.getAttribute("user");
    Object message = request.getAttribute("message");
    String fullName = user == null ? "" : ((user.getFirstName() == null ? "" : user.getFirstName()) + " " + (user.getLastName() == null ? "" : user.getLastName())).trim();
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Edit | Users" />
    <jsp:param name="activeMenu" value="users" />
</jsp:include>

            <header class="page-header">
                <div class="page-title">
                    <h1>Edit User</h1>
                    <p>Update account details for <%= text(fullName.isBlank() ? user.getId() : fullName) %>.</p>
                </div>
                <a class="button button-secondary" href="/users">Back to users</a>
            </header>

            <section class="form-card">
                <% if (message != null) { %>
                    <div class="alert"><%= text(message.toString()) %></div>
                <% } %>

                <p class="form-note">Leave password fields blank to keep the current password.</p>

                <form action="/users/edit/<%= attribute(user.getId()) %>" method="post">
                    <div class="form-group">
                        <label for="userId">User ID</label>
                        <input type="text" id="userId" class="form-control" value="<%= attribute(user.getId()) %>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="role">User role</label>
                        <select name="role" id="role" class="form-control" required>
                            <option value="ADMIN" <%= user.getRole() == UserType.ADMIN ? "selected" : "" %>>Admin</option>
                            <option value="STAFF" <%= user.getRole() == UserType.STAFF ? "selected" : "" %>>Staff</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="firstName">First name</label>
                        <input type="text" name="firstName" id="firstName" class="form-control" value="<%= attribute(user.getFirstName()) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="lastName">Last name</label>
                        <input type="text" name="lastName" id="lastName" class="form-control" value="<%= attribute(user.getLastName()) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email address</label>
                        <input type="email" name="email" id="email" class="form-control" value="<%= attribute(user.getEmail()) %>" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone number</label>
                        <input type="tel" name="phone" id="phone" class="form-control" value="<%= attribute(user.getPhone()) %>">
                    </div>

                    <div class="form-group">
                        <label for="password">New password</label>
                        <input type="password" name="password" id="password" class="form-control" minlength="6" autocomplete="new-password">
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm new password</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" minlength="6" autocomplete="new-password">
                    </div>

                    <div style="margin-bottom: 24px; display: flex; align-items: center; gap: 10px;">
                        <input type="checkbox" name="active" id="active" style="width: 18px; height: 18px; cursor: pointer; accent-color: var(--primary);" <%= user.isActive() ? "checked" : "" %>>
                        <label for="active" style="margin: 0; font-weight: 500; color: var(--text-muted); cursor: pointer;">Keep this user account active.</label>
                    </div>

                    <button class="button button-primary" type="submit">Update user</button>
                </form>
            </section>
        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

