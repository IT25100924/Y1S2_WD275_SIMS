package com.inventory.sims.stockin;

import com.inventory.sims.product.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
public class StockInController {
    private final StockInService stockInService;
    private final ProductService productService;

    public StockInController(StockInService stockInService, ProductService productService) {
        this.stockInService = stockInService;
        this.productService = productService;
    }

    @GetMapping("/stockin")
    public String showStockInPage(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("today", LocalDate.now().toString());
        return "stockin/stockin";
    }

    @GetMapping("/stockin/view")
    public String viewStockInRecords(Model model) {
        model.addAttribute("stockIns", stockInService.getAllStockIns());
        return "stockin/viewStockIn";
    }

    @PostMapping("/stockin")
    public String addStockIn(@RequestParam String productId,
                             @RequestParam String supplierName,
                             @RequestParam int quantity,
                             @RequestParam double unitCost,
                             @RequestParam String receivedDate,
                             @RequestParam(required = false) String note,
                             RedirectAttributes redirectAttributes) {
        try {
            StockIn stockIn = stockInService.addStockIn(productId, supplierName, quantity, unitCost, receivedDate, note);
            redirectAttributes.addFlashAttribute("success",
                    "Stock in " + stockIn.getId() + " saved and product quantity updated.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/stockin";
    }
}
