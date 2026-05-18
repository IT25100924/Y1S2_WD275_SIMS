package com.inventory.sims.config;

import com.inventory.sims.user.User;
import com.inventory.sims.user.UserType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    private static final String LOGIN_PATH = "/users/login";
    private static final String DASHBOARD_PATH = "/dashboard";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Object loggedUser = request.getSession(false) == null
                ? null
                : request.getSession(false).getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PATH);
            return false;
        }

        if (isUserManagementPath(request) && !isAdmin(loggedUser)) {
            response.sendRedirect(request.getContextPath() + DASHBOARD_PATH);
            return false;
        }

        return true;
    }

    private boolean isUserManagementPath(HttpServletRequest request) {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        return path.startsWith("/users") && !path.equals("/users/logout");
    }

    private boolean isAdmin(Object loggedUser) {
        if (loggedUser instanceof User user) {
            return user.getRole() == UserType.ADMIN;
        }

        if (loggedUser instanceof UserType role) {
            return role == UserType.ADMIN;
        }

        if (loggedUser instanceof String role) {
            return UserType.ADMIN.name().equalsIgnoreCase(role);
        }

        return false;
    }
}
