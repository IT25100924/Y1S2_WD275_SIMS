package com.inventory.sims.dashboard;

import com.inventory.sims.product.Product;
import com.inventory.sims.product.ProductService;
import com.inventory.sims.stockin.StockIn;
import com.inventory.sims.stockin.StockInService;
import com.inventory.sims.stockout.StockOut;
import com.inventory.sims.stockout.StockOutService;
import org.junit.jupiter.api.Test;
import org.springframework.ui.ConcurrentModel;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class DashboardControllerTest {

    @Test
    @SuppressWarnings("unchecked")
    void showDashboardCalculatesMonthlyTotalsAndRecentActivityByDate() {
        ProductService productService = mock(ProductService.class);
        StockInService stockInService = mock(StockInService.class);
        StockOutService stockOutService = mock(StockOutService.class);
        DashboardController controller = new DashboardController(productService, stockInService, stockOutService);

        YearMonth currentMonth = YearMonth.now();
        LocalDate currentMonthStart = currentMonth.atDay(1);
        LocalDate currentMonthSecondDay = currentMonth.atDay(2);
        LocalDate previousMonthStart = currentMonth.minusMonths(1).atDay(1);

        Product availableProduct = new Product("P001", "Keyboard", 2500, 12, "S001");
        Product lowStockProduct = new Product("P002", "Mouse", 1200, 3, "S001");
        when(productService.getAllProducts()).thenReturn(List.of(availableProduct, lowStockProduct));
        when(productService.getLowStockProducts(5)).thenReturn(List.of(lowStockProduct));

        StockIn earlierStockIn = stockIn("SI999", currentMonthStart.toString(), 3);
        StockIn latestStockIn = stockIn("SI001", currentMonthSecondDay.toString(), 7);
        StockIn previousStockIn = stockIn("SI998", previousMonthStart.toString(), 11);
        StockIn invalidDateStockIn = stockIn("SI997", "not-a-date", 13);
        when(stockInService.getAllStockIns()).thenReturn(
                List.of(earlierStockIn, invalidDateStockIn, latestStockIn, previousStockIn));

        StockOut earlierStockOut = stockOut("SO999", currentMonthStart, 2);
        StockOut latestStockOut = stockOut("SO001", currentMonthSecondDay, 4);
        StockOut previousStockOut = stockOut("SO998", previousMonthStart, 8);
        StockOut blankDateStockOut = stockOut("SO997", null, 16);
        when(stockOutService.getAllStockOuts()).thenReturn(
                List.of(earlierStockOut, blankDateStockOut, latestStockOut, previousStockOut));

        ConcurrentModel model = new ConcurrentModel();

        String viewName = controller.showDashboard(model);

        assertEquals("dashboard", viewName);
        assertEquals(2, model.getAttribute("totalProducts"));
        assertEquals(1, model.getAttribute("lowStockCount"));
        assertEquals(10, model.getAttribute("monthlyStockIn"));
        assertEquals(6, model.getAttribute("monthlyStockOut"));
        assertEquals(
                List.of(latestStockIn, earlierStockIn, previousStockIn, invalidDateStockIn),
                (List<StockIn>) model.getAttribute("recentStockIn"));
        assertEquals(
                List.of(latestStockOut, earlierStockOut, previousStockOut, blankDateStockOut),
                (List<StockOut>) model.getAttribute("recentStockOut"));
    }

    private StockIn stockIn(String id, String receivedDate, int quantity) {
        return new StockIn(id, "P001", "Keyboard", "Supplier", quantity, 100, receivedDate, "");
    }

    private StockOut stockOut(String id, LocalDate stockOutDate, int quantity) {
        return new StockOut(id, "P001", "Keyboard", quantity, 150, stockOutDate, "Customer", "Sale", "");
    }
}
