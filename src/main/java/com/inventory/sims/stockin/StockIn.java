package com.inventory.sims.stockin;

public class StockIn {
    private String id;
    private String productId;
    private String productName;
    private String supplierName;
    private int quantity;
    private double unitCost;
    private String receivedDate;
    private String note;

    public StockIn() {
    }

    public StockIn(String id, String productId, String productName, String supplierName,
                   int quantity, double unitCost, String receivedDate, String note) {
        this.id = id;
        this.productId = productId;
        this.productName = productName;
        this.supplierName = supplierName;
        this.quantity = quantity;
        this.unitCost = unitCost;
        this.receivedDate = receivedDate;
        this.note = note;
    }

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

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(double unitCost) {
        this.unitCost = unitCost;
    }

    public String getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(String receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public double getTotalCost() {
        return quantity * unitCost;
    }

    public String toFileLine() {
        return String.join("|",
                clean(id),
                clean(productId),
                clean(productName),
                clean(supplierName),
                Integer.toString(quantity),
                Double.toString(unitCost),
                clean(receivedDate),
                clean(note));
    }

    public static StockIn fromFileLine(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 8) {
            return null;
        }

        try {
            return new StockIn(
                    parts[0],
                    parts[1],
                    parts[2],
                    parts[3],
                    Integer.parseInt(parts[4]),
                    Double.parseDouble(parts[5]),
                    parts[6],
                    parts[7]);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String clean(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
