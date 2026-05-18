package com.inventory.sims.supplier;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
public class SupplierService {
    // Allowed category and status values used by the supplier forms and JSP pages.
    private static final String CATEGORY_LOCAL = "LOCAL";
    private static final String CATEGORY_IMPORT = "IMPORT";
    private static final String STATUS_ACTIVE = "ACTIVE";
    private static final String STATUS_PENDING = "PENDING";

    // Shared newest-first sorting by supplier ID, such as S005 before S004.
    private static final Comparator<Supplier> NEWEST_FIRST = Comparator.comparing(
            Supplier::getId,
            Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed()));

    // File handler owns reading and writing suppliers.txt.
    private final SupplierFileHandler supplierFileHandler;

    public SupplierService(SupplierFileHandler supplierFileHandler) {
        this.supplierFileHandler = supplierFileHandler;
    }

    // Validates form input, creates the next supplier ID, then saves a new supplier.
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
        validateSupplierFields(companyName, category, contactPerson, phone, email);

        String supplierId = nextSupplierId();
        String normalizedEmail = normalizeEmail(email);
        if (emailExists(normalizedEmail, null)) {
            throw new IllegalArgumentException("A supplier with this email already exists.");
        }

        Supplier supplier = buildSupplier(supplierId, companyName, category, contactPerson, phone, email,
                city, leadTime, address, notes, active);

        supplierFileHandler.saveSupplier(supplier);
        return supplier;
    }

    // Returns all suppliers for dropdowns and pages that do not need filtering.
    public List<Supplier> getAllSuppliers() {
        return sortNewestFirst(supplierFileHandler.readSuppliers());
    }

    // Searches suppliers across the fields visible in the supplier table.
    public List<Supplier> searchSuppliers(String keyword) {
        String normalizedKeyword = safeTrim(keyword).toLowerCase(Locale.ROOT);

        return supplierFileHandler.readSuppliers().stream()
                .filter(supplier -> normalizedKeyword.isEmpty() || containsSupplierKeyword(supplier, normalizedKeyword))
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Finds a supplier by ID. Optional lets controllers handle missing records cleanly.
    public Optional<Supplier> findById(String supplierId) {
        if (supplierId == null || supplierId.isBlank()) {
            return Optional.empty();
        }

        return supplierFileHandler.readSuppliers().stream()
                .filter(supplier -> supplierId.equalsIgnoreCase(supplier.getId()))
                .findFirst();
    }

    // Counts active suppliers for the summary cards.
    public long countActiveSuppliers() {
        return countByStatus(STATUS_ACTIVE);
    }

    // Counts pending suppliers for the summary cards.
    public long countPendingSuppliers() {
        return countByStatus(STATUS_PENDING);
    }

    // Validates form input, replaces the matching supplier row, then rewrites the file.
    public Supplier updateSupplier(String supplierId,
                                   String companyName,
                                   String category,
                                   String contactPerson,
                                   String phone,
                                   String email,
                                   String city,
                                   String leadTime,
                                   String address,
                                   String notes,
                                   boolean active) {
        validateRequired(supplierId, "Supplier ID");
        validateSupplierFields(companyName, category, contactPerson, phone, email);

        List<Supplier> suppliers = new ArrayList<>(supplierFileHandler.readSuppliers());

        int supplierIndex = findSupplierIndex(suppliers, supplierId);
        if (supplierIndex == -1) {
            throw new IllegalArgumentException("Supplier not found.");
        }

        Supplier existing = suppliers.get(supplierIndex);
        String normalizedEmail = normalizeEmail(email);
        if (emailExists(normalizedEmail, existing.getId())) {
            throw new IllegalArgumentException("A supplier with this email already exists.");
        }

        Supplier updatedSupplier = buildSupplier(existing.getId(), companyName, category, contactPerson, phone, email,
                city, leadTime, address, notes, active);

        suppliers.set(supplierIndex, updatedSupplier);
        supplierFileHandler.saveAllSuppliers(suppliers);
        return updatedSupplier;
    }

    // Deletes the supplier with the given ID.
    public void deleteSupplier(String supplierId) {
        validateRequired(supplierId, "Supplier ID");

        List<Supplier> suppliers = new ArrayList<>(supplierFileHandler.readSuppliers());
        boolean removed = suppliers.removeIf(supplier -> supplierId.equalsIgnoreCase(supplier.getId()));

        if (!removed) {
            throw new IllegalArgumentException("Supplier not found.");
        }

        supplierFileHandler.saveAllSuppliers(suppliers);
    }

    // Checks for duplicate emails. ignoreSupplierId is used during update to ignore the current row.
    private boolean emailExists(String email, String ignoreSupplierId) {
        return supplierFileHandler.readSuppliers().stream()
                .anyMatch(supplier -> !isSameSupplier(supplier, ignoreSupplierId)
                        && email.equalsIgnoreCase(supplier.getEmail()));
    }

    // Builds the final Supplier object after validation has passed.
    private Supplier buildSupplier(String supplierId,
                                   String companyName,
                                   String category,
                                   String contactPerson,
                                   String phone,
                                   String email,
                                   String city,
                                   String leadTime,
                                   String address,
                                   String notes,
                                   boolean active) {
        return new Supplier(
                supplierId,
                companyName.trim(),
                normalizeCategory(category),
                contactPerson.trim(),
                phone.trim(),
                normalizeEmail(email),
                safeTrim(city),
                safeTrim(leadTime),
                safeTrim(address),
                safeTrim(notes),
                active ? STATUS_ACTIVE : STATUS_PENDING);
    }

    // Generates the next ID, such as S001 then S002.
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

    // Shared validation for register and update forms.
    private void validateSupplierFields(String companyName, String category, String contactPerson, String phone, String email) {
        validateRequired(companyName, "Company name");
        validateRequired(category, "Category");
        validateRequired(contactPerson, "Contact person");
        validateRequired(phone, "Phone number");
        validateRequired(email, "Email");
        normalizeCategory(category);
    }

    // Accepts only the category values used by the forms.
    private String normalizeCategory(String category) {
        String normalizedCategory = category.trim().toUpperCase(Locale.ROOT);
        if (!CATEGORY_LOCAL.equals(normalizedCategory) && !CATEGORY_IMPORT.equals(normalizedCategory)) {
            throw new IllegalArgumentException("Category must be LOCAL or IMPORT.");
        }
        return normalizedCategory;
    }

    // Keeps email comparison consistent for duplicate checks.
    private String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }

    // Finds the list index for update operations.
    private int findSupplierIndex(List<Supplier> suppliers, String supplierId) {
        for (int i = 0; i < suppliers.size(); i++) {
            if (supplierId.equalsIgnoreCase(suppliers.get(i).getId())) {
                return i;
            }
        }
        return -1;
    }

    // Counts suppliers with one status value.
    private long countByStatus(String status) {
        return supplierFileHandler.readSuppliers().stream()
                .filter(supplier -> status.equalsIgnoreCase(supplier.getStatus()))
                .count();
    }

    // Sorts list output in the order expected by the existing UI.
    private List<Supplier> sortNewestFirst(List<Supplier> suppliers) {
        return suppliers.stream()
                .sorted(NEWEST_FIRST)
                .toList();
    }

    // Compares one supplier with the ID that should be ignored in duplicate checks.
    private boolean isSameSupplier(Supplier supplier, String supplierId) {
        return supplierId != null && supplierId.equalsIgnoreCase(supplier.getId());
    }

    // Shared required-field check.
    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    // Trims optional values and turns null into an empty string for file storage.
    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    // Checks all searchable supplier fields.
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

    // Case-insensitive contains helper used by search.
    private boolean contains(String value, String keyword) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(keyword);
    }
}
