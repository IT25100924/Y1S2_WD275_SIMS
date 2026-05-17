<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    com.inventory.sims.customer.Customer customer =
            (com.inventory.sims.customer.Customer) request.getAttribute("customer");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Editcustomer | Customer" />
    <jsp:param name="activeMenu" value="customers" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Edit Customer</h1>
                <p>Update contact details for customer <%= customer.getId() %>.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/customers">Cancel</a>
            </div>
        </header>

        <div class="form-card">
            <% if (request.getAttribute("error") != null) { %>
            <div class="message message-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="/customers/edit/<%= customer.getId() %>" method="post">
                <div class="form-group">
                    <label for="id">Customer ID</label>
                    <input type="text" id="id" class="form-control" value="<%= customer.getId() %>" readonly>
                </div>

                <div class="form-group">
                    <label for="name">Customer Name</label>
                    <input type="text" id="name" name="name" class="form-control" required value="<%= customer.getName() %>">
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required value="<%= customer.getEmail() %>">
                </div>

                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-control" required value="<%= customer.getPhone() %>">
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-control"><%= customer.getAddress() == null ? "" : customer.getAddress() %></textarea>
                </div>

                <button type="submit" class="button button-primary">Update Customer</button>
            </form>
        </div>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

