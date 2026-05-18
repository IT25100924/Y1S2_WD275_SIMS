package com.inventory.sims.user;

// AdminUser is a specialized User with ADMIN role.
// Admin users can access full system features, including user management.
public class AdminUser extends User {
    public AdminUser(String id, String firstName, String lastName, String email, String phone, String password, boolean active) {
        // The role is fixed as ADMIN, so callers do not need to pass it manually.
        super(id, firstName, lastName, email, phone, UserType.ADMIN, password, active);
    }
}
