<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Addcustomer | Customer" />
    <jsp:param name="activeMenu" value="customers" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Add New Customer</h1>
                <p>Enter customer contact details for sales and order records.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/customers">View Customers</a>
                <a class="button button-secondary" href="/dashboard">Cancel</a>
            </div>
        </header>

        <div class="form-card">
            <% if (request.getAttribute("message") != null) { %>
            <div class="message message-success"><%= request.getAttribute("message") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
            <div class="message message-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="/customers/add" method="post">
                <div class="form-group">
                    <label for="name">Customer Name</label>
                    <input type="text" id="name" name="name" class="form-control" required placeholder="e.g. Nimal Perera">
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required placeholder="e.g. customer@example.com">
                </div>

                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-control" required placeholder="e.g. 0771234567">
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-control" placeholder="Customer address"></textarea>
                </div>

                <button type="submit" class="button button-primary">Save Customer</button>
            </form>
        </div>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

