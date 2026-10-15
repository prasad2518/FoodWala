
package com.tap.controlers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        logoutUser(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        logoutUser(request, response);
    }

    private void logoutUser(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        // Get the existing session without creating a new one.
        HttpSession session = request.getSession(false);

        // Invalidate the session and remove its attributes.
        if (session != null) {
            session.invalidate();
        }

        // Prevent the browser from showing cached private pages.
        response.setHeader(
                "Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Redirect to the Foodwala home page.
        response.sendRedirect(
                request.getContextPath() + "/restaurants");
    }
}