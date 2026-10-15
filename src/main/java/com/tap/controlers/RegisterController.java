
package com.tap.controlers;

import java.io.IOException;

import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDaoImpl userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        String contextPath = request.getContextPath();

        // Check for missing fields
        if (isBlank(username) || isBlank(email)
                || isBlank(password) || isBlank(confirmPassword)
                || isBlank(phone) || isBlank(address)) {

            response.sendRedirect(contextPath + "/register.jsp?error=1");
            return;
        }

        username = username.trim();
        email = email.trim().toLowerCase();
        phone = phone.trim();
        address = address.trim();

        // Validate password confirmation
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(contextPath + "/register.jsp?error=1");
            return;
        }

        // Validate basic input requirements on the server
        if (username.length() < 2 || username.length() > 100
                || email.length() > 254
                || password.length() < 8
                || !phone.matches("[0-9]{10}")
                || address.length() > 500) {

            response.sendRedirect(contextPath + "/register.jsp?error=1");
            return;
        }

        try {
            // Check whether this email is already registered
            User existingUser = userDao.getUserByEmail(email);

            if (existingUser != null) { 
                response.sendRedirect(
                    contextPath + "/register.jsp?error=email"
                );
                return;
            }

            String hashedPassword = org.mindrot.jbcrypt.BCrypt.hashpw(
                    password,
                    org.mindrot.jbcrypt.BCrypt.gensalt(12)
            );

            User newUser = new User(
                    username, hashedPassword, email, phone, address, "CUSTOMER"
            );

            userDao.addUser(newUser);

            // Registration successful; user can now log in
            response.sendRedirect(
                contextPath + "/login.jsp?message=registered"
            );

        } catch (RuntimeException e) {
            log("Registration failed.", e);
            response.sendRedirect(contextPath + "/register.jsp?error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
