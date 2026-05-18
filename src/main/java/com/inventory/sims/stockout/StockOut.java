package com.inventory.sims.stockout;

import java.time.LocalDate;

// Model class for one stock-out record.
// It is used by controllers, services, JSP pages, and the stockout.txt file handler.
public class StockOut {
    // These fields match the saved file format.
    private String id;
    private String productId;
    private String productName;
    private int quantity;
    private double unitPrice;
    private LocalDate stockOutDate;
    private String issuedTo;
    private String reason;
    private String note;

    // Empty constructor is required by JSP/Spring style object usage.
    public StockOut() {
    }

    // Old constructor kept for compatibility with older code that did not have unit price.
    public StockOut(String id, String productId, String productName, int quantity, LocalDate stockOutDate,
                    String issuedTo, String reason, String note) {
        this(id, productId, productName, quantity, 0, stockOutDate, issuedTo, reason, note);
    }

    // Main constructor used when creating or updating stock-out records.
    public StockOut(String id, String productId, String productName, int quantity, double unitPrice,
                    LocalDate stockOutDate, String issuedTo, String reason, String note) {
        this.id = id;
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.stockOutDate = stockOutDate;
        this.issuedTo = issuedTo;
        this.reason = reason;
        this.note = note;
    }

    // Getters and setters expose the record values to services and JSP pages.
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public LocalDate getStockOutDate() {
        return stockOutDate;
    }

    public void setStockOutDate(LocalDate stockOutDate) {
        this.stockOutDate = stockOutDate;
    }

    public String getIssuedTo() {
        return issuedTo;
    }

    public void setIssuedTo(String issuedTo) {
        this.issuedTo = issuedTo;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    // Calculated value used by views when showing the total sale/issue value.
    public double getTotalPrice() {
        return quantity * unitPrice;
    }

    // Converts this object into one pipe-separated line for stockout.txt.
    public String toFileLine() {
        return String.join("|",
                clean(id),
                clean(productId),
                clean(productName),
                Integer.toString(quantity),
                Double.toString(unitPrice),
                stockOutDate == null ? "" : stockOutDate.toString(),
                clean(issuedTo),
                clean(reason),
                clean(note));
    }

    // Builds a StockOut object from one saved file line.
    // It supports both the current format with unitPrice and the older format without it.
    public static StockOut fromFileLine(String line) {
        try {
            String[] parts = line.split("\\|", -1);
            if (parts.length < 8) {
                return null;
            }

            boolean hasUnitPrice = parts.length >= 9;
            int dateIndex = hasUnitPrice ? 5 : 4;
            int issuedToIndex = hasUnitPrice ? 6 : 5;
            int reasonIndex = hasUnitPrice ? 7 : 6;
            int noteIndex = hasUnitPrice ? 8 : 7;

            LocalDate parsedDate = null;
            if (!parts[dateIndex].isBlank()) {
                parsedDate = LocalDate.parse(parts[dateIndex]);
            }

            return new StockOut(
                    parts[0],
                    parts[1],
                    parts[2],
                    Integer.parseInt(parts[3]),
                    hasUnitPrice ? Double.parseDouble(parts[4]) : 0,
                    parsedDate,
                    parts[issuedToIndex],
                    parts[reasonIndex],
                    parts[noteIndex]);
        } catch (RuntimeException ex) {
            // A broken old/manual line should not crash dashboard or stock-out pages.
            return null;
        }
<<<<<<< Updated upstream
=======

        try {
            boolean hasUnitPrice = parts.length >= 9;
            int dateIndex = hasUnitPrice ? 5 : 4;
            int issuedToIndex = hasUnitPrice ? 6 : 5;
            int reasonIndex = hasUnitPrice ? 7 : 6;
            int noteIndex = hasUnitPrice ? 8 : 7;

            LocalDate parsedDate = null;
            if (!parts[dateIndex].isBlank()) {
                parsedDate = LocalDate.parse(parts[dateIndex]);
            }

            return new StockOut(
                    parts[0],
                    parts[1],
                    parts[2],
                    Integer.parseInt(parts[3]),
                    hasUnitPrice ? Double.parseDouble(parts[4]) : 0,
                    parsedDate,
                    parts[issuedToIndex],
                    parts[reasonIndex],
                    parts[noteIndex]);
        } catch (RuntimeException ex) {
            return null;
        }
>>>>>>> Stashed changes
    }

    // Keeps user-entered text from breaking the pipe-separated file format.
    private String clean(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
