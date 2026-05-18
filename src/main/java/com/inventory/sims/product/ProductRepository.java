package com.inventory.sims.product;

import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ProductRepository {

    private static final String FILE_PATH = "src/main/resources/data/products.txt";
    private static final String DELIMITER = "!";

    // Read all products from the text file
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        File file = new File(FILE_PATH);

        if (!file.exists()) {
            return products; // Return empty list if file doesn't exist yet
        }

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                Product product = parseProduct(line);
                if (product != null) {
                    products.add(product);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return products;
    }

    private Product parseProduct(String line) {
        String[] data = line.split(DELIMITER, -1);

        if (data.length < 8) {
            return null;
        }

        try {
            String type = data[0];
            String id = data[1];
            String supplierId = data[2];
            String name = data[3];
            double mrp = Double.parseDouble(data[4]);
            double stockInPrice = Double.parseDouble(data[5]);
            double stockOutPrice = Double.parseDouble(data[6]);
            int quantity = Integer.parseInt(data[7]);

            if ("Electronics".equals(type) && data.length >= 9) {
                int warrantyMonths = Integer.parseInt(data[8]);
                return new ElectronicsProduct(id, name, mrp, stockInPrice, stockOutPrice, quantity, supplierId, warrantyMonths);
            }
            if ("Food".equals(type) && data.length >= 9) {
                String expirationDate = data[8];
                return new FoodProduct(id, name, mrp, stockInPrice, stockOutPrice, quantity, supplierId, expirationDate);
            }
            if ("General".equals(type)) {
                return new Product(id, name, mrp, stockInPrice, stockOutPrice, quantity, supplierId);
            }
        } catch (RuntimeException ex) {
            return null;
        }

        return null;
    }

    // Save or Update a product
    public Product save(Product product) {
        List<Product> products = findAll();

        boolean found = false;
        for (int i = 0; i < products.size(); i++) {
            if (products.get(i).getId().equals(product.getId())) {
                products.set(i, product); // Update existing
                found = true;
                break;
            }
        }

        if (!found) {
            products.add(product); // Add new
        }

        saveAll(products);
        return product;
    }

    // Find a specific product by ID
    public Product findById(String id) {
        return findAll().stream()
                .filter(p -> p.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Delete a product
    public void deleteById(String id) {
        List<Product> products = findAll();
        products.removeIf(p -> p.getId().equals(id));
        saveAll(products);
    }

    // Helper method to overwrite the file with the updated list
    private void saveAll(List<Product> products) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Product p : products) {
                // Polymorphism in action: Java calls the correct method based on the object type
                bw.write(p.toFileString());
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
