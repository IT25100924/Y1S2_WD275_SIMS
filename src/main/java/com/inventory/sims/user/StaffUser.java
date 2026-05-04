package com.inventory.sims.user;

public class StaffUser extends User {
    public StaffUser(String id, String firstName, String lastName, String email, String phone, String password, boolean active) {
        super(id, firstName, lastName, email, phone, UserType.STAFF, password, active);
    }
}
