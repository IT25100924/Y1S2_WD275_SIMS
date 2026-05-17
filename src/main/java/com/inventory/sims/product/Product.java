package com.inventory.sims.product;

public class Product {
    private String id;
    private String name;
    private double mrp;
    private double defaultStockInPrice;
    private double defaultStockOutPrice;
    private int quantity;
    private String supplierId;

    // Default constructor
    public Product() {
    }

    // Parameterized constructor
    public Product(String id, String name, double mrp, double defaultStockInPrice, double defaultStockOutPrice, int quantity, String supplierId) {
        this.id = id;
        this.name = name;
        this.mrp = mrp;
        this.defaultStockInPrice = defaultStockInPrice;
        this.defaultStockOutPrice = defaultStockOutPrice;
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

    public double getMrp() {
        return mrp;
    }
    public void setMrp(double mrp) {
        this.mrp = mrp;
    }
    public double getDefaultStockInPrice() {
        return defaultStockInPrice;
    }
    public void setDefaultStockInPrice(double defaultStockInPrice) {
        this.defaultStockInPrice = defaultStockInPrice;
    }
    public double getDefaultStockOutPrice() {
        return defaultStockOutPrice;
    }
    public void setDefaultStockOutPrice(double defaultStockOutPrice) {
        this.defaultStockOutPrice = defaultStockOutPrice;
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
                ", mrp=" + mrp +
                ", defaultStockInPrice=" + defaultStockInPrice +
                ", defaultStockOutPrice=" + defaultStockOutPrice +
                ", quantity=" + quantity +
                '}';
    }

    // Method to format the product for file storage
    @Override
    public String toFileString() {
        return "General!" + id + "!" + supplierId + "!" + name + "!" + mrp + "!" + defaultStockInPrice + "!" + defaultStockOutPrice + "!" + quantity;
    }

}
