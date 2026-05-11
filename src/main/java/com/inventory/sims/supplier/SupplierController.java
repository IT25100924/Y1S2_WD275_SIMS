package com.inventory.sims.supplier;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class SupplierController {
    private final SupplierService supplierService;

    public SupplierController(SupplierService supplierService) {
        this.supplierService = supplierService;
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
}
