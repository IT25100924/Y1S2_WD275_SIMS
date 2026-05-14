package com.inventory.sims.stockout;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class StockOutService {
    private final StockOutFileHandler stockOutFileHandler;

    public StockOutService(StockOutFileHandler stockOutFileHandler) {
        this.stockOutFileHandler = stockOutFileHandler;
    }

    public StockOut createStockOut(String productId, String productName, int quantity, LocalDate stockOutDate,
                                   String issuedTo, String reason, String note) {
        validateRequired(productId, "Product ID");
        validateRequired(productName, "Product name");
        validateRequired(issuedTo, "Issued to");
        validateRequired(reason, "Reason");

        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }

        LocalDate savedDate = stockOutDate == null ? LocalDate.now() : stockOutDate;
        StockOut stockOut = new StockOut(
                nextStockOutId(),
                productId.trim(),
                productName.trim(),
                quantity,
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

    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
