package com.inventory.sims.stockin;

import com.inventory.sims.product.Product;
import com.inventory.sims.product.ProductService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@Service
public class StockInService {
    private final StockInFileHandler stockInFileHandler;
    private final ProductService productService;

    public StockInService(StockInFileHandler stockInFileHandler, ProductService productService) {
        this.stockInFileHandler = stockInFileHandler;
        this.productService = productService;
    }

    public StockIn addStockIn(String productId, String supplierName, int quantity,
                              double unitCost, String receivedDate, String note) {
        validateRequired(productId, "Product");
        validateRequired(supplierName, "Supplier name");
        validateRequired(receivedDate, "Received date");

        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        if (unitCost < 0) {
            throw new IllegalArgumentException("Unit cost cannot be negative.");
        }
        validateDate(receivedDate);

        Product product = productService.getProductById(productId);
        if (product == null) {
            throw new IllegalArgumentException("Selected product was not found.");
        }

        StockIn stockIn = new StockIn(
                nextStockInId(),
                product.getId(),
                product.getName(),
                supplierName.trim(),
                quantity,
                unitCost,
                receivedDate.trim(),
                safeTrim(note));

        product.setQuantity(product.getQuantity() + quantity);
        productService.saveProduct(product);
        stockInFileHandler.saveStockIn(stockIn);
        return stockIn;
    }

    public List<StockIn> getAllStockIns() {
        return stockInFileHandler.readStockIns();
    }

    public StockIn getStockInById(String id) {
        validateRequired(id, "Stock-in ID");
        for (StockIn stockIn : stockInFileHandler.readStockIns()) {
            if (id.trim().equals(stockIn.getId())) {
                return stockIn;
            }
        }
        return null;
    }

    public StockIn updateStockIn(String id, String productId, String supplierName, int quantity,
                                 double unitCost, String receivedDate, String note) {
        validateRequired(id, "Stock-in ID");
        validateRequired(productId, "Product");
        validateRequired(supplierName, "Supplier name");
        validateRequired(receivedDate, "Received date");

        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        if (unitCost < 0) {
            throw new IllegalArgumentException("Unit cost cannot be negative.");
        }
        validateDate(receivedDate);

        List<StockIn> stockIns = stockInFileHandler.readStockIns();
        StockIn existing = null;
        int existingIndex = -1;
        for (int i = 0; i < stockIns.size(); i++) {
            StockIn stockIn = stockIns.get(i);
            if (id.trim().equals(stockIn.getId())) {
                existing = stockIn;
                existingIndex = i;
                break;
            }
        }

        if (existing == null) {
            throw new IllegalArgumentException("Stock-in record was not found.");
        }

        Product selectedProduct = productService.getProductById(productId);
        if (selectedProduct == null) {
            throw new IllegalArgumentException("Selected product was not found.");
        }

        adjustProductQuantity(existing, selectedProduct, quantity);

        StockIn updated = new StockIn(
                existing.getId(),
                selectedProduct.getId(),
                selectedProduct.getName(),
                supplierName.trim(),
                quantity,
                unitCost,
                receivedDate.trim(),
                safeTrim(note));

        stockIns.set(existingIndex, updated);
        stockInFileHandler.saveAllStockIns(stockIns);
        return updated;
    }

    public StockIn deleteStockIn(String id) {
        validateRequired(id, "Stock-in ID");

        List<StockIn> stockIns = stockInFileHandler.readStockIns();
        StockIn deleted = null;

        for (int i = 0; i < stockIns.size(); i++) {
            StockIn stockIn = stockIns.get(i);
            if (id.trim().equals(stockIn.getId())) {
                deleted = stockIns.remove(i);
                break;
            }
        }

        if (deleted == null) {
            throw new IllegalArgumentException("Stock-in record was not found.");
        }

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

    private void validateDate(String receivedDate) {
        try {
            LocalDate selectedDate = LocalDate.parse(receivedDate.trim());
            if (selectedDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Received date cannot be before today.");
            }
        } catch (DateTimeParseException ex) {
            throw new IllegalArgumentException("Received date must be a valid date.");
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
