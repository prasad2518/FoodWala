
package com.tap.controlers;

import java.io.IOException;
import java.util.List;

import com.tap.model.CartItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Step 1: Check login
        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Step 2: Get logged-in user
        User user = (User) session.getAttribute("loggedInUser");

        // Pass saved address to checkout.jsp
        request.setAttribute("userAddress", user.getAddress());

        // Step 3: Check cart
        @SuppressWarnings("unchecked")
        List<CartItem> cart =
            (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(
                request.getContextPath() + "/cart.jsp"
            );
            return;
        }

        // Step 4: Calculate subtotal
        double subtotal = 0.0;

        for (CartItem item : cart) {
            subtotal += item.getTotalPrice();
        }

        // Step 5: Calculate delivery fee and total
        double deliveryFee = 40.0;
        double grandTotal = subtotal + deliveryFee;

        // Step 6: Pass totals to checkout.jsp
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("grandTotal", grandTotal);

        // Step 7: Display checkout page
        request.getRequestDispatcher("/checkout.jsp")
               .forward(request, response);
    }
}
