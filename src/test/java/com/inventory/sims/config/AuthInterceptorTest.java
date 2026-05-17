package com.inventory.sims.config;

import com.inventory.sims.user.User;
import com.inventory.sims.user.UserType;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AuthInterceptorTest {
    private final AuthInterceptor authInterceptor = new AuthInterceptor();

    @Test
    void redirectsDashboardToLoginWhenUserIsNotLoggedIn() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/dashboard");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = authInterceptor.preHandle(request, response, new Object());

        assertFalse(allowed);
        assertEquals("/users/login", response.getRedirectedUrl());
    }

    @Test
    void allowsProtectedPageWhenUserIsLoggedIn() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/dashboard");
        request.getSession().setAttribute("loggedUser", loggedUser());
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = authInterceptor.preHandle(request, response, new Object());

        assertTrue(allowed);
    }

    @Test
    void redirectsLoginToDashboardWhenUserIsAlreadyLoggedIn() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/users/login");
        request.getSession().setAttribute("loggedUser", loggedUser());
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = authInterceptor.preHandle(request, response, new Object());

        assertFalse(allowed);
        assertEquals("/dashboard", response.getRedirectedUrl());
    }

    private User loggedUser() {
        return new User("U001", "Dovin", "Anjuna", "dovinanjuna@sims.com", "0712345678",
                UserType.ADMIN, "Dovin123", true);
    }
}
