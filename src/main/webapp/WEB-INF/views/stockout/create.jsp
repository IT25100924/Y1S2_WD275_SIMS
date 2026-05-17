<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    java.util.List<com.inventory.sims.product.Product> products =
            (java.util.List<com.inventory.sims.product.Product>) request.getAttribute("products");
    java.util.List<com.inventory.sims.customer.Customer> customers =
            (java.util.List<com.inventory.sims.customer.Customer>) request.getAttribute("customers");
    String today = (String) request.getAttribute("today");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Create Stockout | Stockout" />
    <jsp:param name="activeMenu" value="stockout" />
</jsp:include>
    <main class="stockout-shell">
        <section class="info-panel" aria-label="Stockout information">
            <div>
                <div class="brand">SIMS</div>
                <h1>Create a stockout record</h1>
                <p>Record inventory items issued from stock for sales, internal use, returns, or damage adjustments.</p>
                <div class="stock-note">Use accurate product and quantity details so stock movement history stays clear.</div>
            </div>
        </section>

        <section class="form-panel">
            <h2>New stockout</h2>
            <p class="subtitle">Enter the stock issue details and submit the record.</p>

            <div class="alert">${message}</div>

            <form action="/stockout/create" method="post">
                <div class="form-grid">
                    <label class="full-width">
                        Product
                        <select id="productId" name="productId" required>
                            <option value="">Select product</option>
                            <%
                                if (products != null) {
                                    for (com.inventory.sims.product.Product product : products) {
                                        String productType = "General";
                                        String expirationDate = "";
                                        int warrantyMonths = 0;
                                        if (product instanceof com.inventory.sims.product.FoodProduct) {
                                            productType = "Food";
                                            expirationDate = ((com.inventory.sims.product.FoodProduct) product).getExpirationDate();
                                            if (expirationDate == null) {
                                                expirationDate = "";
                                            }
                                        } else if (product instanceof com.inventory.sims.product.ElectronicsProduct) {
                                            productType = "Electronics";
                                            warrantyMonths = ((com.inventory.sims.product.ElectronicsProduct) product).getWarrantyMonths();
                                        }
                            %>
                            <option value="<%= product.getId() %>"
                                    data-product-type="<%= productType %>"
                                    data-expiration-date="<%= expirationDate %>"
                                    data-warranty-months="<%= warrantyMonths %>"
                                    data-available-quantity="<%= product.getQuantity() %>">
                                <%= product.getName() %> (Available: <%= product.getQuantity() %>)
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </label>

                    <label id="expirationDateGroup" class="hidden">
                        Expiration date
                        <input type="text" id="expirationDateDisplay" readonly>
                    </label>

                    <label id="warrantyMonthsGroup" class="hidden">
                        Warranty
                        <input type="text" id="warrantyMonthsDisplay" readonly>
                    </label>

                    <label>
                        Quantity
                        <input type="number" id="quantity" name="quantity" min="1" step="1" placeholder="1" required>
                    </label>

                    <label>
                        Unit price (LKR)
                        <input type="number" name="unitPrice" min="0" step="0.01" placeholder="0.00" required>
                    </label>

                    <label>
                        Stockout date
                        <input type="date" name="stockOutDate" min="<%= today == null ? "" : today %>">
                    </label>

                    <label>
                        Issued to
                        <select name="issuedTo" required>
                            <option value="">Select customer</option>
                            <%
                                if (customers != null) {
                                    for (com.inventory.sims.customer.Customer customer : customers) {
                            %>
                            <option value="<%= customer.getId() %>">
                                <%= customer.getName() %> (<%= customer.getId() %>)
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </label>

                    <label>
                        Reason
                        <select name="reason" required>
                            <option value="">Select reason</option>
                            <option value="Sale">Sale</option>
                            <option value="Internal use">Internal use</option>
                            <option value="Damaged item">Damaged item</option>
                            <option value="Returned to supplier">Returned to supplier</option>
                            <option value="Other">Other</option>
                        </select>
                    </label>

                    <label class="full-width">
                        Note
                        <textarea name="note" placeholder="Optional stockout note"></textarea>
                    </label>
                </div>

                <div class="actions">
                    <button type="submit">Create stockout</button>
                    <a class="button button-secondary" href="/stockout">View records</a>
                    <a class="button button-secondary" href="/dashboard">Back to dashboard</a>
                </div>
            </form>
        </section>
    </main>
<script>
    const productSelect = document.getElementById("productId");
    const quantityInput = document.getElementById("quantity");
    const expirationGroup = document.getElementById("expirationDateGroup");
    const expirationDisplay = document.getElementById("expirationDateDisplay");
    const warrantyGroup = document.getElementById("warrantyMonthsGroup");
    const warrantyDisplay = document.getElementById("warrantyMonthsDisplay");

    function showSelectedProductDetails() {
        const selectedOption = productSelect.options[productSelect.selectedIndex];
        const productType = selectedOption ? selectedOption.dataset.productType : "";

        expirationGroup.classList.add("hidden");
        warrantyGroup.classList.add("hidden");
        expirationDisplay.value = "";
        warrantyDisplay.value = "";
        quantityInput.removeAttribute("max");
        quantityInput.placeholder = "1";

        if (productType === "Food") {
            expirationDisplay.value = selectedOption.dataset.expirationDate || "Not set";
            expirationGroup.classList.remove("hidden");
        } else if (productType === "Electronics") {
            warrantyDisplay.value = (selectedOption.dataset.warrantyMonths || "0") + " months";
            warrantyGroup.classList.remove("hidden");
        }

        if (selectedOption && selectedOption.dataset.availableQuantity) {
            quantityInput.max = selectedOption.dataset.availableQuantity;
            quantityInput.placeholder = "Max " + selectedOption.dataset.availableQuantity;
            if (Number(quantityInput.value) > Number(selectedOption.dataset.availableQuantity)) {
                quantityInput.value = selectedOption.dataset.availableQuantity;
            }
        }
    }

    productSelect.addEventListener("change", showSelectedProductDetails);
    showSelectedProductDetails();
</script>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
