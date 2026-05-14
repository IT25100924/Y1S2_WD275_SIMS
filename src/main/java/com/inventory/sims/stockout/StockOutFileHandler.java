package com.inventory.sims.stockout;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

@Component
public class StockOutFileHandler {
    private static final Path STOCK_OUT_FILE = Path.of("src/main/resources/data/stockout.txt");

    public List<StockOut> readStockOuts() {
        ensureFile();

        List<StockOut> stockOuts = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(STOCK_OUT_FILE, StandardCharsets.UTF_8)) {
                if (line == null || line.isBlank()) {
                    continue;
                }
                StockOut stockOut = StockOut.fromFileLine(line);
                if (stockOut != null) {
                    stockOuts.add(stockOut);
                }
            }
        } catch (IOException | RuntimeException ex) {
            throw new IllegalStateException("Unable to read stockout file", ex);
        }
        return stockOuts;
    }

    public void saveStockOut(StockOut stockOut) {
        ensureFile();

        try {
            Files.writeString(
                    STOCK_OUT_FILE,
                    stockOut.toFileLine() + System.lineSeparator(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to save stockout record", ex);
        }
    }

    private void ensureFile() {
        try {
            Path parent = STOCK_OUT_FILE.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
            if (Files.notExists(STOCK_OUT_FILE)) {
                Files.createFile(STOCK_OUT_FILE);
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to prepare stockout file", ex);
        }
    }
}
