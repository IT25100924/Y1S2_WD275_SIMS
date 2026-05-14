package com.inventory.sims.customer;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;

@Service
public class CustomerService {
    private final CustomerFileHandler customerFileHandler;

    public CustomerService(CustomerFileHandler customerFileHandler) {
        this.customerFileHandler = customerFileHandler;
    }

    public Customer addCustomer(String name, String email, String phone, String address) {
        validateRequired(name, "Customer name");
        validateRequired(email, "Email");
        validateRequired(phone, "Phone");

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        if (emailExists(normalizedEmail)) {
            throw new IllegalArgumentException("A customer with this email already exists.");
        }

        Customer customer = new Customer(nextCustomerId(), name.trim(), normalizedEmail, phone.trim(), safeTrim(address));
        customerFileHandler.saveCustomer(customer);
        return customer;
    }

    public List<Customer> getAllCustomers() {
        return customerFileHandler.readCustomers();
    }

    private boolean emailExists(String email) {
        return customerFileHandler.readCustomers().stream()
                .anyMatch(customer -> email.equalsIgnoreCase(customer.getEmail()));
    }

    private String nextCustomerId() {
        int max = 0;
        for (Customer customer : customerFileHandler.readCustomers()) {
            String id = customer.getId();
            if (id != null && id.startsWith("C")) {
                try {
                    max = Math.max(max, Integer.parseInt(id.substring(1)));
                } catch (NumberFormatException ignored) {
                    // Ignore malformed old records and keep generating from valid IDs.
                }
            }
        }
        return String.format("C%03d", max + 1);
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
