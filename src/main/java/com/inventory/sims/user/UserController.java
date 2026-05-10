package com.inventory.sims.user;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Locale;

@Controller
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping({"/", "/users/login"})
    public String showLoginPage() {
        return "users/login";
    }

    @PostMapping("/users/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        RedirectAttributes redirectAttributes) {
        if (userService.authenticate(email, password)) {
            return "redirect:/dashboard";
        }

        redirectAttributes.addFlashAttribute("error", "Invalid email or password.");
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
        List<User> users = userService.getAllUsers();
        List<User> filteredUsers = filterUsers(users, keyword);

        model.addAttribute("users", filteredUsers);
        model.addAttribute("keyword", keyword == null ? "" : keyword.trim());
        model.addAttribute("totalUsers", users.size());
        model.addAttribute("adminUsers", users.stream().filter(user -> user.getRole() == UserType.ADMIN).count());
        model.addAttribute("staffUsers", users.stream().filter(user -> user.getRole() == UserType.STAFF).count());
        model.addAttribute("activeUsers", users.stream().filter(User::isActive).count());
        model.addAttribute("filteredUsers", filteredUsers.size());
        return "users/users";
    }

    private List<User> filterUsers(List<User> users, String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return users;
        }

        String search = keyword.trim().toLowerCase(Locale.ROOT);
        return users.stream()
                .filter(user -> contains(user.getId(), search)
                        || contains(user.getFirstName(), search)
                        || contains(user.getLastName(), search)
                        || contains(user.getEmail(), search)
                        || contains(user.getPhone(), search)
                        || contains(user.getRole() == null ? "" : user.getRole().name(), search))
                .toList();
    }

    private boolean contains(String value, String search) {
        return value != null && value.toLowerCase(Locale.ROOT).contains(search);
    }
}
