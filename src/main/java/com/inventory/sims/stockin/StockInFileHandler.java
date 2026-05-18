package com.inventory.sims.stockin;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

@Component
// File handler for stockin.txt.
// This class only reads/writes records; business rules stay in StockInService.
public class StockInFileHandler {
    // Stock-in records are stored as pipe-separated text rows in this file.
    private static final Path STOCK_IN_FILE = Path.of("src/main/resources/data/stockin.txt");

    // Reads all valid stock-in rows from the text file.
    public List<StockIn> readStockIns() {
        ensureFile();

        List<StockIn> stockIns = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(STOCK_IN_FILE, StandardCharsets.UTF_8)) {
                if (line == null || line.isBlank()) {
                    continue;
                }
                StockIn stockIn = StockIn.fromFileLine(line);
                if (stockIn != null) {
                    stockIns.add(stockIn);
                }
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to read stock-in file", ex);
        }
        return stockIns;
    }

    // Appends one new stock-in record without rewriting the whole file.
    public void saveStockIn(StockIn stockIn) {
        ensureFile();

        try {
            Files.writeString(
                    STOCK_IN_FILE,
                    stockIn.toFileLine() + System.lineSeparator(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to save stock-in record", ex);
        }
    }

    // Rewrites the whole file after update/delete operations.
    public void saveAllStockIns(List<StockIn> stockIns) {
        ensureFile();

        List<String> lines = new ArrayList<>();
        for (StockIn stockIn : stockIns) {
            lines.add(stockIn.toFileLine());
        }

        try {
            Files.write(
                    STOCK_IN_FILE,
                    lines,
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.TRUNCATE_EXISTING);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to update stock-in records", ex);
        }
    }

    // Creates the data folder/file when the application starts with missing files.
    private void ensureFile() {
        try {
            Path parent = STOCK_IN_FILE.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
            if (Files.notExists(STOCK_IN_FILE)) {
                Files.createFile(STOCK_IN_FILE);
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to prepare stock-in file", ex);
        }
    }
}
