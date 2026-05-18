package com.inventory.sims.customer;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

// Handles only file reading and writing for customer records.
@Component
public class CustomerFileHandler {
    // Location of the text file used as the customer data store.
    private static final Path CUSTOMERS_FILE = Path.of("src/main/resources/data/customers.txt");

    // Read all valid customer rows from the file.
    public List<Customer> readCustomers() {
        ensureFile();

        List<Customer> customers = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(CUSTOMERS_FILE, StandardCharsets.UTF_8)) {
                // Skip empty lines so accidental blank rows do not break the customer list.
                if (line == null || line.isBlank()) {
                    continue;
                }

                // Ignore malformed rows instead of stopping the whole page.
                Customer customer = Customer.fromFileLine(line);
                if (customer != null) {
                    customers.add(customer);
                }
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to read customers file", ex);
        }
        return customers;
    }

    // Add one new customer row to the end of the file.
    public void saveCustomer(Customer customer) {
        ensureFile();

        try {
            Files.writeString(
                    CUSTOMERS_FILE,
                    customer.toFileLine() + System.lineSeparator(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to save customer", ex);
        }
    }

    // Replace an existing customer row with updated details.
    public void updateCustomer(Customer updatedCustomer) {
        List<Customer> customers = readCustomers();
        boolean found = false;

        for (int i = 0; i < customers.size(); i++) {
            if (updatedCustomer.getId().equals(customers.get(i).getId())) {
                customers.set(i, updatedCustomer);
                found = true;
                break;
            }
        }

        if (!found) {
            throw new IllegalArgumentException("Customer not found.");
        }

        writeCustomers(customers);
    }

    // Remove one customer row from the file.
    public void deleteCustomer(String id) {
        List<Customer> customers = readCustomers();
        boolean removed = customers.removeIf(customer -> id.equals(customer.getId()));

        if (!removed) {
            throw new IllegalArgumentException("Customer not found.");
        }

        writeCustomers(customers);
    }

    // Rewrite the whole customer file after update or delete.
    private void writeCustomers(List<Customer> customers) {
        ensureFile();

        List<String> lines = new ArrayList<>();
        for (Customer customer : customers) {
            lines.add(customer.toFileLine());
        }

        try {
            Files.write(CUSTOMERS_FILE, lines, StandardCharsets.UTF_8);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to update customers file", ex);
        }
    }

    // Create the data folder and file if they do not already exist.
    private void ensureFile() {
        try {
            Path parent = CUSTOMERS_FILE.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
            if (Files.notExists(CUSTOMERS_FILE)) {
                Files.createFile(CUSTOMERS_FILE);
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to prepare customers file", ex);
        }
    }
}
