package com.inventory.sims.product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    @Autowired
    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    // 1. Show all products (URL: GET /products)
    @GetMapping
    public String viewProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "products/viewProducts";
    }

    // 2. Show the form to add a new product (URL: GET /products/add)
    @GetMapping("/add")
    public String showAddProductForm(Model model) {
        model.addAttribute("product", new Product());
        return "products/addProduct";
    }

    // 3. Handle the submission of the add product form (URL: POST /products/add)
    @PostMapping("/add")
    public String addProduct(
            @RequestParam String type,
            @RequestParam String id,
            @RequestParam String name,
            @RequestParam double price,
            @RequestParam int quantity,
            @RequestParam(required = true) String supplierId,
            @RequestParam(required = false, defaultValue = "0") int warrantyMonths,
            @RequestParam(required = false) String expirationDate) {
        Product product;
        if ("Electronics".equals(type)) {
            product = new ElectronicsProduct(id, name, price, quantity, supplierId, warrantyMonths);
        } else if ("Food".equals(type)) {
            product = new FoodProduct(id, name, price, quantity, supplierId, expirationDate);
        } else {
            product = new Product(id, name, price, quantity, supplierId);
        }
        productService.saveProduct(product);
        return "redirect:/products";
    }

    // 4. Show the form to edit an existing product (URL: GET /products/edit/{id})
    @GetMapping("/edit/{id}")
    public String showEditProductForm(@PathVariable String id, Model model) {
        Product product = productService.getProductById(id);
        if (product != null) {
            model.addAttribute("product", product);
            return "products/editProduct";
        }
        return "redirect:/products";
    }

    // 5. Handle the submission of the edit product form (URL: POST /products/edit/{id})
    @PostMapping("/edit/{id}")
    public String editProduct(
            @PathVariable String id,
            @RequestParam String type,
            @RequestParam String name,
            @RequestParam double price,
            @RequestParam int quantity,
            @RequestParam(required = true) String supplierId,
            @RequestParam(required = false, defaultValue = "0") int warrantyMonths,
            @RequestParam(required = false) String expirationDate) {
        Product product;
        if ("Electronics".equals(type)) {
            product = new ElectronicsProduct(id, name, price, quantity, supplierId, warrantyMonths);
        } else if ("Food".equals(type)) {
            product = new FoodProduct(id, name, price, quantity, supplierId, expirationDate);
        } else {
            product = new Product(id, name, price, quantity, supplierId);
        }
        productService.saveProduct(product);
        return "redirect:/products";
    }

    // 6. Handle the deletion of a product (URL: GET /products/delete/{id})
    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable String id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
}
