package com.inventory.sims.customer;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class CustomerController {
    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    @GetMapping("/customers")
    public String viewCustomers(Model model) {
        model.addAttribute("customers", customerService.getAllCustomers());
        return "customer/viewCustomers";
    }

    @GetMapping("/customers/add")
    public String showAddCustomerForm() {
        return "customer/addCustomer";
    }

    @GetMapping("/customers/edit/{id}")
    public String showEditCustomerForm(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        Customer customer = customerService.getCustomerById(id);
        if (customer == null) {
            redirectAttributes.addFlashAttribute("error", "Customer not found.");
            return "redirect:/customers";
        }
        model.addAttribute("customer", customer);
        return "customer/editCustomer";
    }

    @PostMapping("/customers/edit/{id}")
    public String updateCustomer(@PathVariable String id,
                                 @RequestParam String name,
                                 @RequestParam String email,
                                 @RequestParam String phone,
                                 @RequestParam(required = false) String address,
                                 RedirectAttributes redirectAttributes) {
        try {
            Customer customer = customerService.updateCustomer(id, name, email, phone, address);
            redirectAttributes.addFlashAttribute("message", "Customer " + customer.getId() + " updated successfully.");
            return "redirect:/customers";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/customers/edit/" + id;
        }
    }

    @PostMapping("/customers/add")
    public String addCustomer(@RequestParam String name,
                              @RequestParam String email,
                              @RequestParam String phone,
                              @RequestParam(required = false) String address,
                              RedirectAttributes redirectAttributes) {
        try {
            Customer customer = customerService.addCustomer(name, email, phone, address);
            redirectAttributes.addFlashAttribute("message", "Customer " + customer.getId() + " added successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/customers/add";
    }
}
