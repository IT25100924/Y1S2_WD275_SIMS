package com.inventory.sims.config;

import com.inventory.sims.user.User;
import com.inventory.sims.user.UserType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    // These are the two important redirect targets used by the authentication flow.
    private static final String LOGIN_PATH = "/users/login";
    private static final String DASHBOARD_PATH = "/dashboard";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // Read the logged-in user from the current session.
        // If there is no session yet, request.getSession(false) returns null.
        HttpSession session = request.getSession(false);
        Object loggedUser = session == null ? null : session.getAttribute("loggedUser");

        // No loggedUser means the visitor has not logged in, so send them to login.
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PATH);
            return false;
        }

        // Staff users are logged in, but they are not allowed to open user-management pages.
        if (isUserManagementPath(request) && !isAdmin(loggedUser)) {
            response.sendRedirect(request.getContextPath() + DASHBOARD_PATH);
            return false;
        }

        // Returning true allows Spring MVC to continue to the requested controller method.
        return true;
    }

    private boolean isUserManagementPath(HttpServletRequest request) {
        // Remove the context path so the check works even if the app is deployed under a prefix.
        String path = request.getRequestURI().substring(request.getContextPath().length());
        // /users/logout must stay available to both ADMIN and STAFF.
        return path.startsWith("/users") && !path.equals("/users/logout");
    }

    private boolean isAdmin(Object loggedUser) {
        // Normal case: login stores the full User object in session.
        if (loggedUser instanceof User user) {
            return user.getRole() == UserType.ADMIN;
        }

        // These extra cases make the check safe if the session stores only a role later.
        if (loggedUser instanceof UserType role) {
            return role == UserType.ADMIN;
        }

        if (loggedUser instanceof String role) {
            return UserType.ADMIN.name().equalsIgnoreCase(role);
        }

        return false;
    }
}
