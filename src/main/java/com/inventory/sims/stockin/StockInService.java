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
public class StockInService {
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
        StockInInput input = validateInput(productId, supplierName, quantity, unitCost,
                receivedDate, expirationDate, warrantyMonths);

        StockIn stockIn = new StockIn(
                nextStockInId(),
                input.product.getId(),
                input.product.getName(),
                input.supplierName,
                quantity,
                unitCost,
                input.receivedDate,
                input.typeDetails.productType,
                input.typeDetails.expirationDate,
                input.typeDetails.warrantyMonths,
                safeTrim(note));

        input.product.setQuantity(input.product.getQuantity() + quantity);
        applyTypeDetails(input.product, input.typeDetails);
        productService.saveProduct(input.product);
        stockInFileHandler.saveStockIn(stockIn);
        return stockIn;
    }

    // Returns all stock-in records in newest-ID-first order.
    public List<StockIn> getAllStockIns() {
        return sortedNewestFirst(stockInFileHandler.readStockIns());
    }

    // Returns stock-in records that match one supplier name.
    public List<StockIn> getStockInsBySupplierName(String supplierName) {
        validateRequired(supplierName, "Supplier name");
        String normalizedSupplierName = supplierName.trim();
        return stockInFileHandler.readStockIns().stream()
                .filter(stockIn -> stockIn.getSupplierName() != null
                        && stockIn.getSupplierName().trim().equalsIgnoreCase(normalizedSupplierName))
                .sorted(newestFirstComparator())
                .toList();
    }

    // Returns stock-in records for one product ID.
    public List<StockIn> getStockInsByProductId(String productId) {
        if (productId == null || productId.isBlank()) {
            return List.of();
        }
        return stockInFileHandler.readStockIns().stream()
                .filter(stockIn -> productId.equals(stockIn.getProductId()))
                .sorted(newestFirstComparator())
                .toList();
    }

    // Finds one stock-in record by ID.
    public StockIn getStockInById(String id) {
        validateRequired(id, "Stock-in ID");
        for (StockIn stockIn : stockInFileHandler.readStockIns()) {
            if (id.trim().equals(stockIn.getId())) {
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
        StockInInput input = validateInput(productId, supplierName, quantity, unitCost,
                receivedDate, expirationDate, warrantyMonths);

        adjustProductQuantity(existing, input.product, quantity);
        if (applyTypeDetails(input.product, input.typeDetails)) {
            productService.saveProduct(input.product);
        }

        StockIn updated = new StockIn(
                existing.getId(),
                input.product.getId(),
                input.product.getName(),
                input.supplierName,
                quantity,
                unitCost,
                input.receivedDate,
                input.typeDetails.productType,
                input.typeDetails.expirationDate,
                input.typeDetails.warrantyMonths,
                safeTrim(note));

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

    // Validates common form fields, loads the product, and validates type-specific fields.
    private StockInInput validateInput(String productId, String supplierName, int quantity,
                                       double unitCost, String receivedDate, String expirationDate,
                                       String warrantyMonths) {
        validateRequired(productId, "Product");
        validateRequired(supplierName, "Supplier name");
        validateRequired(receivedDate, "Received date");
        validateQuantityAndCost(quantity, unitCost);

        LocalDate parsedReceivedDate = validateDate(receivedDate);
        Product product = getRequiredProduct(productId);
        StockInTypeDetails typeDetails = validateTypeDetails(product, expirationDate, warrantyMonths, parsedReceivedDate);

        return new StockInInput(product, supplierName.trim(), receivedDate.trim(), typeDetails);
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
        Product product = productService.getProductById(productId);
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

    // Shared sort helper used by list and filter methods.
    private List<StockIn> sortedNewestFirst(List<StockIn> stockIns) {
        return stockIns.stream()
                .sorted(newestFirstComparator())
                .toList();
    }

    // Larger SI numbers are newer, so reverse ID order is used.
    private Comparator<StockIn> newestFirstComparator() {
        return Comparator.comparing(
                StockIn::getId,
                Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed()));
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

    // Small holder for already-validated form values.
    private static class StockInInput {
        private final Product product;
        private final String supplierName;
        private final String receivedDate;
        private final StockInTypeDetails typeDetails;

        private StockInInput(Product product, String supplierName, String receivedDate,
                             StockInTypeDetails typeDetails) {
            this.product = product;
            this.supplierName = supplierName;
            this.receivedDate = receivedDate;
            this.typeDetails = typeDetails;
        }
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
