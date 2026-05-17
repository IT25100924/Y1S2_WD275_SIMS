package com.inventory.sims.product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.stream.Collectors;

import java.util.List;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    // Get all products
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    // Get a single product by ID
    public Product getProductById(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        return productRepository.findById(id);
    }

    // Save a new product or update an existing one
    public void saveProduct(Product product) {
        // 1. Standard Validations
        if (product.getPrice() < 0) {
            throw new IllegalArgumentException("Unit Price cannot be negative.");
        }
        if (product.getQuantity() < 0) {
            throw new IllegalArgumentException("Initial Quantity cannot be negative.");
        }
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be empty.");
        }

        // 2. Unique name validation (ignore case)
        boolean nameExists = getAllProducts().stream()
                .anyMatch(p -> p.getName().equalsIgnoreCase(product.getName().trim())
                        && !p.getId().equals(product.getId()));
        if (nameExists) {
            throw new IllegalArgumentException("A product with this name already exists.");
        }

        product.setName(product.getName().trim());
        productRepository.save(product);
    }

    // Delete a product
    public void deleteProduct(String id) {
        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("Cannot delete: ID is empty.");
        }
        productRepository.deleteById(id);
    }

    // --- INTEGRATION METHODS FOR OTHER MODULES ---

    // 1. For the Stock-In / Stock-Out
    // Safely updates the quantity of a product.
    // Pass a positive number (Stock-In) or negative number (Stock-Out).
    public boolean updateStock(String id, int quantityChange) {
        Product product = getProductById(id);
        if (product == null) {
            return false;
        }

        int newQuantity = product.getQuantity() + quantityChange;
        if (newQuantity < 0) {
            throw new IllegalArgumentException("Insufficient stock! Cannot reduce quantity below zero.");
        }

        product.setQuantity(newQuantity);
        productRepository.save(product);
        return true;
    }

    // 2. For the Dashboard (Alerts)
    // Returns all products where the stock is at or below the given threshold.
    public List<Product> getLowStockProducts(int threshold) {
        return getAllProducts().stream()
                .filter(p -> p.getQuantity() <= threshold)
                .collect(Collectors.toList());
    }

    // 3. For the Dashboard (Alerts)
    // Filters only FoodProducts and checks if they expire within 'daysThreshold'.
    public List<FoodProduct> getExpiringFoodProducts(int daysThreshold) {
        LocalDate today = LocalDate.now();

        return getAllProducts().stream()
                .filter(p -> p instanceof FoodProduct)
                .map(p -> (FoodProduct) p)
                .filter(fp -> {
                    try {
                        if (fp.getExpirationDate() == null || fp.getExpirationDate().isEmpty()) return false;
                        LocalDate expDate = LocalDate.parse(fp.getExpirationDate());
                        long daysUntilExpiry = ChronoUnit.DAYS.between(today, expDate);

                        // Return true if it expires between today (0) and the threshold
                        return daysUntilExpiry >= 0 && daysUntilExpiry <= daysThreshold;
                    } catch (Exception e) {
                        return false; // Ignore parsing errors if they typed a bad date
                    }
                })
                .collect(Collectors.toList());
    }

    // Auto-generate the next Product ID (e.g., P001 -> P002)
    public String generateNextProductId() {
        int max = 0;
        for (Product product : getAllProducts()) {
            String id = product.getId();
            if (id != null && id.startsWith("P")) {
                try {
                    max = Math.max(max, Integer.parseInt(id.substring(1)));
                } catch (NumberFormatException ignored) { }
            }
        }
        return String.format("P%03d", max + 1);
    }

}
