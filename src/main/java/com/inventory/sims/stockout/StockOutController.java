package com.inventory.sims.stockout;

import com.inventory.sims.customer.Customer;
import com.inventory.sims.customer.CustomerService;
import com.inventory.sims.product.Product;
import com.inventory.sims.product.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
// Handles browser requests for the Stock-out module.
// Business rules stay in StockOutService; this class only prepares request/response data.
public class StockOutController {
    // Services needed to create records and fill product/customer dropdowns.
    private final StockOutService stockOutService;
    private final ProductService productService;
    private final CustomerService customerService;

    // Constructor injection lets Spring provide the required services.
    public StockOutController(StockOutService stockOutService, ProductService productService,
                              CustomerService customerService) {
        this.stockOutService = stockOutService;
        this.productService = productService;
        this.customerService = customerService;
    }

    // Shows all saved stock-out records.
    @GetMapping("/stockout")
    public String viewStockOutRecords(Model model) {
        model.addAttribute("stockOutRecords", stockOutService.getAllStockOuts());
        return "stockout/view";
    }

    // Opens the create form with product/customer dropdown data.
    @GetMapping("/stockout/create")
    public String showCreateStockOutPage(Model model) {
        addFormLists(model);
        return "stockout/create";
    }

    // Shows one stock-out record with its related product details.
    @GetMapping("/stockout/details/{id}")
    public String showStockOutDetails(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        StockOut stockOut = stockOutService.getStockOutById(id);
        if (stockOut == null) {
            redirectAttributes.addFlashAttribute("message", "Stockout record not found.");
            return "redirect:/stockout";
        }

        Product product = productService.getProductById(stockOut.getProductId());
        model.addAttribute("stockOut", stockOut);
        model.addAttribute("product", product);
        return "stockout/details";
    }

    // Receives the create form and asks the service to save a new stock-out record.
    @PostMapping("/stockout/create")
    public String createStockOut(@RequestParam String productId,
                                 @RequestParam int quantity,
                                 @RequestParam double unitPrice,
                                 @RequestParam(required = false)
                                 @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate stockOutDate,
                                 @RequestParam String issuedTo,
                                 @RequestParam String reason,
                                 @RequestParam(required = false) String note,
                                 RedirectAttributes redirectAttributes) {
        try {
            Customer customer = getSelectedCustomer(issuedTo);
            stockOutService.createStockOut(productId, quantity, unitPrice, stockOutDate, customer.getName(), reason, note);
            redirectAttributes.addFlashAttribute("message", "Stockout record created successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/stockout/create";
        }

        return "redirect:/stockout";
    }

    // Opens the update form for an existing stock-out record.
    @GetMapping("/stockout/update/{id}")
    public String showUpdateStockOutPage(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        StockOut stockOut = stockOutService.getStockOutById(id);
        if (stockOut == null) {
            redirectAttributes.addFlashAttribute("message", "Stockout record not found.");
            return "redirect:/stockout";
        }

        model.addAttribute("stockOut", stockOut);
        addFormLists(model);
        return "stockout/update";
    }

    // Receives the update form and asks the service to rewrite the selected record.
    @PostMapping("/stockout/update/{id}")
    public String updateStockOut(@PathVariable String id,
                                 @RequestParam String productId,
                                 @RequestParam int quantity,
                                 @RequestParam double unitPrice,
                                 @RequestParam(required = false)
                                 @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate stockOutDate,
                                 @RequestParam String issuedTo,
                                 @RequestParam String reason,
                                 @RequestParam(required = false) String note,
                                 RedirectAttributes redirectAttributes) {
        try {
            Customer customer = getSelectedCustomer(issuedTo);
            stockOutService.updateStockOut(id, productId, quantity, unitPrice, stockOutDate, customer.getName(), reason, note);
            redirectAttributes.addFlashAttribute("message", "Stockout record updated successfully.");
            return "redirect:/stockout";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/stockout/update/" + id;
        }
    }

    // Deletes one stock-out record by ID.
    @PostMapping("/stockout/delete/{id}")
    public String deleteStockOut(@PathVariable String id, RedirectAttributes redirectAttributes) {
        try {
            stockOutService.deleteStockOut(id);
            redirectAttributes.addFlashAttribute("message", "Stockout record deleted successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
        }

        return "redirect:/stockout";
    }

    // Shared dropdown/date data used by both create and update forms.
    private void addFormLists(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("customers", customerService.getAllCustomers());
        model.addAttribute("today", LocalDate.now().toString());
    }

    // The form sends a customer ID; stock-out records save the customer name for display.
    private Customer getSelectedCustomer(String customerId) {
        Customer customer = customerService.getCustomerById(customerId);
        if (customer == null) {
            throw new IllegalArgumentException("Selected customer was not found.");
        }
        return customer;
    }
}
