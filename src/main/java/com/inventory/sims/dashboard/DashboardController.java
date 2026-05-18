package com.inventory.sims.dashboard;

import com.inventory.sims.product.ProductService;
import com.inventory.sims.stockin.StockIn;
import com.inventory.sims.stockin.StockInService;
import com.inventory.sims.stockout.StockOut;
import com.inventory.sims.stockout.StockOutService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class DashboardController {

    private final ProductService productService;
    private final StockInService stockInService;
    private final StockOutService stockOutService;

    @Autowired
    public DashboardController(ProductService productService, StockInService stockInService, StockOutService stockOutService) {
        this.productService = productService;
        this.stockInService = stockInService;
        this.stockOutService = stockOutService;
    }

    @GetMapping({"/", "/dashboard"})
    public String showDashboard(Model model) {
        // 1. Total Products
        int totalProducts = productService.getAllProducts().size();

        // 2. Low Stock Alerts (Threshold 5)
        int lowStockCount = productService.getLowStockProducts(5).size();

        // 3. Monthly Stock-in and Stock-out
        String currentMonthYear = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));

        int monthlyStockIn = stockInService.getAllStockIns().stream()
                .filter(si -> si.getReceivedDate() != null && si.getReceivedDate().startsWith(currentMonthYear))
                .mapToInt(StockIn::getQuantity)
                .sum();

        int monthlyStockOut = stockOutService.getAllStockOuts().stream()
                .filter(so -> so.getStockOutDate() != null && so.getStockOutDate().toString().startsWith(currentMonthYear))
                .mapToInt(StockOut::getQuantity)
                .sum();

        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("monthlyStockIn", monthlyStockIn);
        model.addAttribute("monthlyStockOut", monthlyStockOut);

        // Optional: Send recent stock movements (latest 5 each)
        List<StockOut> recentStockOut = stockOutService.getAllStockOuts().stream()
                .sorted(Comparator.comparing(
                        StockOut::getId,
                        Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed())))
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("recentStockOut", recentStockOut);

        List<StockIn> recentStockIn = stockInService.getAllStockIns().stream()
                .sorted(Comparator.comparing(
                        StockIn::getId,
                        Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed())))
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("recentStockIn", recentStockIn);

        return "dashboard";
    }
}

