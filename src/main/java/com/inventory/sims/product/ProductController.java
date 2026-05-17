package com.inventory.sims.product;

import com.inventory.sims.stockin.StockInService;
import com.inventory.sims.stockout.StockOutService;
import com.inventory.sims.supplier.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;
    private final SupplierService supplierService;
    private final StockInService stockInService;
    private final StockOutService stockOutService;

    @Autowired
    public ProductController(ProductService productService, SupplierService supplierService,
                             StockInService stockInService, StockOutService stockOutService) {
        this.productService = productService;
        this.supplierService = supplierService;
        this.stockInService = stockInService;
        this.stockOutService = stockOutService;
    }

    // 1. Show all products (URL: GET /products)
    @GetMapping
    public String viewProducts(Model model) {
        List<Product> products = productService.getAllProducts();
        model.addAttribute("products", products);

        // Calculate stats for the new UI Cards
        long totalProducts = products.size();
        long electronicsCount = products.stream().filter(p -> p instanceof ElectronicsProduct).count();
        long foodCount = products.stream().filter(p -> p instanceof FoodProduct).count();
        long lowStockCount = products.stream().filter(p -> p.getQuantity() <= 5).count();

        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("electronicsCount", electronicsCount);
        model.addAttribute("foodCount", foodCount);
        model.addAttribute("lowStockCount", lowStockCount);

        return "products/viewProducts";
    }

    // 2. Show the form to add a new product (URL: GET /products/add)
    @GetMapping("/add")
    public String showAddProductForm(Model model) {
        model.addAttribute("product", new Product());
        // Pass the auto-generated ID and the list of suppliers!
        model.addAttribute("nextId", productService.generateNextProductId());
        model.addAttribute("suppliers", supplierService.getAllSuppliers());
        return "products/addProduct";
    }

    // 3. Handle the submission of the add product form with error catching (URL: POST /products/add)
    @PostMapping("/add")
    public String addProduct(
            @RequestParam String type,
            @RequestParam String id,
            @RequestParam String name,
            @RequestParam String supplierId,
            @RequestParam(required = false) String configurePrices,
            @RequestParam(required = false, defaultValue = "0") double mrp,
            @RequestParam(required = false, defaultValue = "0") double defaultStockInPrice,
            @RequestParam(required = false, defaultValue = "0") double defaultStockOutPrice,
            @RequestParam(required = false) String initializeStock,
            @RequestParam(required = false, defaultValue = "0") int quantity,
            @RequestParam(required = false, defaultValue = "0") int warrantyMonths,
            @RequestParam(required = false) String expirationDate,
            Model model) {

        // Override optional prices to 0 if the configurePrices checkbox wasn't checked
        if (configurePrices == null) {
            defaultStockInPrice = 0;
            defaultStockOutPrice = 0;
        }

        // Set initial quantity to 0 if initialization checkbox wasn't checked
        int initialQuantity = 0;
        if (initializeStock != null) {
            initialQuantity = quantity;
        }

        Product product;
        if ("Electronics".equals(type)) {
            product = new ElectronicsProduct(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, 0, supplierId, warrantyMonths);
        } else if ("Food".equals(type)) {
            product = new FoodProduct(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, 0, supplierId, expirationDate);
        } else {
            product = new Product(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, 0, supplierId);
        }

        try {
            productService.saveProduct(product);

            // Cross-Module Sync for Initial Stock-In
            if (initializeStock != null && initialQuantity > 0) {
                com.inventory.sims.supplier.Supplier supplier = supplierService.findById(supplierId).orElse(null);
                String supplierName = supplier != null ? supplier.getCompanyName() : supplierId;
                
                stockInService.addStockIn(
                        id, 
                        supplierName, 
                        initialQuantity, 
                        defaultStockInPrice, 
                        java.time.LocalDate.now().toString(), 
                        expirationDate != null ? expirationDate : "", 
                        String.valueOf(warrantyMonths), 
                        "Initial stock initialization"
                );
            }

            return "redirect:/products";
        } catch (IllegalArgumentException e) {
            // Validation failed! Pass data back to the UI.
            model.addAttribute("product", product);
            model.addAttribute("nextId", id);
            model.addAttribute("suppliers", supplierService.getAllSuppliers());
            model.addAttribute("errorMessage", e.getMessage());
            return "products/addProduct";
        }
    }

    // 4. Show the form to edit an existing product (URL: GET /products/edit/{id})
    @GetMapping("/edit/{id}")
    public String showEditProductForm(@PathVariable String id, Model model) {
        Product product = productService.getProductById(id);
        if (product != null) {
            model.addAttribute("product", product);
            model.addAttribute("suppliers", supplierService.getAllSuppliers());
            return "products/editProduct";
        }
        return "redirect:/products";
    }

    // Show detailed view of a product (URL: GET /products/details/{id})
    @GetMapping("/details/{id}")
    public String showProductDetails(@PathVariable String id, Model model) {
        Product product = productService.getProductById(id);
        if (product != null) {
            model.addAttribute("product", product);

            // Fetch and attach the supplier details
            supplierService.findById(product.getSupplierId())
                    .ifPresent(supplier -> model.addAttribute("supplier", supplier));

            // Fetch and attach stock history
            model.addAttribute("stockIns", stockInService.getStockInsByProductId(id));
            model.addAttribute("stockOuts", stockOutService.getStockOutsByProductId(id));

            return "products/details";
        }
        return "redirect:/products";
    }

    // 5. Handle the submission of the edit product form (URL: POST /products/edit/{id})
    @PostMapping("/edit/{id}")
    public String editProduct(
            @PathVariable String id,
            @RequestParam String type,
            @RequestParam String name,
            @RequestParam(required = false, defaultValue = "0") double mrp,
            @RequestParam(required = false, defaultValue = "0") double defaultStockInPrice,
            @RequestParam(required = false, defaultValue = "0") double defaultStockOutPrice,
            @RequestParam(required = true) String supplierId,
            @RequestParam(required = false, defaultValue = "0") int warrantyMonths,
            @RequestParam(required = false) String expirationDate,
            Model model) {

        // Fetch existing product to preserve its current stock quantity!
        Product existingProduct = productService.getProductById(id);
        int currentQuantity = (existingProduct != null) ? existingProduct.getQuantity() : 0;

        Product product;
        if ("Electronics".equals(type)) {
            product = new ElectronicsProduct(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, currentQuantity, supplierId, warrantyMonths);
        } else if ("Food".equals(type)) {
            product = new FoodProduct(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, currentQuantity, supplierId, expirationDate);
        } else {
            product = new Product(id, name, mrp, defaultStockInPrice, defaultStockOutPrice, currentQuantity, supplierId);
        }

        try {
            productService.saveProduct(product);
            return "redirect:/products";
        } catch (IllegalArgumentException e) {
            model.addAttribute("product", product);
            model.addAttribute("suppliers", supplierService.getAllSuppliers());
            model.addAttribute("errorMessage", e.getMessage());
            return "products/editProduct";
        }
    }

    // 6. Handle the deletion of a product (URL: POST /products/delete/{id})
    @PostMapping("/delete/{id}")
    public String deleteProduct(@PathVariable String id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
}
