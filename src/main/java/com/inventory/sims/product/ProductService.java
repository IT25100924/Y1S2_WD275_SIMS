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
        return productRepository.findById(id);
    }

    // Save a new product or update an existing one
    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    // Delete a product
    public void deleteProduct(String id) {
        productRepository.deleteById(id);
    }
}
