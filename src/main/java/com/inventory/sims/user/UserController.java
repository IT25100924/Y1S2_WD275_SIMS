package com.inventory.sims.user;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.List;
import java.util.Optional;

@Controller
public class UserController {
    // The controller does not handle business logic directly.
    // It receives web requests, calls UserService, then returns a JSP page or redirect.
    private final UserService userService;

    // Spring injects UserService here through constructor injection.
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/users/login")
    public String showLoginPage(HttpServletRequest request) {
        // If a user is already logged in, avoid showing login again.
        if (hasLoggedUser(request)) {
            return "redirect:/dashboard";
        }
        return "users/login";
    }

    @PostMapping("/users/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpServletRequest request,
                        RedirectAttributes redirectAttributes) {
        // Find the account by email, then compare the submitted password.
        Optional<User> optUser = userService.findByEmail(email);
        
        if (optUser.isPresent() && optUser.get().getPassword().equals(password)) {
            // Inactive accounts cannot enter the system even with the correct password.
            if (!optUser.get().isActive()) {
                redirectAttributes.addFlashAttribute("error", "Your account has been deactivated. Please contact an admin.");
                return "redirect:/users/login";
            }

            // Store the logged-in user in the session.
            // Other pages and interceptors use this to know who is currently logged in.
            request.getSession().setAttribute("loggedUser", optUser.get());
            return "redirect:/dashboard";
        }

        // Flash attributes survive one redirect, so the login JSP can show this message.
        redirectAttributes.addFlashAttribute("error", "Invalid email or password.");
        return "redirect:/users/login";
    }

    @PostMapping("/users/toggle-status/{id}")
    public String toggleStatus(@PathVariable("id") String userId, RedirectAttributes redirectAttributes) {
        try {
            // Used by admin to activate/deactivate staff accounts.
            userService.toggleStaffStatus(userId);
            redirectAttributes.addFlashAttribute("message", "User status updated successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/users/details/" + userId;
    }

    @GetMapping("/users/logout")
    public String logout(HttpServletRequest request) {
        // Invalidating the session removes loggedUser and logs the user out.
        request.getSession().invalidate();
        return "redirect:/users/login";
    }

    @GetMapping("/users/register")
    public String showRegisterPage(Model model) {
        // Send ADMIN and STAFF enum values to the JSP role dropdown.
        model.addAttribute("roles", UserType.values());
        return "users/register";
    }

    @PostMapping("/users/register")
    public String register(@RequestParam String firstName,
                           @RequestParam String lastName,
                           @RequestParam String email,
                           @RequestParam(required = false) String phone,
                           @RequestParam UserType role,
                           @RequestParam String password,
                           @RequestParam String confirmPassword,
                           @RequestParam(defaultValue = "false") boolean active,
                           RedirectAttributes redirectAttributes) {
        // Controller handles form-specific validation before calling the service.
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("message", "Passwords do not match.");
            return "redirect:/users/register";
        }

        try {
            // Service performs the main validation, ID generation, and file saving.
            userService.registerUser(firstName, lastName, email, phone, role, password, active);
            redirectAttributes.addFlashAttribute("message", "User registered successfully. Please log in.");
            return "redirect:/users/login";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/users/register";
        }
    }

    @GetMapping("/users")
    public String showUsers(@RequestParam(required = false) String keyword, Model model) {
        // Load all users, then apply optional keyword filtering for the list page.
        List<User> users = userService.getUsersForView();
        List<User> filteredUsers = userService.searchUsers(users, keyword);

        // These model values are used by users.jsp to render table data and summary cards.
        model.addAttribute("users", filteredUsers);
        model.addAttribute("keyword", keyword == null ? "" : keyword.trim());
        model.addAttribute("totalUsers", users.size());
        model.addAttribute("adminUsers", users.stream().filter(user -> user.getRole() == UserType.ADMIN).count());
        model.addAttribute("staffUsers", users.stream().filter(user -> user.getRole() == UserType.STAFF).count());
        model.addAttribute("activeUsers", users.stream().filter(User::isActive).count());
        model.addAttribute("filteredUsers", filteredUsers.size());
        return "users/users";
    }

    @GetMapping("/users/details/{id}")
    public String showUserDetails(@PathVariable("id") String userId, Model model, RedirectAttributes redirectAttributes) {
        // Optional lets us handle both cases: user found or user missing.
        Optional<User> user = userService.findById(userId);
        if (user.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
            return "redirect:/users";
        }

        model.addAttribute("user", user.get());
        return "users/viewUser";
    }

    @GetMapping("/users/edit/{id}")
    public String showEditPage(@PathVariable("id") String userId, Model model, RedirectAttributes redirectAttributes) {
        // Load the existing user so the edit form can be pre-filled.
        Optional<User> user = userService.findById(userId);
        if (user.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
            return "redirect:/users";
        }

        model.addAttribute("user", user.get());
        model.addAttribute("roles", UserType.values());
        return "users/edit";
    }

    @PostMapping("/users/edit/{id}")
    public String update(@PathVariable("id") String userId,
                         @RequestParam String firstName,
                         @RequestParam String lastName,
                         @RequestParam String email,
                         @RequestParam(required = false) String phone,
                         @RequestParam UserType role,
                         @RequestParam(required = false) String password,
                         @RequestParam(required = false) String confirmPassword,
                         @RequestParam(defaultValue = "false") boolean active,
                         RedirectAttributes redirectAttributes) {
        try {
            // Password is optional during edit. If it is blank, service keeps the old password.
            userService.updateUser(userId, firstName, lastName, email, phone, role, password, confirmPassword, active);
            redirectAttributes.addFlashAttribute("message", "User updated successfully.");
            return "redirect:/users";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/users/edit/" + userId;
        }
    }

    @PostMapping("/users/delete/{id}")
    public String delete(@PathVariable("id") String userId, RedirectAttributes redirectAttributes) {
        try {
            // Delete rewrites the users file without the selected user.
            userService.deleteUser(userId);
            redirectAttributes.addFlashAttribute("message", "User deleted successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
        }

        return "redirect:/users";
    }

    private boolean hasLoggedUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("loggedUser") != null;
    }
}
