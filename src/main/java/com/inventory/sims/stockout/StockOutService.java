package com.inventory.sims.stockout;

import com.inventory.sims.customer.Customer;
import com.inventory.sims.product.Product;
import com.inventory.sims.product.ProductService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class StockOutService {
    private final StockOutFileHandler stockOutFileHandler;
    private final ProductService productService;

    public StockOutService(StockOutFileHandler stockOutFileHandler, ProductService productService) {
        this.stockOutFileHandler = stockOutFileHandler;
        this.productService = productService;
    }

    public StockOut createStockOut(String productId, int quantity, double unitPrice, LocalDate stockOutDate,
                                   String issuedTo, String reason, String note) {
        validateRequired(productId, "Product ID");
        validateRequired(issuedTo, "Issued to");
        validateRequired(reason, "Reason");

        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        if (unitPrice < 0) {
            throw new IllegalArgumentException("Unit price cannot be negative.");
        }

        LocalDate savedDate = stockOutDate == null ? LocalDate.now() : stockOutDate;
        validateStockOutDate(savedDate);

        Product product = getExistingProduct(productId);
        validateAvailableQuantity(quantity, product);
        StockOut stockOut = new StockOut(
                nextStockOutId(),
                product.getId(),
                product.getName(),
                quantity,
                unitPrice,
                savedDate,
                issuedTo.trim(),
                reason.trim(),
                safeTrim(note));

        stockOutFileHandler.saveStockOut(stockOut);
        return stockOut;
    }

    public List<StockOut> getAllStockOuts() {
        return stockOutFileHandler.readStockOuts();
    }

    public List<StockOut> getStockOutsByCustomer(Customer customer) {
        if (customer == null || customer.getName() == null) {
            return List.of();
        }

        String customerName = customer.getName().trim();
        return stockOutFileHandler.readStockOuts().stream()
                .filter(stockOut -> stockOut.getIssuedTo() != null
                        && stockOut.getIssuedTo().trim().equalsIgnoreCase(customerName))
                .toList();
    }

    public StockOut getStockOutById(String id) {
        validateRequired(id, "Stockout ID");

        for (StockOut stockOut : stockOutFileHandler.readStockOuts()) {
            if (stockOut.getId().equals(id.trim())) {
                return stockOut;
            }
        }
        return null;
    }

    public StockOut updateStockOut(String id, String productId, int quantity, double unitPrice,
                                   LocalDate stockOutDate, String issuedTo, String reason, String note) {
        validateRequired(id, "Stockout ID");
        validateRequired(productId, "Product ID");
        validateRequired(issuedTo, "Issued to");
        validateRequired(reason, "Reason");

        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        if (unitPrice < 0) {
            throw new IllegalArgumentException("Unit price cannot be negative.");
        }

        List<StockOut> stockOuts = stockOutFileHandler.readStockOuts();
        String stockOutId = id.trim();
        LocalDate savedDate = stockOutDate == null ? LocalDate.now() : stockOutDate;
        validateStockOutDate(savedDate);
        Product product = getExistingProduct(productId);
        validateAvailableQuantity(quantity, product);

        for (int i = 0; i < stockOuts.size(); i++) {
            StockOut currentStockOut = stockOuts.get(i);
            if (currentStockOut.getId().equals(stockOutId)) {
                StockOut updatedStockOut = new StockOut(
                        stockOutId,
                        product.getId(),
                        product.getName(),
                        quantity,
                        unitPrice,
                        savedDate,
                        issuedTo.trim(),
                        reason.trim(),
                        safeTrim(note));

                stockOuts.set(i, updatedStockOut);
                stockOutFileHandler.saveAllStockOuts(stockOuts);
                return updatedStockOut;
            }
        }

        throw new IllegalArgumentException("Stockout record not found.");
    }

    public void deleteStockOut(String id) {
        validateRequired(id, "Stockout ID");

        List<StockOut> stockOuts = stockOutFileHandler.readStockOuts();
        boolean removed = stockOuts.removeIf(stockOut -> stockOut.getId().equals(id.trim()));

        if (!removed) {
            throw new IllegalArgumentException("Stockout record not found.");
        }

        stockOutFileHandler.saveAllStockOuts(stockOuts);
    }

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

    private Product getExistingProduct(String productId) {
        Product product = productService.getProductById(productId.trim());
        if (product == null) {
            throw new IllegalArgumentException("Selected product was not found.");
        }
        return product;
    }

    private void validateStockOutDate(LocalDate stockOutDate) {
        if (stockOutDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Stockout date cannot be in the past.");
        }
    }

    private void validateAvailableQuantity(int quantity, Product product) {
        if (quantity > product.getQuantity()) {
            throw new IllegalArgumentException("Stockout quantity cannot be greater than available product quantity.");
        }
    }

    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
