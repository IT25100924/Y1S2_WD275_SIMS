<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Add Supplier | Suppliers" />
    <jsp:param name="activeMenu" value="suppliers" />
</jsp:include>
        <header class="page-header">
            <div class="page-title">
                <h1>Add New Supplier</h1>
                <p>Capture supplier company data, contact details, and sourcing information for inventory operations.</p>
            </div>
            <div class="actions">
                <a class="button button-secondary" href="/suppliers">Cancel</a>
            </div>
        </header>

        <div class="form-card">
            <form action="/suppliers/register" method="post" id="supplierForm">
                <% if (request.getAttribute("message") != null && !request.getAttribute("message").toString().isEmpty()) { %>
                <div style="margin-bottom: 18px; padding: 12px 14px; border-radius: 6px; border: 1px solid #bbf7d0; color: #166534; background: #f0fdf4; font-weight: bold;">
                    <%= request.getAttribute("message") %>
                </div>
                <% } %>
                
                <div class="form-group">
                    <label for="companyName">Company Name</label>
                    <input type="text" id="companyName" name="companyName" class="form-control" placeholder="ABC Distributors" required>
                </div>

                <div class="form-group">
                    <label for="category">Supplier Category</label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="" disabled selected>Select category</option>
                        <option value="LOCAL">Local</option>
                        <option value="IMPORT">Import</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="contactPerson">Contact Person</label>
                    <input type="text" id="contactPerson" name="contactPerson" class="form-control" placeholder="Nimal Perera" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="0771234567" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="supplier@sims.com" required>
                </div>

                <div class="form-group">
                    <label for="city">City</label>
                    <input type="text" id="city" name="city" class="form-control" placeholder="Colombo">
                </div>

                <div class="form-group">
                    <label for="leadTime">Supply Lead Time</label>
                    <input type="text" id="leadTime" name="leadTime" class="form-control" placeholder="3 working days">
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" class="form-control" placeholder="Enter supplier address" style="min-height: 80px;"></textarea>
                </div>

                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea id="notes" name="notes" class="form-control" placeholder="Product range, payment terms, delivery conditions, or approval notes" style="min-height: 120px;"></textarea>
                </div>

                <div class="form-group">
                    <label class="checkbox-label" style="display: flex; align-items: center; gap: 8px;">
                        <input type="checkbox" name="active" checked style="width: auto;">
                        Mark this supplier as active and available for purchasing.
                    </label>
                </div>

                <button type="submit" class="button button-primary">Save Supplier</button>
            </form>
        </div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
