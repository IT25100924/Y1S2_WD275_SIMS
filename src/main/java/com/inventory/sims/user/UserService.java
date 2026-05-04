package com.inventory.sims.user;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;

@Service
public class UserService {
    private final UserFileHandler userFileHandler;

    public UserService(UserFileHandler userFileHandler) {
        this.userFileHandler = userFileHandler;
    }

    public User registerUser(String firstName, String lastName, String email, String phone, UserType role, String password, boolean active) {
        validateRequired(firstName, "First name");
        validateRequired(lastName, "Last name");
        validateRequired(email, "Email");
        validateRequired(password, "Password");

        if (password.length() < 6) {
            throw new IllegalArgumentException("Password must contain at least 6 characters.");
        }

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        if (emailExists(normalizedEmail)) {
            throw new IllegalArgumentException("A user with this email already exists.");
        }

        User user = createUser(nextUserId(), firstName.trim(), lastName.trim(), normalizedEmail, safeTrim(phone), role, password, active);
        userFileHandler.saveUser(user);
        return user;
    }

    public boolean authenticate(String email, String password) {
        if (email == null || password == null) {
            return false;
        }

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        return userFileHandler.readUsers().stream()
                .anyMatch(user -> user.isActive()
                        && normalizedEmail.equalsIgnoreCase(user.getEmail())
                        && password.equals(user.getPassword()));
    }

    public List<User> getAllUsers() {
        return userFileHandler.readUsers();
    }

    private User createUser(String id, String firstName, String lastName, String email, String phone, UserType role, String password, boolean active) {
        if (role == UserType.ADMIN) {
            return new AdminUser(id, firstName, lastName, email, phone, password, active);
        }
        return new StaffUser(id, firstName, lastName, email, phone, password, active);
    }

    private boolean emailExists(String email) {
        return userFileHandler.readUsers().stream()
                .anyMatch(user -> email.equalsIgnoreCase(user.getEmail()));
    }

    private String nextUserId() {
        int max = 0;
        for (User user : userFileHandler.readUsers()) {
            String id = user.getId();
            if (id != null && id.startsWith("U")) {
                try {
                    max = Math.max(max, Integer.parseInt(id.substring(1)));
                } catch (NumberFormatException ignored) {
                    // Ignore malformed old records and keep generating from valid IDs.
                }
            }
        }
        return String.format("U%03d", max + 1);
    }

    private void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
