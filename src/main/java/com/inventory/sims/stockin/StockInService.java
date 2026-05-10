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
            LocalDate.parse(receivedDate.trim());
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
