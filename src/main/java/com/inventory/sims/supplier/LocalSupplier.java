package com.inventory.sims.supplier;

// Simple specialization for a local supplier.
// The current supplier module stores the supplier type in Supplier.category,
// so this class is kept small and safe for future local-supplier-specific logic.
public class LocalSupplier extends Supplier {

    // Default constructor is useful for frameworks or future form binding.
    public LocalSupplier() {
        super();
    }

    // Convenience constructor that always stores the category as LOCAL.
    public LocalSupplier(String id, String companyName, String contactPerson, String phone, String email,
                         String city, String leadTime, String address, String notes, String status) {
        super(id, companyName, "LOCAL", contactPerson, phone, email, city, leadTime, address, notes, status);
    }
}
