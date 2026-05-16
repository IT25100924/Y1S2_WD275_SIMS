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
public class StockInController {
    private final StockInService stockInService;
    private final ProductService productService;
    private final SupplierService supplierService;

    public StockInController(StockInService stockInService, ProductService productService,
                             SupplierService supplierService) {
        this.stockInService = stockInService;
        this.productService = productService;
        this.supplierService = supplierService;
    }

    @GetMapping("/stockin")
    public String showStockInPage(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("suppliers", supplierService.getAllSuppliers());
        model.addAttribute("today", LocalDate.now().toString());
        return "stockin/stockin";
    }

    @GetMapping("/stockin/view")
    public String viewStockInRecords(Model model) {
        model.addAttribute("stockIns", stockInService.getAllStockIns());
        return "stockin/viewStockIn";
    }

    @GetMapping("/stockin/edit/{id}")
    public String showEditStockInPage(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        StockIn stockIn = stockInService.getStockInById(id);
        if (stockIn == null) {
            redirectAttributes.addFlashAttribute("error", "Stock-in record was not found.");
            return "redirect:/stockin/view";
        }

        model.addAttribute("stockIn", stockIn);
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("suppliers", supplierService.getAllSuppliers());
        return "stockin/editStockIn";
    }

    @PostMapping("/stockin")
    public String addStockIn(@RequestParam String productId,
                             @RequestParam String supplierId,
                             @RequestParam int quantity,
                             @RequestParam double unitCost,
                             @RequestParam String receivedDate,
                             @RequestParam(required = false) String note,
                             RedirectAttributes redirectAttributes) {
        try {
            String supplierName = getSupplierName(supplierId);
            StockIn stockIn = stockInService.addStockIn(productId, supplierName, quantity, unitCost, receivedDate, note);
            redirectAttributes.addFlashAttribute("success",
                    "Stock in " + stockIn.getId() + " saved and product quantity updated.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/stockin";
    }

    @PostMapping("/stockin/edit/{id}")
    public String updateStockIn(@PathVariable String id,
                                @RequestParam String productId,
                                @RequestParam String supplierId,
                                @RequestParam int quantity,
                                @RequestParam double unitCost,
                                @RequestParam String receivedDate,
                                @RequestParam(required = false) String note,
                                RedirectAttributes redirectAttributes) {
        try {
            String supplierName = getSupplierName(supplierId);
            StockIn stockIn = stockInService.updateStockIn(id, productId, supplierName, quantity, unitCost, receivedDate, note);
            redirectAttributes.addFlashAttribute("success",
                    "Stock in " + stockIn.getId() + " updated and product quantity adjusted.");
            return "redirect:/stockin/view";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/stockin/edit/" + id;
        }
    }

    @PostMapping("/stockin/delete/{id}")
    public String deleteStockIn(@PathVariable String id, RedirectAttributes redirectAttributes) {
        try {
            StockIn stockIn = stockInService.deleteStockIn(id);
            redirectAttributes.addFlashAttribute("success",
                    "Stock in " + stockIn.getId() + " deleted and product quantity adjusted.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/stockin/view";
    }

    private String getSupplierName(String supplierId) {
        Supplier supplier = supplierService.findById(supplierId)
                .orElseThrow(() -> new IllegalArgumentException("Selected supplier was not found."));
        return supplier.getCompanyName();
    }
}
