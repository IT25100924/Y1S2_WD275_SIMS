package com.inventory.sims.user;

// User is the main model class for the user module.
// It holds the data that moves between the file, service, controller, and JSP pages.
public class User {
    // These fields match the order stored in users.txt.
    private String id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private UserType role;
    private String password;
    private boolean active;

    public User() {
    }

    // Full constructor used when creating User objects from code or from the text file.
    public User(String id, String firstName, String lastName, String email, String phone, UserType role, String password, boolean active) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.password = password;
        this.active = active;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
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

    public UserType getRole() {
        return role;
    }

    public void setRole(UserType role) {
        this.role = role;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String toFileLine() {
        // Convert a User object into one text-file line.
        // The pipe symbol is the separator: id|firstName|lastName|email|phone|role|password|active
        return String.join("|",
                clean(id),
                clean(firstName),
                clean(lastName),
                clean(email),
                clean(phone),
                role == null ? "" : role.name(),
                clean(password),
                Boolean.toString(active));
    }

    public static User fromFileLine(String line) {
        // Convert one users.txt line back into a User object.
        String[] parts = line.split("\\|", -1);
        if (parts.length < 8) {
            // Invalid old or broken records are ignored by returning null.
            return null;
        }

        UserType parsedRole;
        try {
            parsedRole = UserType.valueOf(parts[5]);
        } catch (IllegalArgumentException ex) {
            // If the role text is invalid, default to STAFF because it has less access than ADMIN.
            parsedRole = UserType.STAFF;
        }

        return new User(
                parts[0],
                parts[1],
                parts[2],
                parts[3],
                parts[4],
                parsedRole,
                parts[6],
                Boolean.parseBoolean(parts[7]));
    }

    private String clean(String value) {
        // Prevent the separator character from breaking the users.txt format.
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
