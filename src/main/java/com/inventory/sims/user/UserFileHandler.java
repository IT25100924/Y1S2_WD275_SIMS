package com.inventory.sims.user;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

@Component
public class UserFileHandler {
    // This project stores user data in a text file instead of a database.
    // Each line in users.txt represents one user.
    private static final Path USERS_FILE = Path.of("src/main/resources/data/users.txt");

    public List<User> readUsers() {
        // Always make sure the file exists before trying to read from it.
        ensureFile();

        List<User> users = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(USERS_FILE, StandardCharsets.UTF_8)) {
                // Skip empty lines so they do not create invalid users.
                if (line == null || line.isBlank()) {
                    continue;
                }
                // Convert one text-file line into a User object.
                User user = User.fromFileLine(line);
                if (user != null) {
                    users.add(user);
                }
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to read users file", ex);
        }
        return users;
    }

    public void saveUser(User user) {
        // Used when registering a new user. It appends one new line to the file.
        ensureFile();

        try {
            Files.writeString(
                    USERS_FILE,
                    user.toFileLine() + System.lineSeparator(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to save user", ex);
        }
    }

    public void saveAllUsers(List<User> users) {
        // Used when updating, deleting, or toggling status.
        // Those actions modify existing records, so the whole file is rewritten.
        ensureFile();

        StringBuilder content = new StringBuilder();
        for (User user : users) {
            content.append(user.toFileLine()).append(System.lineSeparator());
        }

        try {
            Files.writeString(
                    USERS_FILE,
                    content.toString(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.TRUNCATE_EXISTING);
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to update users", ex);
        }
    }

    private void ensureFile() {
        try {
            // Create the data folder if it is missing.
            Path parent = USERS_FILE.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
            // Create users.txt if it has not been created yet.
            if (Files.notExists(USERS_FILE)) {
                Files.createFile(USERS_FILE);
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to prepare users file", ex);
        }
    }
}
