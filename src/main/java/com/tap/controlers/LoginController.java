
package com.tap.controlers;

import java.io.IOException;

import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDaoImpl userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String contextPath = request.getContextPath();

        // Check whether the required fields are provided.
        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            response.sendRedirect(
                    contextPath + "/login.jsp?error=1");
            return;
        }

        email = email.trim().toLowerCase();

        // Find the user using the email address.
        User user = userDao.getUserByEmail(email);

        // Check whether the account exists.
        if (user == null || user.getPassword() == null) {
            response.sendRedirect(
                    contextPath + "/login.jsp?error=1");
            return;
        }

        String storedPassword = user.getPassword();
        boolean passwordMatches = false;

        // Verify a BCrypt-hashed password.
        if (storedPassword.startsWith("$2a$")
                || storedPassword.startsWith("$2b$")
                || storedPassword.startsWith("$2y$")) {

            try {
                passwordMatches =
                        BCrypt.checkpw(password, storedPassword);
            } catch (IllegalArgumentException e) {
                passwordMatches = false;
            }

        } else {
            // Temporary compatibility for older plain-text accounts.
            // Remove this fallback after migrating legacy accounts.
            passwordMatches = storedPassword.equals(password);
        }

        // Reject invalid passwords.
        if (!passwordMatches) {
            response.sendRedirect(
                    contextPath + "/login.jsp?error=1");
            return;
        }

        // Create a session after successful login.
        HttpSession session = request.getSession(true);

        // Prevent session fixation.
        request.changeSessionId();

        session.setAttribute("loggedInUser", user);

        // Redirect to the restaurants page.
        response.sendRedirect(contextPath + "/restaurants");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp");
    }
}
