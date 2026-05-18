package com.inventory.sims.user;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpServletRequest;
import com.inventory.sims.user.User;

import java.util.List;

@Controller
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/users/login")
    public String showLoginPage(HttpServletRequest request) {
        if (request.getSession(false) != null && request.getSession(false).getAttribute("loggedUser") != null) {
            return "redirect:/dashboard";
        }
        return "users/login";
    }

    @PostMapping("/users/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpServletRequest request,
                        RedirectAttributes redirectAttributes) {
        java.util.Optional<User> optUser = userService.findByEmail(email);
        
        if (optUser.isPresent() && optUser.get().getPassword().equals(password)) {
            if (!optUser.get().isActive()) {
                redirectAttributes.addFlashAttribute("error", "Your account has been deactivated. Please contact an admin.");
                return "redirect:/users/login";
            }
            // Store user info in session for later use
            request.getSession().setAttribute("loggedUser", optUser.get());
            return "redirect:/dashboard";
        }

        redirectAttributes.addFlashAttribute("error", "Invalid email or password.");
        return "redirect:/users/login";
    }

    @PostMapping("/users/toggle-status/{id}")
    public String toggleStatus(@PathVariable("id") String userId, RedirectAttributes redirectAttributes) {
        try {
            userService.toggleStaffStatus(userId);
            redirectAttributes.addFlashAttribute("message", "User status updated successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/users/details/" + userId;
    }

    @GetMapping("/users/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return "redirect:/users/login";
    }

    @GetMapping("/users/register")
    public String showRegisterPage(Model model) {
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
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("message", "Passwords do not match.");
            return "redirect:/users/register";
        }

        try {
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
        List<User> users = userService.getUsersForView();
        List<User> filteredUsers = userService.searchUsers(users, keyword);

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
        return userService.findById(userId)
                .map(user -> {
                    model.addAttribute("user", user);
                    return "users/viewUser";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("message", "User not found.");
                    return "redirect:/users";
                });
    }

    @GetMapping("/users/edit/{id}")
    public String showEditPage(@PathVariable("id") String userId, Model model, RedirectAttributes redirectAttributes) {
        return userService.findById(userId)
                .map(user -> {
                    model.addAttribute("user", user);
                    model.addAttribute("roles", UserType.values());
                    return "users/edit";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("message", "User not found.");
                    return "redirect:/users";
                });
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
            userService.deleteUser(userId);
            redirectAttributes.addFlashAttribute("message", "User deleted successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
        }

        return "redirect:/users";
    }
}
