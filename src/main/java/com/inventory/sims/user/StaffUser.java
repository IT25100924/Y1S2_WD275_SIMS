package com.inventory.sims.user;

// StaffUser is a specialized User with STAFF role.
// Staff users can use normal inventory features but cannot manage user accounts.
public class StaffUser extends User {
    public StaffUser(String id, String firstName, String lastName, String email, String phone, String password, boolean active) {
        // The role is fixed as STAFF, so callers do not need to pass it manually.
        super(id, firstName, lastName, email, phone, UserType.STAFF, password, active);
    }
}
