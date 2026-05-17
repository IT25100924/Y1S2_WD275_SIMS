package com.inventory.sims.product;

public class FoodProduct extends Product {
    private String expirationDate;

    // Default constructor
    public FoodProduct() {
        super();
    }

    // Parameterized constructor
    public FoodProduct(String id, String name, double mrp, double defaultStockInPrice, double defaultStockOutPrice, int quantity, String supplierId, String expirationDate) {
        super(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, quantity, supplierId);
        this.expirationDate = expirationDate;
    }

    // Getter and Setter
    public String getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(String expirationDate) {
        this.expirationDate = expirationDate;
    }

    // Override to format the string specific to Food
    @Override
    public String toFileString() {
        return "Food!" + getId() + "!" + getSupplierId() + "!" + getName() + "!" + getMrp() + "!" + getDefaultStockInPrice() + "!" + getDefaultStockOutPrice() + "!" + getQuantity() + "!" + expirationDate;
    }
    
}
