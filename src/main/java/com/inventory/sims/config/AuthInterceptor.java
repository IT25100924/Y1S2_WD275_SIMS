package com.inventory.sims.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {
    private static final String LOGIN_PATH = "/users/login";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestPath = request.getRequestURI();
        boolean loggedIn = request.getSession(false) != null
                && request.getSession(false).getAttribute("loggedUser") != null;

        if (LOGIN_PATH.equals(requestPath)) {
            if (loggedIn) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return false;
            }
            return true;
        }

        if (loggedIn) {
            return true;
        }

        response.sendRedirect(request.getContextPath() + LOGIN_PATH);
        return false;
    }
}
