package com.inventory.sims.customer;

import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Locale;

// Contains customer business rules and keeps controllers away from file logic.
@Service
public class CustomerService {
    // File handler is responsible for the actual customers.txt read/write operations.
    private final CustomerFileHandler customerFileHandler;

    // Spring injects the customer file handler through this constructor.
    public CustomerService(CustomerFileHandler customerFileHandler) {
        this.customerFileHandler = customerFileHandler;
    }

    // Validate form data, create a new customer ID, and save the customer.
    public Customer addCustomer(String name, String email, String phone, String address) {
        validateRequired(name, "Customer name");
        validateRequired(email, "Email");
        validateRequired(phone, "Phone");

        List<Customer> customers = customerFileHandler.readCustomers();
        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        if (emailExists(customers, normalizedEmail)) {
            throw new IllegalArgumentException("A customer with this email already exists.");
        }

        Customer customer = new Customer(nextCustomerId(customers), name.trim(), normalizedEmail, phone.trim(), safeTrim(address));
        customerFileHandler.saveCustomer(customer);
        return customer;
    }

    // Return all customers ordered by customer ID, newest ID first.
    public List<Customer> getAllCustomers() {
        return customerFileHandler.readCustomers().stream()
                .sorted(Comparator.comparing(
                        Customer::getId,
                        Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed())))
                .toList();
    }

    // Find one customer by ID. Returns null when the ID is empty or not found.
    public Customer getCustomerById(String id) {
        if (id == null || id.isBlank()) {
            return null;
        }
        return findCustomerById(customerFileHandler.readCustomers(), id);
    }

    // Validate and save changed customer details.
    public Customer updateCustomer(String id, String name, String email, String phone, String address) {
        validateRequired(id, "Customer ID");
        validateRequired(name, "Customer name");
        validateRequired(email, "Email");
        validateRequired(phone, "Phone");

        List<Customer> customers = customerFileHandler.readCustomers();
        String customerId = id.trim();
        Customer existingCustomer = findCustomerById(customers, customerId);
        if (existingCustomer == null) {
            throw new IllegalArgumentException("Customer not found.");
        }

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        if (emailExistsForAnotherCustomer(customers, normalizedEmail, customerId)) {
            throw new IllegalArgumentException("A customer with this email already exists.");
        }

        Customer updatedCustomer = new Customer(customerId, name.trim(), normalizedEmail, phone.trim(), safeTrim(address));
        customerFileHandler.updateCustomer(updatedCustomer);
        return updatedCustomer;
    }

    // Validate and delete a customer by ID.
    public void deleteCustomer(String id) {
        validateRequired(id, "Customer ID");

        String customerId = id.trim();
        Customer existingCustomer = findCustomerById(customerFileHandler.readCustomers(), customerId);
        if (existingCustomer == null) {
            throw new IllegalArgumentException("Customer not found.");
        }

        customerFileHandler.deleteCustomer(customerId);
    }

    // Check whether any existing customer already uses the same email.
    private boolean emailExists(List<Customer> customers, String email) {
        for (Customer customer : customers) {
            if (email.equalsIgnoreCase(customer.getEmail())) {
                return true;
            }
        }
        return false;
    }

    // Check duplicate email while allowing the current customer to keep their own email.
    private boolean emailExistsForAnotherCustomer(List<Customer> customers, String email, String customerId) {
        for (Customer customer : customers) {
            if (email.equalsIgnoreCase(customer.getEmail()) && !customerId.equals(customer.getId())) {
                return true;
            }
        }
        return false;
    }

    // Generate the next customer ID using the largest existing numeric ID.
    private String nextCustomerId(List<Customer> customers) {
        int max = 0;
        for (Customer customer : customers) {
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

    // Find a customer in a provided list without reading the file again.
    private Customer findCustomerById(List<Customer> customers, String id) {
        for (Customer customer : customers) {
            if (id.equals(customer.getId())) {
                return customer;
            }
        }
        return null;
    }

    // Required fields cannot be empty.
    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    // Optional fields are stored as an empty string when not entered.
    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
