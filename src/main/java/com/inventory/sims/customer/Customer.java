package com.inventory.sims.customer;

public class Customer {
    private String id;
    private String name;
    private String email;
    private String phone;
    private String address;

    public Customer() {
    }

    public Customer(String id, String name, String email, String phone, String address) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

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

    public String toFileLine() {
        return String.join("|", clean(id), clean(name), clean(email), clean(phone), clean(address));
    }

    public static Customer fromFileLine(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 5) {
            return null;
        }
        return new Customer(parts[0], parts[1], parts[2], parts[3], parts[4]);
    }

    private String clean(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
