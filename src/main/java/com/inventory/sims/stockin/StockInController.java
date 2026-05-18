package com.inventory.sims.stockin;

import com.inventory.sims.product.ProductService;
import com.inventory.sims.supplier.Supplier;
import com.inventory.sims.supplier.SupplierService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
// MVC controller for Stock In pages.
// It prepares page data, receives form submissions, and delegates rules to StockInService.
public class StockInController {
    // Services used by the Stock In screens and dropdown lists.
    private final StockInService stockInService;
    private final ProductService productService;
    private final SupplierService supplierService;

    // Constructor injection makes all dependencies explicit.
    public StockInController(StockInService stockInService, ProductService productService,
                             SupplierService supplierService) {
        this.stockInService = stockInService;
        this.productService = productService;
        this.supplierService = supplierService;
    }

    // Shows the Stock In list page.
    @GetMapping("/stockin")
    public String viewStockInRecords(Model model) {
        model.addAttribute("stockIns", stockInService.getAllStockIns());
        return "stockin/viewStockIn";
    }

    // Shows the create form with product/supplier dropdowns and today's date.
    @GetMapping("/stockin/create")
    public String showStockInPage(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("suppliers", supplierService.getAllSuppliers());
        model.addAttribute("today", LocalDate.now().toString());
        return "stockin/stockin";
    }

    // Shows details for one stock-in record, or redirects if the ID is invalid.
    @GetMapping("/stockin/details/{id}")
    public String showStockInDetails(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        StockIn stockIn = stockInService.getStockInById(id);
        if (stockIn == null) {
            redirectAttributes.addFlashAttribute("error", "Stock-in record was not found.");
            return "redirect:/stockin";
        }

        model.addAttribute("stockIn", stockIn);
        return "stockin/details";
    }

    // Shows the edit form with the current record and dropdown values.
    @GetMapping("/stockin/edit/{id}")
    public String showEditStockInPage(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        StockIn stockIn = stockInService.getStockInById(id);
        if (stockIn == null) {
            redirectAttributes.addFlashAttribute("error", "Stock-in record was not found.");
            return "redirect:/stockin";
        }

        model.addAttribute("stockIn", stockIn);
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("suppliers", supplierService.getAllSuppliers());
        model.addAttribute("today", LocalDate.now().toString());
        return "stockin/editStockIn";
    }

    // Creates a new stock-in record and increases product quantity.
    @PostMapping("/stockin/create")
    public String addStockIn(@RequestParam String productId,
                             @RequestParam String supplierId,
                             @RequestParam int quantity,
                             @RequestParam double unitCost,
                             @RequestParam String receivedDate,
                             @RequestParam(required = false) String expirationDate,
                             @RequestParam(required = false) String warrantyMonths,
                             @RequestParam(required = false) String note,
                             RedirectAttributes redirectAttributes) {
        try {
            String supplierName = getSupplierName(supplierId);
            StockIn stockIn = stockInService.addStockIn(productId, supplierName, quantity, unitCost,
                    receivedDate, expirationDate, warrantyMonths, note);
            redirectAttributes.addFlashAttribute("success",
                    "Stock in " + stockIn.getId() + " saved and product quantity updated.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/stockin/create";
        }
        return "redirect:/stockin";
    }

    // Updates an existing stock-in record and adjusts affected product quantities.
    @PostMapping("/stockin/edit/{id}")
    public String updateStockIn(@PathVariable String id,
                                @RequestParam String productId,
                                @RequestParam String supplierId,
                                @RequestParam int quantity,
                                @RequestParam double unitCost,
                                @RequestParam String receivedDate,
                                @RequestParam(required = false) String expirationDate,
                                @RequestParam(required = false) String warrantyMonths,
                                @RequestParam(required = false) String note,
                                RedirectAttributes redirectAttributes) {
        try {
            String supplierName = getSupplierName(supplierId);
            StockIn stockIn = stockInService.updateStockIn(id, productId, supplierName, quantity, unitCost,
                    receivedDate, expirationDate, warrantyMonths, note);
            redirectAttributes.addFlashAttribute("success",
                    "Stock in " + stockIn.getId() + " updated and product quantity adjusted.");
            return "redirect:/stockin";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/stockin/edit/" + id;
        }
    }

    // Deletes a stock-in record and subtracts its quantity from the product.
    @PostMapping("/stockin/delete/{id}")
    public String deleteStockIn(@PathVariable String id, RedirectAttributes redirectAttributes) {
        try {
            StockIn stockIn = stockInService.deleteStockIn(id);
            redirectAttributes.addFlashAttribute("success",
                    "Stock in " + stockIn.getId() + " deleted and product quantity adjusted.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/stockin";
    }

    // Converts the selected supplier ID from the form into the supplier company name stored in stockin.txt.
    private String getSupplierName(String supplierId) {
        Supplier supplier = supplierService.findById(supplierId)
                .orElseThrow(() -> new IllegalArgumentException("Selected supplier was not found."));
        return supplier.getCompanyName();
    }
}
