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
public class StockOutController {
    private final StockOutService stockOutService;
    private final ProductService productService;
    private final CustomerService customerService;

    public StockOutController(StockOutService stockOutService, ProductService productService,
                              CustomerService customerService) {
        this.stockOutService = stockOutService;
        this.productService = productService;
        this.customerService = customerService;
    }

    @GetMapping("/stockout")
    public String viewStockOutRecords(Model model) {
        model.addAttribute("stockOutRecords", stockOutService.getAllStockOuts());
        return "stockout/view";
    }

    @GetMapping("/stockout/create")
    public String showCreateStockOutPage(Model model) {
        addFormLists(model);
        return "stockout/create";
    }

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

    private void addFormLists(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("customers", customerService.getAllCustomers());
        model.addAttribute("today", LocalDate.now().toString());
    }

    private Customer getSelectedCustomer(String customerId) {
        Customer customer = customerService.getCustomerById(customerId);
        if (customer == null) {
            throw new IllegalArgumentException("Selected customer was not found.");
        }
        return customer;
    }
}
