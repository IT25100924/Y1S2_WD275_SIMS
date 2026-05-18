package com.inventory.sims.customer;

// Customer model class. This object stores one customer record in the system.
public class Customer {
    // Basic customer details saved in the customers.txt file.
    private String id;
    private String name;
    private String email;
    private String phone;
    private String address;

    // Empty constructor is required by Spring/JSP form binding and general object creation.
    public Customer() {
    }

    // Constructor used when creating or loading a complete customer record.
    public Customer(String id, String name, String email, String phone, String address) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    // Getter and setter methods give other classes safe access to customer fields.
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    // Convert a customer object into one text-file row.
    public String toFileLine() {
        return String.join("|", clean(id), clean(name), clean(email), clean(phone), clean(address));
    }

    // Convert one text-file row back into a Customer object.
    public static Customer fromFileLine(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 5) {
            return null;
        }
        return new Customer(parts[0], parts[1], parts[2], parts[3], parts[4]);
    }

    // Clean field values before saving so the pipe separator cannot break the file format.
    private String clean(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
