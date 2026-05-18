package com.inventory.sims.supplier;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

@Component
public class SupplierFileHandler {
    // Supplier data is stored as pipe-separated text lines.
    private static final Path SUPPLIERS_FILE = Path.of("src/main/resources/data/suppliers.txt");

    // Reads all valid supplier rows from the file.
    public List<Supplier> readSuppliers() {
        ensureFile();

        List<Supplier> suppliers = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(SUPPLIERS_FILE, StandardCharsets.UTF_8)) {
                if (line == null || line.isBlank()) {
                    continue;
                }
                Supplier supplier = Supplier.fromFileLine(line);
                if (supplier != null) {
                    suppliers.add(supplier);
                }
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to read suppliers file", ex);
        }
        return suppliers;
    }

    // Appends one new supplier row to the file.
    public void saveSupplier(Supplier supplier) {
        ensureFile();

        try {
            Files.writeString(
                    SUPPLIERS_FILE,
                    supplier.toFileLine() + System.lineSeparator(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to save supplier", ex);
        }
    }

    // Rewrites the whole supplier file after update or delete.
    public void saveAllSuppliers(List<Supplier> suppliers) {
        ensureFile();

        StringBuilder content = new StringBuilder();
        for (Supplier supplier : suppliers) {
            content.append(supplier.toFileLine()).append(System.lineSeparator());
        }

        try {
            Files.writeString(
                    SUPPLIERS_FILE,
                    content.toString(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.TRUNCATE_EXISTING);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to update suppliers", ex);
        }
    }

    // Creates the data folder and file when they do not exist yet.
    private void ensureFile() {
        try {
            Path parent = SUPPLIERS_FILE.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
            if (Files.notExists(SUPPLIERS_FILE)) {
                Files.createFile(SUPPLIERS_FILE);
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to prepare suppliers file", ex);
        }
    }
}
