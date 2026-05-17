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
                String[] data = line.split(DELIMITER);

                // Our format now has at least 6 parts: Type!ID!SupplierID!Name!Price!Quantity
                if (data.length >= 6) {
                    String type = data[0];
                    String id = data[1];
                    String supplierId = data[2]; // New Field!
                    String name = data[3];
                    double price = Double.parseDouble(data[4]);
                    int quantity = Integer.parseInt(data[5]);

                    Product product = null;

                    // Check the type and instantiate the correct subclass with supplierId
                    if ("Electronics".equals(type) && data.length == 7) {
                        int warrantyMonths = Integer.parseInt(data[6]);
                        product = new ElectronicsProduct(id, name, price, quantity, supplierId, warrantyMonths);
                    } else if ("Food".equals(type) && data.length == 7) {
                        String expirationDate = data[6];
                        product = new FoodProduct(id, name, price, quantity, supplierId, expirationDate);
                    } else if ("General".equals(type)) {
                        product = new Product(id, name, price, quantity, supplierId);
                    }

                    if (product != null) {
                        products.add(product);
                    }
                }
            }
        } catch (IOException | NumberFormatException e) {
            e.printStackTrace();
        }
        return products;
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
