package com.inventory.sims.customer;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

@Component
public class CustomerFileHandler {
    private static final Path CUSTOMERS_FILE = Path.of("src/main/resources/data/customers.txt");

    public List<Customer> readCustomers() {
        ensureFile();

        List<Customer> customers = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(CUSTOMERS_FILE, StandardCharsets.UTF_8)) {
                if (line == null || line.isBlank()) {
                    continue;
                }
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

    public void updateCustomer(Customer updatedCustomer) {
        List<Customer> customers = readCustomers();
        boolean found = false;

        for (int i = 0; i < customers.size(); i++) {
            if (customers.get(i).getId().equals(updatedCustomer.getId())) {
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

    public void deleteCustomer(String id) {
        List<Customer> customers = readCustomers();
        boolean removed = customers.removeIf(customer -> customer.getId().equals(id));

        if (!removed) {
            throw new IllegalArgumentException("Customer not found.");
        }

        writeCustomers(customers);
    }

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
