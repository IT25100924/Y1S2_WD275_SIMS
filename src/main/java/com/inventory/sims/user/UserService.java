package com.inventory.sims.user;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;

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
        validateRole(role);

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

    public Optional<User> findById(String userId) {
        if (userId == null || userId.isBlank()) {
            return Optional.empty();
        }

        return userFileHandler.readUsers().stream()
                .filter(user -> userId.equalsIgnoreCase(user.getId()))
                .findFirst();
    }

    public Optional<User> findByEmail(String email) {
        if (email == null || email.isBlank()) return Optional.empty();
        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        return userFileHandler.readUsers().stream()
                .filter(u -> normalizedEmail.equalsIgnoreCase(u.getEmail()))
                .findFirst();
    }

    public void toggleStaffStatus(String userId) {
        validateRequired(userId, "User ID");
        List<User> users = new ArrayList<>(userFileHandler.readUsers());
        
        for (int i = 0; i < users.size(); i++) {
            User existing = users.get(i);
            if (userId.equalsIgnoreCase(existing.getId())) {
                if (existing.getRole() == UserType.ADMIN) {
                    throw new IllegalArgumentException("Cannot toggle active status of ADMIN users.");
                }
                
                User updatedUser = createUser(
                        existing.getId(),
                        existing.getFirstName(),
                        existing.getLastName(),
                        existing.getEmail(),
                        existing.getPhone(),
                        existing.getRole(),
                        existing.getPassword(),
                        !existing.isActive());
                        
                users.set(i, updatedUser);
                userFileHandler.saveAllUsers(users);
                return;
            }
        }
        throw new IllegalArgumentException("User not found.");
    }

    public List<User> getUsersForView() {
        return userFileHandler.readUsers().stream()
                .sorted(Comparator
                        .comparing(User::getId, Comparator.nullsLast(String::compareToIgnoreCase))
                        .thenComparing(User::getEmail, Comparator.nullsLast(String::compareToIgnoreCase)))
                .toList();
    }

    public List<User> searchUsers(String keyword) {
        return searchUsers(getUsersForView(), keyword);
    }

    public List<User> searchUsers(List<User> users, String keyword) {
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

    public User updateUser(String userId,
                           String firstName,
                           String lastName,
                           String email,
                           String phone,
                           UserType role,
                           String password,
                           String confirmPassword,
                           boolean active) {
        validateRequired(userId, "User ID");
        validateRequired(firstName, "First name");
        validateRequired(lastName, "Last name");
        validateRequired(email, "Email");
        validateRole(role);

        List<User> users = new ArrayList<>(userFileHandler.readUsers());
        User existing = users.stream()
                .filter(user -> userId.equalsIgnoreCase(user.getId()))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("User not found."));

        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        boolean duplicateEmail = users.stream()
                .anyMatch(user -> !user.getId().equalsIgnoreCase(existing.getId())
                        && normalizedEmail.equalsIgnoreCase(user.getEmail()));
        if (duplicateEmail) {
            throw new IllegalArgumentException("A user with this email already exists.");
        }

        String updatedPassword = existing.getPassword();
        if (password != null && !password.isBlank()) {
            if (!password.equals(confirmPassword)) {
                throw new IllegalArgumentException("Passwords do not match.");
            }
            if (password.length() < 6) {
                throw new IllegalArgumentException("Password must contain at least 6 characters.");
            }
            updatedPassword = password;
        }

        User updatedUser = createUser(
                existing.getId(),
                firstName.trim(),
                lastName.trim(),
                normalizedEmail,
                safeTrim(phone),
                role,
                updatedPassword,
                active);

        for (int i = 0; i < users.size(); i++) {
            if (existing.getId().equalsIgnoreCase(users.get(i).getId())) {
                users.set(i, updatedUser);
                break;
            }
        }

        userFileHandler.saveAllUsers(users);
        return updatedUser;
    }

    public void deleteUser(String userId) {
        validateRequired(userId, "User ID");

        List<User> users = new ArrayList<>(userFileHandler.readUsers());
        boolean removed = users.removeIf(user -> userId.equalsIgnoreCase(user.getId()));

        if (!removed) {
            throw new IllegalArgumentException("User not found.");
        }

        userFileHandler.saveAllUsers(users);
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

    private void validateRole(UserType role) {
        if (role == null) {
            throw new IllegalArgumentException("User role is required.");
        }
    }

    private String safeTrim(String value) {
        return Objects.requireNonNullElse(value, "").trim();
    }
}
