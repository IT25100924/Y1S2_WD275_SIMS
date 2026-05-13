package com.inventory.sims.product;

public class FoodProduct extends Product {
    private String expirationDate;

    // Default constructor
    public FoodProduct() {
        super();
    }

    // Parameterized constructor
    public FoodProduct(String id, String name, double price, int quantity, String expirationDate) {
        super(id, name, price, quantity);
        this.expirationDate = expirationDate;
    }

    // Getter and Setter
    public String getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(String expirationDate) {
        this.expirationDate = expirationDate;
    }

    // Override the toString method
    @Override
    public String toString() {
        return "FoodProduct{" +
                "id='" + getId() + '\'' +
                ", name='" + getName() + '\'' +
                ", price=" + getPrice() +
                ", quantity=" + getQuantity() +
                ", expirationDate='" + expirationDate + '\'' +
                '}';
    }

    // Override to format the string specific to Food
    @Override
    public String toFileString() {
        return "Food!" + getId() + "!" + getName() + "!" + getPrice() + "!" + getQuantity() + "!" + expirationDate;
    }
    
}
