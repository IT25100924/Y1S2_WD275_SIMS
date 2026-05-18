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
    // UserService contains the business rules for the user module.
    // It uses UserFileHandler for actual file reading and writing.
    private final UserFileHandler userFileHandler;

    public UserService(UserFileHandler userFileHandler) {
        this.userFileHandler = userFileHandler;
    }

    public User registerUser(String firstName, String lastName, String email, String phone, UserType role, String password, boolean active) {
        // Basic required-field validation before creating an account.
        validateRequired(firstName, "First name");
        validateRequired(lastName, "Last name");
        validateRequired(email, "Email");
        validateRole(role);
        validatePassword(password);

        // Store emails in lowercase so duplicate checks and login matching are consistent.
        String normalizedEmail = normalizeEmail(email);
        if (emailExists(normalizedEmail)) {
            throw new IllegalArgumentException("A user with this email already exists.");
        }

        // Create the correct subclass, generate a new ID, then append it to users.txt.
        User user = createUser(nextUserId(), firstName.trim(), lastName.trim(), normalizedEmail, safeTrim(phone), role, password, active);
        userFileHandler.saveUser(user);
        return user;
    }

    public boolean authenticate(String email, String password) {
        // This method checks login credentials without returning the user object.
        if (email == null || password == null) {
            return false;
        }

        return findByEmail(email)
                .filter(User::isActive)
                .map(user -> password.equals(user.getPassword()))
                .orElse(false);
    }

    public List<User> getAllUsers() {
        // Direct read used when another part of the system needs every user.
        return userFileHandler.readUsers();
    }

    public Optional<User> findById(String userId) {
        // Optional.empty() means caller can handle "not found" without null checks.
        if (userId == null || userId.isBlank()) {
            return Optional.empty();
        }

        return userFileHandler.readUsers().stream()
                .filter(user -> userId.equalsIgnoreCase(user.getId()))
                .findFirst();
    }

    public Optional<User> findByEmail(String email) {
        // Login uses email lookup, so email is normalized before comparing.
        if (email == null || email.isBlank()) return Optional.empty();
        String normalizedEmail = normalizeEmail(email);
        return userFileHandler.readUsers().stream()
                .filter(u -> normalizedEmail.equalsIgnoreCase(u.getEmail()))
                .findFirst();
    }

    public void toggleStaffStatus(String userId) {
        // Admin accounts are protected from being deactivated through this action.
        validateRequired(userId, "User ID");
        List<User> users = new ArrayList<>(userFileHandler.readUsers());

        int index = findUserIndex(users, userId);
        if (index == -1) {
            throw new IllegalArgumentException("User not found.");
        }

        User existing = users.get(index);
        if (existing.getRole() == UserType.ADMIN) {
            throw new IllegalArgumentException("Cannot toggle active status of ADMIN users.");
        }

        // User objects are recreated here so the updated role-specific subclass is preserved.
        User updatedUser = createUser(
                existing.getId(),
                existing.getFirstName(),
                existing.getLastName(),
                existing.getEmail(),
                existing.getPhone(),
                existing.getRole(),
                existing.getPassword(),
                !existing.isActive());

        users.set(index, updatedUser);
        // Because this changes an existing line, rewrite the whole file.
        userFileHandler.saveAllUsers(users);
    }

    public List<User> getUsersForView() {
        // Newer generated IDs should appear first in the users table.
        return userFileHandler.readUsers().stream()
                .sorted(Comparator
                        .comparing(User::getId, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER.reversed()))
                        .thenComparing(User::getEmail, Comparator.nullsLast(String::compareToIgnoreCase)))
                .toList();
    }

    public List<User> searchUsers(String keyword) {
        // Convenience method: search over the normal sorted user list.
        return searchUsers(getUsersForView(), keyword);
    }

    public List<User> searchUsers(List<User> users, String keyword) {
        // Blank search returns the original list.
        if (keyword == null || keyword.isBlank()) {
            return users;
        }

        // Search checks the main visible fields in the Users table.
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
        // Null-safe, case-insensitive contains check used by searchUsers().
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
        // Validate the fields that must always exist after an update.
        validateRequired(userId, "User ID");
        validateRequired(firstName, "First name");
        validateRequired(lastName, "Last name");
        validateRequired(email, "Email");
        validateRole(role);

        List<User> users = new ArrayList<>(userFileHandler.readUsers());
        int existingIndex = findUserIndex(users, userId);
        if (existingIndex == -1) {
            throw new IllegalArgumentException("User not found.");
        }
        User existing = users.get(existingIndex);

        // Email must remain unique, but the current user's own email is allowed.
        String normalizedEmail = normalizeEmail(email);
        if (emailExistsForAnotherUser(users, normalizedEmail, existing.getId())) {
            throw new IllegalArgumentException("A user with this email already exists.");
        }

        // If password field is blank, keep the previous password.
        String updatedPassword = existing.getPassword();
        if (password != null && !password.isBlank()) {
            if (!password.equals(confirmPassword)) {
                throw new IllegalArgumentException("Passwords do not match.");
            }
            validatePassword(password);
            updatedPassword = password;
        }

        // Recreate user with updated values and same ID.
        User updatedUser = createUser(
                existing.getId(),
                firstName.trim(),
                lastName.trim(),
                normalizedEmail,
                safeTrim(phone),
                role,
                updatedPassword,
                active);

        // Replace the old user object in the list, then rewrite users.txt.
        users.set(existingIndex, updatedUser);

        userFileHandler.saveAllUsers(users);
        return updatedUser;
    }

    public void deleteUser(String userId) {
        // Delete by ID from the in-memory list first.
        validateRequired(userId, "User ID");

        List<User> users = new ArrayList<>(userFileHandler.readUsers());
        boolean removed = users.removeIf(user -> userId.equalsIgnoreCase(user.getId()));

        if (!removed) {
            throw new IllegalArgumentException("User not found.");
        }

        // Save the remaining users back to the file.
        userFileHandler.saveAllUsers(users);
    }

    private User createUser(String id, String firstName, String lastName, String email, String phone, UserType role, String password, boolean active) {
        // Factory method: creates the right subclass based on the selected role.
        if (role == UserType.ADMIN) {
            return new AdminUser(id, firstName, lastName, email, phone, password, active);
        }
        return new StaffUser(id, firstName, lastName, email, phone, password, active);
    }

    private boolean emailExists(String email) {
        // Used during registration to prevent duplicate user accounts.
        return userFileHandler.readUsers().stream()
                .anyMatch(user -> email.equalsIgnoreCase(user.getEmail()));
    }

    private boolean emailExistsForAnotherUser(List<User> users, String email, String currentUserId) {
        // Used during edit to prevent duplicate email while allowing the user's current email.
        return users.stream()
                .anyMatch(user -> !user.getId().equalsIgnoreCase(currentUserId)
                        && email.equalsIgnoreCase(user.getEmail()));
    }

    private int findUserIndex(List<User> users, String userId) {
        // Returns the position of a user in a list, or -1 when not found.
        for (int i = 0; i < users.size(); i++) {
            if (userId.equalsIgnoreCase(users.get(i).getId())) {
                return i;
            }
        }
        return -1;
    }

    private String nextUserId() {
        // Finds the highest existing U-number and adds 1.
        // Example: U004 becomes U005.
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
        // Shared required-field validation for cleaner service methods.
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
    }

    private void validatePassword(String password) {
        // New or changed passwords must exist and have a minimum length.
        validateRequired(password, "Password");
        if (password.length() < 6) {
            throw new IllegalArgumentException("Password must contain at least 6 characters.");
        }
    }

    private void validateRole(UserType role) {
        // Role is required because it controls access level in the system.
        if (role == null) {
            throw new IllegalArgumentException("User role is required.");
        }
    }

    private String safeTrim(String value) {
        // Converts null phone numbers or optional strings into a safe empty value.
        return Objects.requireNonNullElse(value, "").trim();
    }

    private String normalizeEmail(String email) {
        // One place for email cleanup so register, edit, and login match the same way.
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
