package com.inventory.sims.product;

public class ElectronicsProduct extends Product {
    private int warrantyMonths;

    // Default constructor
    public ElectronicsProduct() {
        super();
    }

    // Parameterized constructor
    public ElectronicsProduct(String id, String name, double mrp, double defaultStockInPrice, double defaultStockOutPrice, int quantity, String supplierId, int warrantyMonths) {
        super(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, quantity, supplierId);
        this.warrantyMonths = warrantyMonths;
    }

    // Getter and Setter for the specific property
    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    // Override to format the string specific to Electronics
    @Override
    public String toFileString() {
        return "Electronics!" + getId() + "!" + getSupplierId() + "!" + getName() + "!" + getMrp() + "!" + getDefaultStockInPrice() + "!" + getDefaultStockOutPrice() + "!" + getQuantity() + "!" + warrantyMonths;
    }

}
