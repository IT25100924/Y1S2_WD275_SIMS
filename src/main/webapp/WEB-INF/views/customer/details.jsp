<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Details | Customer" />
    <jsp:param name="activeMenu" value="customers" />
</jsp:include>

        <header class="page-header">
            <div class="page-title">
                <h1>Customer Profile</h1>
                <p>Review customer contact information before updating records.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/customers">Back to customers</a>
                <a class="button button-primary" href="/customers/edit/${customer.id}">Edit customer</a>
            </div>
        </header>
        <section class="hero">
            <h2>${customer.name}</h2>
            <p>${customer.address}</p>
            <div class="hero-meta">
                <span class="badge">${customer.id}</span>
            </div>
        </section>
        <section class="grid" aria-label="Customer details">
            <article class="card">
                <h3>Contact Information</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Customer name</span><strong>${customer.name}</strong></div>
                    <div class="detail-item"><span>Email address</span><strong>${customer.email}</strong></div>
                    <div class="detail-item"><span>Phone number</span><strong>${customer.phone}</strong></div>
                    <div class="detail-item"><span>Address</span><p>${customer.address}</p></div>
                </div>
            </article>
            <article class="card">
                <h3>Customer Information</h3>
                <div class="detail-list">
                    <div class="detail-item"><span>Customer ID</span><strong>${customer.id}</strong></div>
                    <div class="detail-item"><span>Name</span><strong>${customer.name}</strong></div>
                    <div class="detail-item"><span>Email</span><strong>${customer.email}</strong></div>
                    <div class="detail-item"><span>Phone</span><strong>${customer.phone}</strong></div>
                </div>
            </article>
        </section>
        <section class="records-section" aria-label="Customer stockout records">
            <%
                java.util.List<com.inventory.sims.stockout.StockOut> stockOutRecords =
                        (java.util.List<com.inventory.sims.stockout.StockOut>) request.getAttribute("stockOutRecords");
                int stockOutCount = stockOutRecords == null ? 0 : stockOutRecords.size();
            %>
            <div class="toolbar">
                <h3>Customer Stockout Records</h3>
                <span class="record-count"><%= stockOutCount %> record<%= stockOutCount == 1 ? "" : "s" %></span>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Stockout ID</th>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Date</th>
                        <th>Reason</th>
                        <th>Note</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (stockOutRecords != null && !stockOutRecords.isEmpty()) {
                            for (com.inventory.sims.stockout.StockOut stockOut : stockOutRecords) {
                    %>
                    <tr>
                        <td><strong><%= stockOut.getId() %></strong></td>
                        <td><%= stockOut.getProductId() %></td>
                        <td><%= stockOut.getProductName() %></td>
                        <td><span class="quantity-badge"><%= stockOut.getQuantity() %> out</span></td>
                        <td><%= stockOut.getStockOutDate() == null ? "-" : stockOut.getStockOutDate() %></td>
                        <td><%= stockOut.getReason() %></td>
                        <td class="muted"><%= stockOut.getNote() == null || stockOut.getNote().isBlank() ? "-" : stockOut.getNote() %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td class="empty" colspan="7">No stockout records found for this customer.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

