package com.inventory.sims.stockout;

import com.inventory.sims.customer.Customer;
import com.inventory.sims.product.Product;
import com.inventory.sims.product.ProductService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;

@Service
// Contains all business rules for the Stock-out module.
// Controllers call this class; this class calls the file handler and product service.
public class StockOutService {
    // Newest IDs appear first in lists, matching the previous UI behavior.
    private static final Comparator<StockOut> NEWEST_FIRST = Comparator.comparing(
            StockOut::getId,
            Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed()));

    // Dependencies for stock-out storage and product validation.
    private final StockOutFileHandler stockOutFileHandler;
    private final ProductService productService;

    // Constructor injection keeps the service easy to test and understand.
    public StockOutService(StockOutFileHandler stockOutFileHandler, ProductService productService) {
        this.stockOutFileHandler = stockOutFileHandler;
        this.productService = productService;
    }

    // Creates a new stock-out record after checking product, quantity, price, date, and customer name.
    public StockOut createStockOut(String productId, int quantity, double unitPrice, LocalDate stockOutDate,
                                   String issuedTo, String reason, String note) {
        Product product = validateAndGetProduct(productId, quantity, unitPrice, issuedTo, reason, true);
        StockOut stockOut = buildStockOut(
                nextStockOutId(),
                product,
                quantity,
                unitPrice,
                resolveStockOutDate(stockOutDate),
                issuedTo,
                reason,
                note);

        product.setQuantity(product.getQuantity() - quantity);
        productService.saveProduct(product);
        stockOutFileHandler.saveStockOut(stockOut);
        return stockOut;
    }

    // Returns all records sorted newest first for the list page.
    public List<StockOut> getAllStockOuts() {
        return sortedNewestFirst(stockOutFileHandler.readStockOuts());
    }

    // Returns records issued to one customer name.
    public List<StockOut> getStockOutsByCustomer(Customer customer) {
        if (customer == null || customer.getName() == null || customer.getName().isBlank()) {
            return List.of();
        }

        String customerName = customer.getName().trim();
        return stockOutFileHandler.readStockOuts().stream()
                .filter(stockOut -> stockOut.getIssuedTo() != null
                        && stockOut.getIssuedTo().trim().equalsIgnoreCase(customerName))
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Returns records for one product ID.
    public List<StockOut> getStockOutsByProductId(String productId) {
        if (productId == null || productId.isBlank()) {
            return List.of();
        }
        return stockOutFileHandler.readStockOuts().stream()
                .filter(stockOut -> productId.equals(stockOut.getProductId()))
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Finds one stock-out record by ID.
    public StockOut getStockOutById(String id) {
        validateRequired(id, "Stockout ID");

        String stockOutId = id.trim();
        for (StockOut stockOut : stockOutFileHandler.readStockOuts()) {
            if (stockOutId.equals(stockOut.getId())) {
                return stockOut;
            }
        }
        return null;
    }

    // Updates an existing stock-out record while keeping the same record ID.
    public StockOut updateStockOut(String id, String productId, int quantity, double unitPrice,
                                   LocalDate stockOutDate, String issuedTo, String reason, String note) {
        validateRequired(id, "Stockout ID");
        String stockOutId = id.trim();
        Product product = validateAndGetProduct(productId, quantity, unitPrice, issuedTo, reason, false);
        List<StockOut> stockOuts = stockOutFileHandler.readStockOuts();
        int recordIndex = findIndexById(stockOuts, stockOutId);

        if (recordIndex == -1) {
            throw new IllegalArgumentException("Stockout record not found.");
        }

        StockOut existingStockOut = stockOuts.get(recordIndex);
        adjustProductQuantity(existingStockOut, product, quantity);

        StockOut updatedStockOut = buildStockOut(
                stockOutId,
                product,
                quantity,
                unitPrice,
                resolveStockOutDate(stockOutDate),
                issuedTo,
                reason,
                note);

        stockOuts.set(recordIndex, updatedStockOut);
        stockOutFileHandler.saveAllStockOuts(stockOuts);
        return updatedStockOut;
    }

    // Deletes a stock-out record and rewrites the remaining records.
    public void deleteStockOut(String id) {
        validateRequired(id, "Stockout ID");

        String stockOutId = id.trim();
        List<StockOut> stockOuts = stockOutFileHandler.readStockOuts();
        int deletedIndex = findIndexById(stockOuts, stockOutId);

        if (deletedIndex == -1) {
            throw new IllegalArgumentException("Stockout record not found.");
        }

        StockOut deletedStockOut = stockOuts.remove(deletedIndex);
        Product product = productService.getProductById(deletedStockOut.getProductId());
        if (product == null) {
            throw new IllegalArgumentException("Product was not found, so quantity cannot be adjusted.");
        }

        product.setQuantity(product.getQuantity() + deletedStockOut.getQuantity());
        productService.saveProduct(product);
        stockOutFileHandler.saveAllStockOuts(stockOuts);
    }

    // Generates the next ID, such as SO001, SO002, and so on.
    private String nextStockOutId() {
        int max = 0;
        for (StockOut stockOut : stockOutFileHandler.readStockOuts()) {
            String id = stockOut.getId();
            if (id != null && id.startsWith("SO")) {
                try {
                    max = Math.max(max, Integer.parseInt(id.substring(2)));
                } catch (NumberFormatException ignored) {
                    // Ignore malformed old records and keep generating from valid IDs.
                }
            }
        }
        return String.format("SO%03d", max + 1);
    }

    // Shared validation used by both create and update.
    private Product validateAndGetProduct(String productId, int quantity, double unitPrice, String issuedTo,
                                          String reason, boolean enforceAvailableQuantity) {
        validateRequired(productId, "Product ID");
        validateRequired(issuedTo, "Issued to");
        validateRequired(reason, "Reason");
        validateQuantityAndPrice(quantity, unitPrice);

        Product product = getExistingProduct(productId);
        if (enforceAvailableQuantity) {
            validateAvailableQuantity(quantity, product);
        }
        return product;
    }

    // Builds the StockOut object after all inputs have already been validated.
    private StockOut buildStockOut(String id, Product product, int quantity, double unitPrice,
                                   LocalDate stockOutDate, String issuedTo, String reason, String note) {
        return new StockOut(
                id,
                product.getId(),
                product.getName(),
                quantity,
                unitPrice,
                stockOutDate,
                issuedTo.trim(),
                reason.trim(),
                safeTrim(note));
    }

    // Finds the position of a record in the current file list.
    private int findIndexById(List<StockOut> stockOuts, String id) {
        for (int i = 0; i < stockOuts.size(); i++) {
            if (id.equals(stockOuts.get(i).getId())) {
                return i;
            }
        }
        return -1;
    }

    // Converts a blank date selection into today's date and rejects past dates.
    private LocalDate resolveStockOutDate(LocalDate stockOutDate) {
        LocalDate savedDate = stockOutDate == null ? LocalDate.now() : stockOutDate;
        validateStockOutDate(savedDate);
        return savedDate;
    }

    // Keeps quantity and price rules in one place.
    private void validateQuantityAndPrice(int quantity, double unitPrice) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        if (unitPrice < 0) {
            throw new IllegalArgumentException("Unit price cannot be negative.");
        }
    }

    // Sorts any record list newest first.
    private List<StockOut> sortedNewestFirst(List<StockOut> stockOuts) {
        return stockOuts.stream()
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Loads the product or reports a form-friendly error.
    private Product getExistingProduct(String productId) {
        Product product = productService.getProductById(productId.trim());
        if (product == null) {
            throw new IllegalArgumentException("Selected product was not found.");
        }
        return product;
    }

    // Stock-out records cannot be created for dates before today.
    private void validateStockOutDate(LocalDate stockOutDate) {
        if (stockOutDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Stockout date cannot be in the past.");
        }
    }

    // Prevents issuing more items than the selected product currently has.
    private void validateAvailableQuantity(int quantity, Product product) {
        if (quantity > product.getQuantity()) {
            throw new IllegalArgumentException("Stockout quantity cannot be greater than available product quantity.");
        }
    }

    // Reverses the old stock-out quantity and applies the updated stock-out quantity.
    private void adjustProductQuantity(StockOut existingStockOut, Product selectedProduct, int updatedQuantity) {
        if (existingStockOut.getProductId().equals(selectedProduct.getId())) {
            int adjustedQuantity = selectedProduct.getQuantity() + existingStockOut.getQuantity() - updatedQuantity;
            if (adjustedQuantity < 0) {
                throw new IllegalArgumentException("Stockout quantity cannot be greater than available product quantity.");
            }
            selectedProduct.setQuantity(adjustedQuantity);
            productService.saveProduct(selectedProduct);
            return;
        }

        Product originalProduct = productService.getProductById(existingStockOut.getProductId());
        if (originalProduct == null) {
            throw new IllegalArgumentException("Original product was not found, so quantity cannot be adjusted.");
        }

        if (updatedQuantity > selectedProduct.getQuantity()) {
            throw new IllegalArgumentException("Stockout quantity cannot be greater than available product quantity.");
        }

        originalProduct.setQuantity(originalProduct.getQuantity() + existingStockOut.getQuantity());
        selectedProduct.setQuantity(selectedProduct.getQuantity() - updatedQuantity);
        productService.saveProduct(originalProduct);
        productService.saveProduct(selectedProduct);
    }

    // Common required-field check for text inputs.
    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    // Optional note field is stored as an empty string when not supplied.
    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
