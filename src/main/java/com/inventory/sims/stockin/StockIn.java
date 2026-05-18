package com.inventory.sims.stockin;

// Model class for one stock-in record.
// It stores the record details and knows how to convert itself to/from stockin.txt.
public class StockIn {
    // Main record fields shown in the Stock In screens.
    private String id;
    private String productId;
    private String productName;
    private String supplierName;
    private int quantity;
    private double unitCost;
    private String receivedDate;

    // Extra product-type fields used only for Food or Electronics products.
    private String productType;
    private String expirationDate;
    private int warrantyMonths;
    private String note;

    // Empty constructor is required by Spring/JSP binding tools when needed.
    public StockIn() {
    }

    // Short constructor keeps old 8-column file rows compatible.
    public StockIn(String id, String productId, String productName, String supplierName,
                   int quantity, double unitCost, String receivedDate, String note) {
        this(id, productId, productName, supplierName, quantity, unitCost, receivedDate, "", "", 0, note);
    }

    // Full constructor used by the current Stock In form and file format.
    public StockIn(String id, String productId, String productName, String supplierName,
                   int quantity, double unitCost, String receivedDate, String productType,
                   String expirationDate, int warrantyMonths, String note) {
        this.id = id;
        this.productId = productId;
        this.productName = productName;
        this.supplierName = supplierName;
        this.quantity = quantity;
        this.unitCost = unitCost;
        this.receivedDate = receivedDate;
        this.productType = productType;
        this.expirationDate = expirationDate;
        this.warrantyMonths = warrantyMonths;
        this.note = note;
    }

    // Standard getters and setters are used by controllers, services, and JSP pages.
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

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public String getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(String expirationDate) {
        this.expirationDate = expirationDate;
    }

    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    // Total stock-in cost is calculated when requested, not stored separately in the file.
    public double getTotalCost() {
        return quantity * unitCost;
    }

    // Gives JSP pages a simple display value for product-type-specific details.
    public String getSpecialDetails() {
        if ("Food".equalsIgnoreCase(productType) && expirationDate != null && !expirationDate.isBlank()) {
            return "Expiry: " + expirationDate;
        }
        if ("Electronics".equalsIgnoreCase(productType)) {
            return "Warranty: " + warrantyMonths + " months";
        }
        return "-";
    }

    // Converts this object into one pipe-separated row for stockin.txt.
    public String toFileLine() {
        return String.join("|",
                clean(id),
                clean(productId),
                clean(productName),
                clean(supplierName),
                Integer.toString(quantity),
                Double.toString(unitCost),
                clean(receivedDate),
                clean(productType),
                clean(expirationDate),
                Integer.toString(warrantyMonths),
                clean(note));
    }

    // Builds a StockIn object from one row in stockin.txt.
    // Bad old rows are skipped by returning null instead of breaking the whole list.
    public static StockIn fromFileLine(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 8) {
            return null;
        }

        try {
            if (parts.length >= 11) {
                return new StockIn(
                        parts[0],
                        parts[1],
                        parts[2],
                        parts[3],
                        Integer.parseInt(parts[4]),
                        Double.parseDouble(parts[5]),
                        parts[6],
                        parts[7],
                        parts[8],
                        Integer.parseInt(parts[9]),
                        parts[10]);
            }

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

    // Keeps the pipe delimiter out of stored text fields and avoids null values in files.
    private String clean(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
