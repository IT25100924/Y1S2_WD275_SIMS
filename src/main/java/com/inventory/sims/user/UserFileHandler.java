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
    private static final Path USERS_FILE = Path.of("src/main/resources/data/users.txt");

    public List<User> readUsers() {
        ensureFile();

        List<User> users = new ArrayList<>();
        try {
            for (String line : Files.readAllLines(USERS_FILE, StandardCharsets.UTF_8)) {
                if (line == null || line.isBlank()) {
                    continue;
                }
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

    private void ensureFile() {
        try {
            Path parent = USERS_FILE.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
            if (Files.notExists(USERS_FILE)) {
                Files.createFile(USERS_FILE);
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to prepare users file", ex);
        }
    }
}
