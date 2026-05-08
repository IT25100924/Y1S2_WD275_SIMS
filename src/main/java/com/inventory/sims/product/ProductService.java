package com.inventory.sims.product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    public Product saveProduct(Product product) {
        if (product == null) {
            throw new IllegalArgumentException("Cannot save a null product.");
        }
        if (product.getId() == null || product.getId().trim().isEmpty()) {
            throw new IllegalArgumentException("Product ID cannot be empty.");
        }
        if (product.getPrice() < 0) {
            throw new IllegalArgumentException("Product price cannot be negative.");
        }
        if (product.getQuantity() < 0) {
            throw new IllegalArgumentException("Product quantity cannot be negative.");
        }
        return productRepository.save(product);
    }

    // Delete a product
    public void deleteProduct(String id) {
        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("Cannot delete: ID is empty.");
        }
        productRepository.deleteById(id);
    }
}
