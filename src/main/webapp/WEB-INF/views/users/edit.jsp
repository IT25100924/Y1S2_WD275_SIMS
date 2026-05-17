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


                <form action="/users/edit/<%= attribute(user.getId()) %>" method="post">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label>User ID</label>
                            <input type="text" value="<%= attribute(user.getId()) %>" readonly style="background-color: var(--bg-sidebar);">
                        </div>

                        <div class="form-group">
                            <label>User role</label>
                            <select name="role" required>
                                <option value="ADMIN" <%= user.getRole() == UserType.ADMIN ? "selected" : "" %>>Admin</option>
                                <option value="STAFF" <%= user.getRole() == UserType.STAFF ? "selected" : "" %>>Staff</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>First name</label>
                            <input type="text" name="firstName" value="<%= attribute(user.getFirstName()) %>" required>
                        </div>

                        <div class="form-group">
                            <label>Last name</label>
                            <input type="text" name="lastName" value="<%= attribute(user.getLastName()) %>" required>
                        </div>

                        <div class="form-group" style="grid-column: span 2;">
                            <label>Email address</label>
                            <input type="email" name="email" value="<%= attribute(user.getEmail()) %>" required>
                        </div>

                        <div class="form-group" style="grid-column: span 2;">
                            <label>Phone number</label>
                            <input type="tel" name="phone" value="<%= attribute(user.getPhone()) %>">
                        </div>

                        <div style="grid-column: span 2; margin-top: 12px; margin-bottom: -10px;">
                            <p style="font-size: 13.5px; color: var(--text-muted); font-weight: 500; margin: 0; display: flex; align-items: center; gap: 6px;">
                                <i class="ph ph-info" style="font-size: 18px; color: var(--primary);"></i> 
                                Leave password fields blank to keep the current password.
                            </p>
                        </div>

                        <div class="form-group">
                            <label>New password</label>
                            <input type="password" name="password" minlength="6" autocomplete="new-password">
                        </div>

                        <div class="form-group">
                            <label>Confirm new password</label>
                            <input type="password" name="confirmPassword" minlength="6" autocomplete="new-password">
                        </div>
                    </div>

                    <hr style="border: 0; border-top: 1px solid var(--border-color); margin: 32px 0 24px 0;">

                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; margin: 0;">
                            <input type="checkbox" name="active" <%= user.isActive() ? "checked" : "" %> style="width: 18px; height: 18px; accent-color: var(--primary); cursor: pointer;">
                            <span style="font-weight: 500; font-size: 14px;">Keep this user account active.</span>
                        </label>

                        <button class="button button-primary" type="submit" style="padding: 12px 32px; font-size: 15px; border-radius: 10px;">Update user</button>
                    </div>
                </form>
            </section>
        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

