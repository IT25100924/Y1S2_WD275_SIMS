package com.inventory.sims.supplier;

// Model class for one supplier record.
// The same object is used by controllers, JSP pages, and the text-file storage layer.
public class Supplier {
    // Basic supplier fields saved in suppliers.txt.
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

    // Main constructor used when creating a supplier from form data or file data.
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

    // Getters are used by JSP EL expressions and other modules such as product and stock-in.
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

    // Converts this supplier into one line for src/main/resources/data/suppliers.txt.
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

    // Builds a Supplier object from one saved file line.
    // Returns null for old or broken rows so the app can keep running.
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

    // Keeps the pipe delimiter out of saved values and avoids null text in the file.
    private String clean(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
