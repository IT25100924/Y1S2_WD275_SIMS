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
