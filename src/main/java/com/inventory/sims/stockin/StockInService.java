package com.inventory.sims.stockin;

import com.inventory.sims.product.ElectronicsProduct;
import com.inventory.sims.product.FoodProduct;
import com.inventory.sims.product.Product;
import com.inventory.sims.product.ProductService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.List;

@Service
// Business logic for the Stock In module.
// Controllers call this class; this class updates stockin.txt and product quantities.
public class StockInService {
    // Newest Stock In IDs appear first in list pages, matching the existing UI.
    private static final Comparator<StockIn> NEWEST_FIRST = Comparator.comparing(
            StockIn::getId,
            Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed()));

    // File handler stores stock-in records; product service keeps quantities synchronized.
    private final StockInFileHandler stockInFileHandler;
    private final ProductService productService;

    // Constructor injection keeps dependencies clear.
    public StockInService(StockInFileHandler stockInFileHandler, ProductService productService) {
        this.stockInFileHandler = stockInFileHandler;
        this.productService = productService;
    }

    // Creates a stock-in record and increases the selected product quantity.
    public StockIn addStockIn(String productId, String supplierName, int quantity,
                              double unitCost, String receivedDate, String expirationDate,
                              String warrantyMonths, String note) {
        validateBasicInput(productId, supplierName, quantity, unitCost, receivedDate);
        LocalDate parsedReceivedDate = validateDate(receivedDate);
        Product product = getRequiredProduct(productId);
        StockInTypeDetails typeDetails = validateTypeDetails(product, expirationDate, warrantyMonths, parsedReceivedDate);

        StockIn stockIn = buildStockIn(nextStockInId(), product, supplierName, quantity, unitCost,
                receivedDate, typeDetails, note);

        product.setQuantity(product.getQuantity() + quantity);
        applyTypeDetails(product, typeDetails);
        productService.saveProduct(product);
        stockInFileHandler.saveStockIn(stockIn);
        return stockIn;
    }

    // Returns all stock-in records in newest-ID-first order.
    public List<StockIn> getAllStockIns() {
        return stockInFileHandler.readStockIns().stream()
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Returns stock-in records that match one supplier name.
    public List<StockIn> getStockInsBySupplierName(String supplierName) {
        validateRequired(supplierName, "Supplier name");
        String normalizedSupplierName = supplierName.trim();
        return stockInFileHandler.readStockIns().stream()
                .filter(stockIn -> stockIn.getSupplierName() != null
                        && stockIn.getSupplierName().trim().equalsIgnoreCase(normalizedSupplierName))
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Returns stock-in records for one product ID.
    public List<StockIn> getStockInsByProductId(String productId) {
        if (productId == null || productId.isBlank()) {
            return List.of();
        }
        return stockInFileHandler.readStockIns().stream()
                .filter(stockIn -> productId.equals(stockIn.getProductId()))
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Finds one stock-in record by ID.
    public StockIn getStockInById(String id) {
        validateRequired(id, "Stock-in ID");
        String stockInId = id.trim();

        for (StockIn stockIn : stockInFileHandler.readStockIns()) {
            if (stockInId.equals(stockIn.getId())) {
                return stockIn;
            }
        }
        return null;
    }

    // Updates a stock-in record and adjusts product quantity changes.
    public StockIn updateStockIn(String id, String productId, String supplierName, int quantity,
                                 double unitCost, String receivedDate, String expirationDate,
                                 String warrantyMonths, String note) {
        validateRequired(id, "Stock-in ID");

        List<StockIn> stockIns = stockInFileHandler.readStockIns();
        int existingIndex = findStockInIndex(stockIns, id);
        if (existingIndex == -1) {
            throw new IllegalArgumentException("Stock-in record was not found.");
        }

        StockIn existing = stockIns.get(existingIndex);
        validateBasicInput(productId, supplierName, quantity, unitCost, receivedDate);
        LocalDate parsedReceivedDate = validateDate(receivedDate);
        Product product = getRequiredProduct(productId);
        StockInTypeDetails typeDetails = validateTypeDetails(product, expirationDate, warrantyMonths, parsedReceivedDate);

        adjustProductQuantity(existing, product, quantity);
        if (applyTypeDetails(product, typeDetails)) {
            productService.saveProduct(product);
        }

        StockIn updated = buildStockIn(existing.getId(), product, supplierName, quantity, unitCost,
                receivedDate, typeDetails, note);

        stockIns.set(existingIndex, updated);
        stockInFileHandler.saveAllStockIns(stockIns);
        return updated;
    }

    // Deletes a stock-in record and subtracts its quantity from the product.
    public StockIn deleteStockIn(String id) {
        validateRequired(id, "Stock-in ID");

        List<StockIn> stockIns = stockInFileHandler.readStockIns();
        int deletedIndex = findStockInIndex(stockIns, id);
        if (deletedIndex == -1) {
            throw new IllegalArgumentException("Stock-in record was not found.");
        }

        StockIn deleted = stockIns.remove(deletedIndex);
        Product product = productService.getProductById(deleted.getProductId());
        if (product == null) {
            throw new IllegalArgumentException("Product was not found, so quantity cannot be adjusted.");
        }

        int adjustedQuantity = product.getQuantity() - deleted.getQuantity();
        if (adjustedQuantity < 0) {
            throw new IllegalArgumentException("Cannot reduce product quantity below zero.");
        }

        product.setQuantity(adjustedQuantity);
        productService.saveProduct(product);
        stockInFileHandler.saveAllStockIns(stockIns);
        return deleted;
    }

    // Validates fields that are common to every product type.
    private void validateBasicInput(String productId, String supplierName, int quantity,
                                    double unitCost, String receivedDate) {
        validateRequired(productId, "Product");
        validateRequired(supplierName, "Supplier name");
        validateRequired(receivedDate, "Received date");
        validateQuantityAndCost(quantity, unitCost);
    }

    // Keeps quantity and cost rules in one place.
    private void validateQuantityAndCost(int quantity, double unitCost) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        if (unitCost < 0) {
            throw new IllegalArgumentException("Unit cost cannot be negative.");
        }
    }

    // Loads the selected product or returns the same user-facing error as before.
    private Product getRequiredProduct(String productId) {
        Product product = productService.getProductById(productId.trim());
        if (product == null) {
            throw new IllegalArgumentException("Selected product was not found.");
        }
        return product;
    }

    // Finds the position of a stock-in record in a list.
    private int findStockInIndex(List<StockIn> stockIns, String id) {
        String trimmedId = id.trim();
        for (int i = 0; i < stockIns.size(); i++) {
            if (trimmedId.equals(stockIns.get(i).getId())) {
                return i;
            }
        }
        return -1;
    }

    // Builds the final StockIn object after validation has passed.
    private StockIn buildStockIn(String id, Product product, String supplierName, int quantity,
                                 double unitCost, String receivedDate, StockInTypeDetails typeDetails,
                                 String note) {
        return new StockIn(
                id,
                product.getId(),
                product.getName(),
                supplierName.trim(),
                quantity,
                unitCost,
                receivedDate.trim(),
                typeDetails.productType,
                typeDetails.expirationDate,
                typeDetails.warrantyMonths,
                safeTrim(note));
    }

    // Copies food/electronics details onto the product record.
    private boolean applyTypeDetails(Product product, StockInTypeDetails typeDetails) {
        if (product instanceof FoodProduct && typeDetails.expirationDate != null && !typeDetails.expirationDate.isBlank()) {
            ((FoodProduct) product).setExpirationDate(typeDetails.expirationDate);
            return true;
        }
        if (product instanceof ElectronicsProduct && typeDetails.warrantyMonths > 0) {
            ((ElectronicsProduct) product).setWarrantyMonths(typeDetails.warrantyMonths);
            return true;
        }
        return false;
    }

    // Reverses the old stock-in quantity and applies the updated quantity.
    private void adjustProductQuantity(StockIn existing, Product selectedProduct, int updatedQuantity) {
        if (existing.getProductId().equals(selectedProduct.getId())) {
            int adjustedQuantity = selectedProduct.getQuantity() - existing.getQuantity() + updatedQuantity;
            if (adjustedQuantity < 0) {
                throw new IllegalArgumentException("Cannot reduce product quantity below zero.");
            }
            selectedProduct.setQuantity(adjustedQuantity);
            productService.saveProduct(selectedProduct);
            return;
        }

        Product originalProduct = productService.getProductById(existing.getProductId());
        if (originalProduct == null) {
            throw new IllegalArgumentException("Original product was not found, so quantity cannot be adjusted.");
        }

        int originalAdjustedQuantity = originalProduct.getQuantity() - existing.getQuantity();
        if (originalAdjustedQuantity < 0) {
            throw new IllegalArgumentException("Cannot reduce original product quantity below zero.");
        }

        originalProduct.setQuantity(originalAdjustedQuantity);
        selectedProduct.setQuantity(selectedProduct.getQuantity() + updatedQuantity);
        productService.saveProduct(originalProduct);
        productService.saveProduct(selectedProduct);
    }

    // Generates the next ID, such as SI001 then SI002.
    private String nextStockInId() {
        int max = 0;
        for (StockIn stockIn : stockInFileHandler.readStockIns()) {
            String id = stockIn.getId();
            if (id != null && id.startsWith("SI")) {
                try {
                    max = Math.max(max, Integer.parseInt(id.substring(2)));
                } catch (NumberFormatException ignored) {
                    // Ignore malformed old records and keep generating from valid IDs.
                }
            }
        }
        return String.format("SI%03d", max + 1);
    }

    // Validates received date format and blocks dates before today.
    private LocalDate validateDate(String receivedDate) {
        try {
            LocalDate selectedDate = LocalDate.parse(receivedDate.trim());
            if (selectedDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Received date cannot be before today.");
            }
            return selectedDate;
        } catch (DateTimeParseException ex) {
            throw new IllegalArgumentException("Received date must be a valid date.");
        }
    }

    // Validates Food expiry dates and Electronics warranty months.
    private StockInTypeDetails validateTypeDetails(Product product, String expirationDate,
                                                   String warrantyMonths, LocalDate receivedDate) {
        if (product instanceof FoodProduct) {
            validateRequired(expirationDate, "Expiration date");
            LocalDate parsedExpirationDate = parseDate(expirationDate, "Expiration date");
            if (parsedExpirationDate.isBefore(receivedDate)) {
                throw new IllegalArgumentException("Expiration date cannot be before received date.");
            }
            return new StockInTypeDetails("Food", expirationDate.trim(), 0);
        }

        if (product instanceof ElectronicsProduct) {
            validateRequired(warrantyMonths, "Warranty months");
            int parsedWarrantyMonths;
            try {
                parsedWarrantyMonths = Integer.parseInt(warrantyMonths.trim());
            } catch (NumberFormatException ex) {
                throw new IllegalArgumentException("Warranty months must be a valid number.");
            }
            if (parsedWarrantyMonths < 0) {
                throw new IllegalArgumentException("Warranty months cannot be negative.");
            }
            return new StockInTypeDetails("Electronics", "", parsedWarrantyMonths);
        }

        return new StockInTypeDetails("General", "", 0);
    }

    // Parses a date field and reports the field name in the error.
    private LocalDate parseDate(String value, String fieldName) {
        try {
            return LocalDate.parse(value.trim());
        } catch (DateTimeParseException ex) {
            throw new IllegalArgumentException(fieldName + " must be a valid date.");
        }
    }

    // Shared required-text validation.
    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    // Trims optional text and stores null as an empty string.
    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    // Small holder for product-type-specific values.
    private static class StockInTypeDetails {
        private final String productType;
        private final String expirationDate;
        private final int warrantyMonths;

        private StockInTypeDetails(String productType, String expirationDate, int warrantyMonths) {
            this.productType = productType;
            this.expirationDate = expirationDate;
            this.warrantyMonths = warrantyMonths;
        }
    }
}
