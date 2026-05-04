package com.inventory.sims.user;

public class AdminUser extends User {
    public AdminUser(String id, String firstName, String lastName, String email, String phone, String password, boolean active) {
        super(id, firstName, lastName, email, phone, UserType.ADMIN, password, active);
    }
}
