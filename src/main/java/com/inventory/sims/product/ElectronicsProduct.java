package com.inventory.sims.product;

public class ElectronicsProduct extends Product {
    private int warrantyMonths;

    // Default constructor
    public ElectronicsProduct() {
        super();
    }

    // Parameterized constructor
    public ElectronicsProduct(String id, String name, double price, int quantity, int warrantyMonths) {
        super(id, name, price, quantity);
        this.warrantyMonths = warrantyMonths;
    }

    // Getter and Setter for the specific property
    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }

    // Override the toString method
    @Override
    public String toString() {
        return "ElectronicsProduct{" +
                "id='" + getId() + '\'' +
                ", name='" + getName() + '\'' +
                ", price=" + getPrice() +
                ", quantity=" + getQuantity() +
                ", warrantyMonths=" + warrantyMonths +
                '}';
    }

    // Override to format the string specific to Electronics
    @Override
    public String toFileString() {
        return "Electronics!" + getId() + "!" + getName() + "!" + getPrice() + "!" + getQuantity() + "!" + warrantyMonths;
    }

}
