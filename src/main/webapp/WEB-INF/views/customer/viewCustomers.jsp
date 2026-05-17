<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Viewcustomers | Customer" />
    <jsp:param name="activeMenu" value="customers" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Customers</h1>
                <p>View customer contact details saved in the system.</p>
            </div>
            <div class="actions">
                <a class="button button-primary" href="/customers/add">Add Customer</a>
            </div>
        </header>

        <section aria-label="Customers table">
            <% if (request.getAttribute("message") != null) { %>
            <div class="message message-success"><%= request.getAttribute("message") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
            <div class="message message-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <div class="toolbar">
                <h3>Customer List</h3>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        java.util.List<com.inventory.sims.customer.Customer> customerList =
                                (java.util.List<com.inventory.sims.customer.Customer>) request.getAttribute("customers");
                        if (customerList != null && !customerList.isEmpty()) {
                            for (com.inventory.sims.customer.Customer customer : customerList) {
                    %>
                    <tr>
                        <td><span class="badge"><%= customer.getId() %></span></td>
                        <td><%= customer.getName() %></td>
                        <td><%= customer.getEmail() %></td>
                        <td><%= customer.getPhone() %></td>
                        <td><%= customer.getAddress() == null || customer.getAddress().isBlank() ? "-" : customer.getAddress() %></td>
                        <td>
                            <div class="table-actions">
                                <a href="/customers/details/<%= customer.getId() %>" title="View"><i class="ph ph-eye"></i></a>
                                <a class="action-update" href="/customers/edit/<%= customer.getId() %>" title="Edit"><i class="ph ph-pencil-simple"></i></a>
                                <form class="delete-form" action="/customers/delete/<%= customer.getId() %>" method="post" onsubmit="return confirm('Delete customer <%= customer.getId() %>?');" style="margin:0;">
                                    <button type="submit" class="delete-button" title="Delete"><i class="ph ph-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" class="empty">No customers found. Click "Add Customer" to create one.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

