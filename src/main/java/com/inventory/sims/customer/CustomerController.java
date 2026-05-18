package com.inventory.sims.customer;

import com.inventory.sims.stockout.StockOutService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

// Handles all browser requests related to customer pages.
@Controller
public class CustomerController {
    // CustomerService contains the main customer business logic.
    private final CustomerService customerService;

    // StockOutService is used only for showing a customer's stock-out history.
    private final StockOutService stockOutService;

    // Spring injects the required services through this constructor.
    public CustomerController(CustomerService customerService, StockOutService stockOutService) {
        this.customerService = customerService;
        this.stockOutService = stockOutService;
    }

    // Show the page that lists all customers.
    @GetMapping("/customers")
    public String viewCustomers(Model model) {
        model.addAttribute("customers", customerService.getAllCustomers());
        return "customer/viewCustomers";
    }

    // Show the add customer form.
    @GetMapping("/customers/add")
    public String showAddCustomerForm() {
        return "customer/addCustomer";
    }

    // Show full customer details and related stock-out records.
    @GetMapping("/customers/details/{id}")
    public String showCustomerDetails(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        Customer customer = customerService.getCustomerById(id);
        if (customer == null) {
            redirectAttributes.addFlashAttribute("error", "Customer not found.");
            return "redirect:/customers";
        }
        model.addAttribute("customer", customer);
        model.addAttribute("stockOutRecords", stockOutService.getStockOutsByCustomer(customer));
        return "customer/details";
    }

    // Show the edit form for one selected customer.
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

    // Save edited customer details.
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

    // Delete one customer and return to the customer list.
    @PostMapping("/customers/delete/{id}")
    public String deleteCustomer(@PathVariable String id, RedirectAttributes redirectAttributes) {
        try {
            customerService.deleteCustomer(id);
            redirectAttributes.addFlashAttribute("message", "Customer " + id + " deleted successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/customers";
    }

    // Create a new customer from the add form.
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
