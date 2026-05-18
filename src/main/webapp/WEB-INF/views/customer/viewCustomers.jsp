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
                <div class="search">
                    <i class="ph ph-magnifying-glass search-icon"></i>
                    <input type="search" id="customerSearchInput" placeholder="Search by id, name, email, phone, or address..." onkeyup="filterCustomerTable()">
                </div>
                <span id="customerCount" style="font-size: 14px; color: var(--text-muted); font-weight: 500;"></span>
            </div>

            <div class="table-wrap">
                <table id="customerTable">
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

        <script>
            function filterCustomerTable() {
                var input = document.getElementById("customerSearchInput");
                var filter = input.value.toUpperCase();
                var table = document.getElementById("customerTable");
                var tbody = table.getElementsByTagName("tbody")[0];
                var rows = tbody.getElementsByTagName("tr");
                var visibleCount = 0;

                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].getElementsByTagName("td").length === 1) continue;

                    var textContent = rows[i].textContent || rows[i].innerText;
                    if (textContent.toUpperCase().indexOf(filter) > -1) {
                        rows[i].style.display = "";
                        visibleCount++;
                    } else {
                        rows[i].style.display = "none";
                    }
                }

                document.getElementById("customerCount").innerText = visibleCount + " customer" + (visibleCount === 1 ? "" : "s") + " found";
            }

            filterCustomerTable();
        </script>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
