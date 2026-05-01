package com.inventory.sims.product;

import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ProductRepository {

    private static final String FILE_PATH = "products.txt";
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
                if (data.length == 4) {
                    Product product = new Product(
                            data[0],                     // id
                            data[1],                     // name
                            Double.parseDouble(data[2]), // price
                            Integer.parseInt(data[3])    // quantity
                    );
                    products.add(product);
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
                bw.write(p.getId() + DELIMITER +
                        p.getName() + DELIMITER +
                        p.getPrice() + DELIMITER +
                        p.getQuantity());
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
