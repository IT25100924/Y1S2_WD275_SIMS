package com.inventory.sims.stockout;

import org.springframework.stereotype.Controller;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
public class StockOutController {
    private final StockOutService stockOutService;

    public StockOutController(StockOutService stockOutService) {
        this.stockOutService = stockOutService;
    }

    @GetMapping("/stockout")
    public String viewStockOutRecords(Model model) {
        model.addAttribute("stockOutRecords", stockOutService.getAllStockOuts());
        return "stockout/view";
    }

    @GetMapping("/stockout/create")
    public String showCreateStockOutPage() {
        return "stockout/create";
    }

    @PostMapping("/stockout/create")
    public String createStockOut(@RequestParam String productId,
                                 @RequestParam String productName,
                                 @RequestParam int quantity,
                                 @RequestParam(required = false)
                                 @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate stockOutDate,
                                 @RequestParam String issuedTo,
                                 @RequestParam String reason,
                                 @RequestParam(required = false) String note,
                                 RedirectAttributes redirectAttributes) {
        try {
            stockOutService.createStockOut(productId, productName, quantity, stockOutDate, issuedTo, reason, note);
            redirectAttributes.addFlashAttribute("message", "Stockout record created successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
        }

        return "redirect:/stockout/create";
    }
}
