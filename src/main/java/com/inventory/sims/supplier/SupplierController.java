package com.inventory.sims.supplier;

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
    private final SupplierService supplierService;

    public SupplierController(SupplierService supplierService) {
        this.supplierService = supplierService;
    }

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

    @GetMapping("/suppliers/details/{id}")
    public String showSupplierDetails(@PathVariable("id") String supplierId, Model model, RedirectAttributes redirectAttributes) {
        return supplierService.findById(supplierId)
                .map(supplier -> {
                    model.addAttribute("supplier", supplier);
                    return "supplier/details";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("message", "Supplier not found.");
                    return "redirect:/suppliers";
                });
    }

    @GetMapping("/suppliers/register")
    public String showRegisterPage() {
        return "supplier/register";
    }

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

    @GetMapping("/suppliers/edit/{id}")
    public String showEditPage(@PathVariable("id") String supplierId, Model model, RedirectAttributes redirectAttributes) {
        return supplierService.findById(supplierId)
                .map(supplier -> {
                    model.addAttribute("supplier", supplier);
                    return "supplier/edit";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("message", "Supplier not found.");
                    return "redirect:/suppliers";
                });
    }

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
}
