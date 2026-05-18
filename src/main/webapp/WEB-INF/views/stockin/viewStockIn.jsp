<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Viewstockin | Stockin" />
    <jsp:param name="activeMenu" value="stockin" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Stock In Records</h1>
                <p>Review incoming stock entries saved in the system.</p>
            </div>
            <div class="actions">
                <a class="button button-primary" href="/stockin/create">Add Stock In</a>
            </div>
        </header>

        <%
            java.util.List<com.inventory.sims.stockin.StockIn> stockIns =
                    (java.util.List<com.inventory.sims.stockin.StockIn>) request.getAttribute("stockIns");
            int totalRecords = stockIns == null ? 0 : stockIns.size();
            int totalQuantity = 0;
            double totalCost = 0;
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            if (stockIns != null) {
                for (com.inventory.sims.stockin.StockIn stockIn : stockIns) {
                    totalQuantity += stockIn.getQuantity();
                    totalCost += stockIn.getTotalCost();
                }
            }
        %>

        <% if (success != null && !success.isBlank()) { %>
        <div class="alert alert-success"><%= success %></div>
        <% } %>
        <% if (error != null && !error.isBlank()) { %>
        <div class="alert alert-error"><%= error %></div>
        <% } %>

        <section class="summary-grid" aria-label="Stock in summary">
            <div class="summary-card" style="border-left: 4px solid #6366F1;">
                <span>Total records</span>
                <strong><%= totalRecords %></strong>
            </div>
            <div class="summary-card" style="border-left: 4px solid #10b981;">
                <span>Total quantity in</span>
                <strong><%= totalQuantity %></strong>
            </div>
            <div class="summary-card" style="border-left: 4px solid #3b82f6;">
                <span>Total stock cost</span>
                <strong>LKR <%= String.format("%.2f", totalCost) %></strong>
            </div>
        </section>

        <section aria-label="Stock in table">
            <div class="toolbar">
                <h2>Stock In List</h2>
                <a class="button button-secondary" href="/stockin">Refresh</a>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Product</th>
                        <th>Supplier</th>
                        <th>Quantity</th>
                        <th>Total Cost (LKR)</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (stockIns != null && !stockIns.isEmpty()) {
                            for (com.inventory.sims.stockin.StockIn stockIn : stockIns) {
                    %>
                    <tr>
                        <td><span class="badge"><%= stockIn.getId() %></span></td>
                        <td><%= stockIn.getReceivedDate() %></td>
                        <td>
                            <strong><%= stockIn.getProductName() %></strong>
                        </td>
                        <td><%= stockIn.getSupplierName() %></td>
                        <td><%= stockIn.getQuantity() %></td>
                        <td class="money">LKR <%= String.format("%.2f", stockIn.getTotalCost()) %></td>
                        <td>
                            <div class="table-actions">
                                <a href="/stockin/details/<%= stockIn.getId() %>" title="View"><i class="ph ph-eye"></i></a>
                                <a href="/stockin/edit/<%= stockIn.getId() %>" title="Edit"><i class="ph ph-pencil-simple"></i></a>
                                <form action="/stockin/delete/<%= stockIn.getId() %>" method="post"
                                      onsubmit="return confirm('Delete stock-in record <%= stockIn.getId() %>?');" style="margin:0;">
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
                        <td colspan="7" style="text-align: center; padding: 22px; color: #64748b;">No stock-in records found.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

