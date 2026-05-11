package com.inventory.sims.supplier;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;

@Service
public class SupplierService {
    private final SupplierFileHandler supplierFileHandler;

    public SupplierService(SupplierFileHandler supplierFileHandler) {
        this.supplierFileHandler = supplierFileHandler;
    }

    public Supplier registerSupplier(String companyName,
                                     String category,
                                     String contactPerson,
                                     String phone,
                                     String email,
                                     String city,
                                     String leadTime,
                                     String address,
                                     String notes,
                                     boolean active) {
        validateRequired(companyName, "Company name");
        validateRequired(category, "Category");
        validateRequired(contactPerson, "Contact person");
        validateRequired(phone, "Phone number");
        validateRequired(email, "Email");

        String normalizedCategory = category.trim().toUpperCase(Locale.ROOT);
        if (!"LOCAL".equals(normalizedCategory) && !"IMPORT".equals(normalizedCategory)) {
            throw new IllegalArgumentException("Category must be LOCAL or IMPORT.");
        }

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        if (emailExists(normalizedEmail)) {
            throw new IllegalArgumentException("A supplier with this email already exists.");
        }

        Supplier supplier = new Supplier(
                nextSupplierId(),
                companyName.trim(),
                normalizedCategory,
                contactPerson.trim(),
                phone.trim(),
                normalizedEmail,
                safeTrim(city),
                safeTrim(leadTime),
                safeTrim(address),
                safeTrim(notes),
                active ? "ACTIVE" : "PENDING");

        supplierFileHandler.saveSupplier(supplier);
        return supplier;
    }

    public List<Supplier> getAllSuppliers() {
        return supplierFileHandler.readSuppliers();
    }

    private boolean emailExists(String email) {
        return supplierFileHandler.readSuppliers().stream()
                .anyMatch(supplier -> email.equalsIgnoreCase(supplier.getEmail()));
    }

    private String nextSupplierId() {
        int max = 0;
        for (Supplier supplier : supplierFileHandler.readSuppliers()) {
            String id = supplier.getId();
            if (id != null && id.startsWith("S")) {
                try {
                    max = Math.max(max, Integer.parseInt(id.substring(1)));
                } catch (NumberFormatException ignored) {
                    // Ignore malformed old records and keep generating from valid IDs.
                }
            }
        }
        return String.format("S%03d", max + 1);
    }

    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
