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
                    <div class="form-grid">
                        <label>
                            User ID
                            <input type="text" value="<%= attribute(user.getId()) %>" readonly>
                        </label>

                        <label>
                            User role
                            <select name="role" required>
                                <option value="ADMIN" <%= user.getRole() == UserType.ADMIN ? "selected" : "" %>>Admin</option>
                                <option value="STAFF" <%= user.getRole() == UserType.STAFF ? "selected" : "" %>>Staff</option>
                            </select>
                        </label>

                        <label>
                            First name
                            <input type="text" name="firstName" value="<%= attribute(user.getFirstName()) %>" required>
                        </label>

                        <label>
                            Last name
                            <input type="text" name="lastName" value="<%= attribute(user.getLastName()) %>" required>
                        </label>

                        <label class="full-width">
                            Email address
                            <input type="email" name="email" value="<%= attribute(user.getEmail()) %>" required>
                        </label>

                        <label class="full-width">
                            Phone number
                            <input type="tel" name="phone" value="<%= attribute(user.getPhone()) %>">
                        </label>

                        <label>
                            New password
                            <input type="password" name="password" minlength="6" autocomplete="new-password">
                        </label>

                        <label>
                            Confirm new password
                            <input type="password" name="confirmPassword" minlength="6" autocomplete="new-password">
                        </label>
                    </div>

                    <label class="checkbox-label">
                        <input type="checkbox" name="active" <%= user.isActive() ? "checked" : "" %>>
                        Keep this user account active.
                    </label>

                    <button class="button button-primary" type="submit">Update user</button>
                </form>
            </section>
        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

