<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Update Supplier | Suppliers" />
    <jsp:param name="activeMenu" value="suppliers" />
</jsp:include>
        <header class="page-header">
            <div class="page-title">
                <h1>Update Supplier</h1>
                <p>Edit supplier company data, contact details, and sourcing information.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/suppliers">Cancel</a>
            </div>
        </header>

        <div class="form-card">
            <form action="/suppliers/edit/${supplier.id}" method="post" id="supplierForm">
                <% if (request.getAttribute("message") != null && !request.getAttribute("message").toString().isEmpty()) { %>
                <div style="margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; border: 1px solid #bbf7d0; color: #166534; background: #f0fdf4; font-weight: bold;">
                    <%= request.getAttribute("message") %>
                </div>
                <% } %>

                <div class="form-group">
                    <label for="companyName">Company Name</label>
                    <input type="text" id="companyName" name="companyName" class="form-control" value="${supplier.companyName}" required>
                </div>

                <div class="form-group">
                    <label for="category">Supplier Category</label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="" disabled>Select category</option>
                        <option value="LOCAL" ${supplier.category eq 'LOCAL' ? 'selected' : ''}>Local</option>
                        <option value="IMPORT" ${supplier.category eq 'IMPORT' ? 'selected' : ''}>Import</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="contactPerson">Contact Person</label>
                    <input type="text" id="contactPerson" name="contactPerson" class="form-control" value="${supplier.contactPerson}" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" value="${supplier.phone}" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" value="${supplier.email}" required>
                </div>

                <div class="form-group">
                    <label for="city">City</label>
                    <input type="text" id="city" name="city" class="form-control" value="${supplier.city}">
                </div>

                <div class="form-group">
                    <label for="leadTime">Supply Lead Time</label>
                    <input type="text" id="leadTime" name="leadTime" class="form-control" value="${supplier.leadTime}">
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-control" style="min-height: 80px;">${supplier.address}</textarea>
                </div>

                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea id="notes" name="notes" class="form-control" style="min-height: 120px;">${supplier.notes}</textarea>
                </div>

                <div class="form-group">
                    <label class="checkbox-label" style="display: flex; align-items: center; gap: 8px;">
                        <input type="checkbox" name="active" ${supplier.status eq 'ACTIVE' ? 'checked' : ''} style="width: auto;">
                        Mark this supplier as active and available for purchasing.
                    </label>
                </div>

                <button type="submit" class="button button-primary">Update Supplier</button>
            </form>
        </div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
