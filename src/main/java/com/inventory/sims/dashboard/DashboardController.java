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
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.List;

@Controller
public class DashboardController {
    private static final int LOW_STOCK_THRESHOLD = 5;
    private static final int RECENT_ACTIVITY_LIMIT = 5;

    private static final Comparator<StockIn> RECENT_STOCK_IN_COMPARATOR = Comparator
            .comparing(DashboardController::parseStockInDate, Comparator.nullsLast(Comparator.reverseOrder()))
            .thenComparing(StockIn::getId, Comparator.nullsLast(Comparator.reverseOrder()));

    private static final Comparator<StockOut> RECENT_STOCK_OUT_COMPARATOR = Comparator
            .comparing(StockOut::getStockOutDate, Comparator.nullsLast(Comparator.reverseOrder()))
            .thenComparing(StockOut::getId, Comparator.nullsLast(Comparator.reverseOrder()));

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
        List<StockIn> stockIns = stockInService.getAllStockIns();
        List<StockOut> stockOuts = stockOutService.getAllStockOuts();
        YearMonth currentMonth = YearMonth.now();

        // 1. Total Products
        int totalProducts = productService.getAllProducts().size();
        
        // 2. Low Stock Alerts (Threshold 5)
        int lowStockCount = productService.getLowStockProducts(LOW_STOCK_THRESHOLD).size();

        // 3. Monthly Stock-in and Stock-out
        int monthlyStockIn = stockIns.stream()
                .filter(stockIn -> isInMonth(parseStockInDate(stockIn), currentMonth))
                .mapToInt(StockIn::getQuantity)
                .sum();

        int monthlyStockOut = stockOuts.stream()
                .filter(stockOut -> isInMonth(stockOut.getStockOutDate(), currentMonth))
                .mapToInt(StockOut::getQuantity)
                .sum();

        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("monthlyStockIn", monthlyStockIn);
        model.addAttribute("monthlyStockOut", monthlyStockOut);

        // Optional: Send recent stock movements (latest 5 each)
        List<StockOut> recentStockOut = stockOuts.stream()
                .sorted(RECENT_STOCK_OUT_COMPARATOR)
                .limit(RECENT_ACTIVITY_LIMIT)
                .toList();
        model.addAttribute("recentStockOut", recentStockOut);

        List<StockIn> recentStockIn = stockIns.stream()
                .sorted(RECENT_STOCK_IN_COMPARATOR)
                .limit(RECENT_ACTIVITY_LIMIT)
                .toList();
        model.addAttribute("recentStockIn", recentStockIn);

        return "dashboard";
    }

    private static boolean isInMonth(LocalDate date, YearMonth month) {
        return date != null && YearMonth.from(date).equals(month);
    }

    private static LocalDate parseStockInDate(StockIn stockIn) {
        if (stockIn == null) {
            return null;
        }

        String receivedDate = stockIn.getReceivedDate();
        if (receivedDate == null || receivedDate.isBlank()) {
            return null;
        }

        try {
            return LocalDate.parse(receivedDate.trim());
        } catch (DateTimeParseException ex) {
            return null;
        }
    }
}
