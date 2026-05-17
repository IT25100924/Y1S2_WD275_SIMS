<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="View | Stockout" />
    <jsp:param name="activeMenu" value="stockout" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Stockout Records</h1>
                <p>View inventory items issued from stock.</p>
            </div>
            <div class="actions">
                <a class="button button-primary" href="/stockout/create">Create Stockout</a>
                <a class="button button-secondary" href="/dashboard">Dashboard</a>
            </div>
        </header>

        <section aria-label="Stockout records table">
            <div class="alert">${message}</div>
            <%
                java.util.List<com.inventory.sims.stockout.StockOut> stockOutRecords =
                        (java.util.List<com.inventory.sims.stockout.StockOut>) request.getAttribute("stockOutRecords");
                int stockOutCount = stockOutRecords == null ? 0 : stockOutRecords.size();
            %>
            <div class="toolbar">
                <h2>Record List</h2>
                <span class="record-count"><%= stockOutCount %> record<%= stockOutCount == 1 ? "" : "s" %></span>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Stockout ID</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Date</th>
                        <th>Reason</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (stockOutRecords != null && !stockOutRecords.isEmpty()) {
                            for (com.inventory.sims.stockout.StockOut stockOut : stockOutRecords) {
                    %>
                    <tr>
                        <td><strong><%= stockOut.getId() %></strong></td>
                        <td><%= stockOut.getProductName() %></td>
                        <td><span class="badge"><%= stockOut.getQuantity() %> out</span></td>
                        <td><%= stockOut.getStockOutDate() == null ? "-" : stockOut.getStockOutDate() %></td>
                        <td><%= stockOut.getReason() %></td>
                        <td>
                            <div class="row-actions">
                                <a href="/stockout/details/<%= stockOut.getId() %>" title="View"><i class="ph ph-eye"></i></a>
                                <a href="/stockout/update/<%= stockOut.getId() %>" title="Edit"><i class="ph ph-pencil-simple"></i></a>
                                <form class="delete-form" action="/stockout/delete/<%= stockOut.getId() %>" method="post"
                                      onsubmit="return confirm('Delete stockout record <%= stockOut.getId() %>?');" style="margin:0;">
                                    <button type="submit" title="Delete"><i class="ph ph-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td class="empty" colspan="6">No stockout records found. Create a stockout record to show it here.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

