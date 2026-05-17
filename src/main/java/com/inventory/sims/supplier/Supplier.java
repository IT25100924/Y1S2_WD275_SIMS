package com.inventory.sims.supplier;

public class Supplier {
    private String id;
    private String companyName;
    private String category;
    private String contactPerson;
    private String phone;
    private String email;
    private String city;
    private String leadTime;
    private String address;
    private String notes;
    private String status;

    public Supplier() {
    }

    public Supplier(String id, String companyName, String category, String contactPerson, String phone, String email,
                    String city, String leadTime, String address, String notes, String status) {
        this.id = id;
        this.companyName = companyName;
        this.category = category;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.email = email;
        this.city = city;
        this.leadTime = leadTime;
        this.address = address;
        this.notes = notes;
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public String getCompanyName() {
        return companyName;
    }

    public String getCategory() {
        return category;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public String getPhone() {
        return phone;
    }

    public String getEmail() {
        return email;
    }

    public String getCity() {
        return city;
    }

    public String getLeadTime() {
        return leadTime;
    }

    public String getAddress() {
        return address;
    }

    public String getNotes() {
        return notes;
    }

    public String getStatus() {
        return status;
    }

    public String toFileLine() {
        return String.join("|",
                clean(id),
                clean(companyName),
                clean(category),
                clean(contactPerson),
                clean(phone),
                clean(email),
                clean(city),
                clean(leadTime),
                clean(address),
                clean(notes),
                clean(status));
    }

    public static Supplier fromFileLine(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 11) {
            return null;
        }

        return new Supplier(
                parts[0],
                parts[1],
                parts[2],
                parts[3],
                parts[4],
                parts[5],
                parts[6],
                parts[7],
                parts[8],
                parts[9],
                parts[10]);
    }

    private String clean(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
