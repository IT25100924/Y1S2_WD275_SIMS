package com.inventory.sims.supplier;

import com.inventory.sims.stockin.StockInService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class SupplierController {
    // SupplierService handles validation and file updates.
    private final SupplierService supplierService;
    // StockInService is only needed for the supplier details page.
    private final StockInService stockInService;

    // Constructor injection keeps the controller easy to test and understand.
    public SupplierController(SupplierService supplierService, StockInService stockInService) {
        this.supplierService = supplierService;
        this.stockInService = stockInService;
    }

    // Shows the supplier list, optional search results, and summary counts.
    @GetMapping("/suppliers")
    public String showSuppliers(@RequestParam(required = false) String keyword, Model model) {
        List<Supplier> suppliers = supplierService.searchSuppliers(keyword);
        model.addAttribute("suppliers", suppliers);
        model.addAttribute("keyword", keyword == null ? "" : keyword);
        model.addAttribute("totalSuppliers", suppliers.size());
        model.addAttribute("activeSuppliers", supplierService.countActiveSuppliers());
        model.addAttribute("pendingSuppliers", supplierService.countPendingSuppliers());
        return "supplier/suppliers";
    }

    // Shows one supplier and the stock-in records received from that supplier.
    @GetMapping("/suppliers/details/{id}")
    public String showSupplierDetails(@PathVariable("id") String supplierId, Model model, RedirectAttributes redirectAttributes) {
        Supplier supplier = supplierService.findById(supplierId).orElse(null);
        if (supplier == null) {
            redirectAttributes.addFlashAttribute("message", "Supplier not found.");
            return "redirect:/suppliers";
        }

        model.addAttribute("supplier", supplier);
        model.addAttribute("stockIns", stockInService.getStockInsBySupplierName(supplier.getCompanyName()));
        return "supplier/details";
    }

    // Opens the new-supplier form.
    @GetMapping("/suppliers/register")
    public String showRegisterPage() {
        return "supplier/register";
    }

    // Creates a supplier from form values.
    @PostMapping("/suppliers/register")
    public String register(@RequestParam String companyName,
                           @RequestParam String category,
                           @RequestParam String contactPerson,
                           @RequestParam String phone,
                           @RequestParam String email,
                           @RequestParam(required = false) String city,
                           @RequestParam(required = false) String leadTime,
                           @RequestParam(required = false) String address,
                           @RequestParam(required = false) String notes,
                           @RequestParam(defaultValue = "false") boolean active,
                           RedirectAttributes redirectAttributes) {
        try {
            supplierService.registerSupplier(companyName, category, contactPerson, phone, email, city, leadTime, address, notes, active);
            redirectAttributes.addFlashAttribute("message", "Supplier added successfully.");
            return "redirect:/suppliers/register";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/suppliers/register";
        }
    }

    // Opens the edit form for an existing supplier.
    @GetMapping("/suppliers/edit/{id}")
    public String showEditPage(@PathVariable("id") String supplierId, Model model, RedirectAttributes redirectAttributes) {
        Supplier supplier = supplierService.findById(supplierId).orElse(null);
        if (supplier == null) {
            redirectAttributes.addFlashAttribute("message", "Supplier not found.");
            return "redirect:/suppliers";
        }

        model.addAttribute("supplier", supplier);
        return "supplier/edit";
    }

    // Saves changed supplier details.
    @PostMapping("/suppliers/edit/{id}")
    public String update(@PathVariable("id") String supplierId,
                         @RequestParam String companyName,
                         @RequestParam String category,
                         @RequestParam String contactPerson,
                         @RequestParam String phone,
                         @RequestParam String email,
                         @RequestParam(required = false) String city,
                         @RequestParam(required = false) String leadTime,
                         @RequestParam(required = false) String address,
                         @RequestParam(required = false) String notes,
                         @RequestParam(defaultValue = "false") boolean active,
                         RedirectAttributes redirectAttributes) {
        try {
            supplierService.updateSupplier(supplierId, companyName, category, contactPerson, phone, email, city, leadTime, address, notes, active);
            redirectAttributes.addFlashAttribute("message", "Supplier updated successfully.");
            return "redirect:/suppliers";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/suppliers/edit/" + supplierId;
        }
    }

    // Deletes a supplier record from the text file.
    @PostMapping("/suppliers/delete/{id}")
    public String delete(@PathVariable("id") String supplierId, RedirectAttributes redirectAttributes) {
        try {
            supplierService.deleteSupplier(supplierId);
            redirectAttributes.addFlashAttribute("message", "Supplier deleted successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
        }

        return "redirect:/suppliers";
    }
}
