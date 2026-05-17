<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.inventory.sims.supplier.Supplier" %>
<%@ page import="java.util.List" %>
<%
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
    String keyword = (String) request.getAttribute("keyword");
    Object message = request.getAttribute("message");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Suppliers | Supplier" />
    <jsp:param name="activeMenu" value="suppliers" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Supplier Records</h1>
                <p>Manage each supplier as a row record with direct actions.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/dashboard">Back to dashboard</a>
                <a class="button button-primary" href="/suppliers/register">Add supplier</a>
            </div>
        </header>

        <% if (message != null) { %>
        <div class="flash"><%= message %></div>
        <% } %>

        <section class="summary-grid" aria-label="Supplier summary">
            <div class="summary-card" style="border-left: 4px solid #6366F1;"><span>Total records</span><strong>${totalSuppliers}</strong></div>
            <div class="summary-card" style="border-left: 4px solid #10b981;"><span>Active</span><strong>${activeSuppliers}</strong></div>
            <div class="summary-card" style="border-left: 4px solid #f59e0b;"><span>Pending</span><strong>${pendingSuppliers}</strong></div>
        </section>

        <section aria-label="Supplier records table">
            <div class="toolbar">
                <form class="search" action="/suppliers" method="get" onsubmit="event.preventDefault();">
                    <i class="ph ph-magnifying-glass search-icon"></i>
                    <input type="search" id="searchInput" name="keyword" placeholder="Search by id, company, contact, city, status..." value="<%= keyword == null ? "" : keyword %>" onkeyup="filterTable()">
                    <button type="submit" style="display: none;">Search</button>
                    <% if (keyword != null && !keyword.isEmpty()) { %>
                    <a href="/suppliers" class="button button-secondary" style="white-space: nowrap;">Clear Filters</a>
                    <% } %>
                </form>
            </div>
            <div class="table-wrap">
                <table id="suppliersTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Company</th>
                        <th>Contact</th>
                        <th>City</th>
                        <th>Lead time</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (suppliers == null || suppliers.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="8" class="empty">No supplier records found.</td>
                    </tr>
                    <%
                        } else {
                            for (Supplier supplier : suppliers) {
                                String categoryClass = "IMPORT".equalsIgnoreCase(supplier.getCategory()) ? "badge badge-import" : "badge badge-local";
                                String statusClass = "PENDING".equalsIgnoreCase(supplier.getStatus()) ? "badge badge-pending" : "badge badge-active";
                    %>
                    <tr>
                        <td><%= supplier.getId() %></td>
                        <td><%= supplier.getCompanyName() %></td>
                        <td><%= supplier.getContactPerson() %></td>
                        <td><%= supplier.getCity() %></td>
                        <td><%= supplier.getLeadTime() %></td>
                        <td><span class="<%= categoryClass %>"><%= supplier.getCategory() %></span></td>
                        <td><span class="<%= statusClass %>"><%= supplier.getStatus() %></span></td>
                        <td>
                            <div class="row-actions">
                                <a href="/suppliers/details/<%= supplier.getId() %>" title="View"><i class="ph ph-eye"></i></a>
                                <a class="action-update" href="/suppliers/edit/<%= supplier.getId() %>" title="Edit"><i class="ph ph-pencil-simple"></i></a>
                                <form action="/suppliers/delete/<%= supplier.getId() %>" method="post" onsubmit="return confirm('Delete this supplier record?');" style="margin:0;">
                                    <button class="action-delete" type="submit" title="Delete"><i class="ph ph-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </section>

        <script>
            function filterTable() {
                var input = document.getElementById("searchInput");
                var filter = input.value.toUpperCase();
                var table = document.getElementById("suppliersTable");
                var tbody = table.getElementsByTagName("tbody")[0];
                var tr = tbody.getElementsByTagName("tr");

                for (var i = 0; i < tr.length; i++) {
                    if (tr[i].getElementsByTagName("td").length === 1) continue;
                    
                    var textContent = tr[i].textContent || tr[i].innerText;
                    
                    if (textContent.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        </script>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

