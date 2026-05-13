package com.inventory.sims.supplier;

import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

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

    public List<Supplier> searchSuppliers(String keyword) {
        String normalizedKeyword = safeTrim(keyword).toLowerCase(Locale.ROOT);

        return supplierFileHandler.readSuppliers().stream()
                .filter(supplier -> normalizedKeyword.isEmpty() || containsSupplierKeyword(supplier, normalizedKeyword))
                .sorted(Comparator.comparing(Supplier::getCompanyName, String.CASE_INSENSITIVE_ORDER))
                .collect(Collectors.toList());
    }

    public Optional<Supplier> findById(String supplierId) {
        if (supplierId == null || supplierId.isBlank()) {
            return Optional.empty();
        }

        return supplierFileHandler.readSuppliers().stream()
                .filter(supplier -> supplierId.equalsIgnoreCase(supplier.getId()))
                .findFirst();
    }

    public long countActiveSuppliers() {
        return supplierFileHandler.readSuppliers().stream()
                .filter(supplier -> "ACTIVE".equalsIgnoreCase(supplier.getStatus()))
                .count();
    }

    public long countPendingSuppliers() {
        return supplierFileHandler.readSuppliers().stream()
                .filter(supplier -> "PENDING".equalsIgnoreCase(supplier.getStatus()))
                .count();
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

    private boolean containsSupplierKeyword(Supplier supplier, String keyword) {
        return contains(supplier.getId(), keyword)
                || contains(supplier.getCompanyName(), keyword)
                || contains(supplier.getCategory(), keyword)
                || contains(supplier.getContactPerson(), keyword)
                || contains(supplier.getPhone(), keyword)
                || contains(supplier.getEmail(), keyword)
                || contains(supplier.getCity(), keyword)
                || contains(supplier.getLeadTime(), keyword)
                || contains(supplier.getAddress(), keyword)
                || contains(supplier.getNotes(), keyword)
                || contains(supplier.getStatus(), keyword);
    }

    private boolean contains(String value, String keyword) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(keyword);
    }
}
