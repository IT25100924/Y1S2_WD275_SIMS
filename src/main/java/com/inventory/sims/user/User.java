package com.inventory.sims.user;

public class User {
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
        String[] parts = line.split("\\|", -1);
        if (parts.length < 8) {
            return null;
        }

        UserType parsedRole;
        try {
            parsedRole = UserType.valueOf(parts[5]);
        } catch (IllegalArgumentException ex) {
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
        if (value == null) {
            return "";
        }
        return value.replace("|", " ").trim();
    }
}
