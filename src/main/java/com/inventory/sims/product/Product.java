package com.inventory.sims.product;

public class Product {
    private String id;
    private String name;
    private double price;
    private int quantity;
    private String supplierId;

    // Default constructor
    public Product() {
    }

    // Parameterized constructor
    public Product(String id, String name, double price, int quantity, String supplierId) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.supplierId = supplierId;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getSupplierId() {
        return supplierId;
    }
    public void setSupplierId(String supplierId) {
        this.supplierId = supplierId;
    }

    // toString method for easier debugging
    @Override
    public String toString() {
        return "Product{" +
                "id='" + id + '\'' +
                ", supplierId='" + supplierId + '\'' +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }

    // Method to format the product for file storage
    public String toFileString() {
        return "General!" + id + "!" + supplierId + "!" + name + "!" + price + "!" + quantity;
    }

}
