
package com.tap.controlers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;

import com.tap.model.CartItem;
import com.tap.model.User;
import com.tap.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/place-order")
public class PlaceOrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final double DELIVERY_FEE = 40.0;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String contextPath = request.getContextPath();

        HttpSession session = request.getSession(false);

        // 1. Check login.
        if (session == null
                || session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        // 2. Get cart.
        @SuppressWarnings("unchecked")
        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(contextPath + "/cart.jsp");
            return;
        }

        // 3. Read checkout form fields.
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMode = request.getParameter("paymentMode");

        if (customerName == null || customerName.trim().isEmpty()
                || phone == null
                || !phone.trim().matches("[0-9]{10}")
                || address == null || address.trim().isEmpty()
                || address.trim().length() > 500
                || !"COD".equals(paymentMode)) {

            response.sendRedirect(
                    contextPath + "/checkout?error=details");
            return;
        }

        customerName = customerName.trim();
        phone = phone.trim();
        address = address.trim();

        // 4. Calculate subtotal using server-side menu prices.
        double subtotal = 0.0;

        for (CartItem item : cart) {

            if (item == null
                    || item.getMenuId() <= 0
                    || item.getQuantity() <= 0) {

                response.sendRedirect(contextPath + "/cart.jsp");
                return;
            }

            subtotal += item.getTotalPrice();
        }

        Connection connection = null;

        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // 5. Find the restaurant and verify menu items.
            Integer restaurantId = null;
            double verifiedSubtotal = 0.0;

            String menuSql =
                    "SELECT restaurant_id, price, is_available "
                    + "FROM menu WHERE menu_id = ? FOR UPDATE";

            try (PreparedStatement menuStatement =
                         connection.prepareStatement(menuSql)) {

                for (CartItem item : cart) {

                    menuStatement.setInt(1, item.getMenuId());

                    try (ResultSet rs =
                                 menuStatement.executeQuery()) {

                        if (!rs.next()) {
                            throw new SQLException(
                                    "Menu item not found.");
                        }

                        int currentRestaurantId =
                                rs.getInt("restaurant_id");

                        double currentPrice = rs.getDouble("price");
                        boolean available =
                                rs.getBoolean("is_available");

                        if (!available) {
                            throw new SQLException(
                                    "A selected menu item is unavailable.");
                        }

                        if (restaurantId == null) {
                            restaurantId = currentRestaurantId;
                        } else if (restaurantId != currentRestaurantId) {
                            throw new SQLException(
                                    "Please order items from one "
                                    + "restaurant at a time.");
                        }

                        verifiedSubtotal +=
                                currentPrice * item.getQuantity();
                    }
                }
            }

            // Use current database prices, not browser/cart prices.
            double grandTotal = verifiedSubtotal + DELIVERY_FEE;

            // 6. Insert order and obtain generated order ID.
            String orderSql =
                    "INSERT INTO orders "
                    + "(user_id, restaurant_id, order_date, "
                    + "total_amount, status, payment_mode) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            int orderId;

            try (PreparedStatement orderStatement =
                         connection.prepareStatement(
                                 orderSql,
                                 Statement.RETURN_GENERATED_KEYS)) {

                orderStatement.setInt(1, user.getUserId());
                orderStatement.setInt(2, restaurantId);
                orderStatement.setTimestamp(
                        3, new Timestamp(System.currentTimeMillis()));
                orderStatement.setDouble(4, grandTotal);
                orderStatement.setString(5, "PLACED");
                orderStatement.setString(6, paymentMode);

                orderStatement.executeUpdate();

                try (ResultSet keys =
                             orderStatement.getGeneratedKeys()) {

                    if (!keys.next()) {
                        throw new SQLException(
                                "Could not generate order ID.");
                    }

                    orderId = keys.getInt(1);
                }
            }

            // 7. Insert all order items.
            String itemSql =
                    "INSERT INTO order_items "
                    + "(order_id, menu_id, quantity, total_amount) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement itemStatement =
                         connection.prepareStatement(itemSql)) {

                for (CartItem item : cart) {

                    // Read the authoritative price again for this item.
                    try (PreparedStatement priceStatement =
                                 connection.prepareStatement(
                                         "SELECT price FROM menu "
                                         + "WHERE menu_id = ?")) {

                        priceStatement.setInt(1, item.getMenuId());

                        try (ResultSet rs =
                                     priceStatement.executeQuery()) {

                            if (!rs.next()) {
                                throw new SQLException(
                                        "Menu item disappeared.");
                            }

                            double price = rs.getDouble("price");

                            itemStatement.setInt(1, orderId);
                            itemStatement.setInt(2, item.getMenuId());
                            itemStatement.setInt(
                                    3, item.getQuantity());
                            itemStatement.setDouble(
                                    4, price * item.getQuantity());

                            itemStatement.executeUpdate();
                        }
                    }
                }
            }

            // 8. Commit both tables together.
            connection.commit();

            // 9. Clear cart only after successful commit.
            cart.clear();

            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderTotal", grandTotal);
            session.setAttribute("lastOrderName", customerName);
            session.setAttribute("lastOrderPhone", phone);
            session.setAttribute("lastOrderAddress", address);

            response.sendRedirect(
                    contextPath + "/order-confirmation.jsp");

        } catch (Exception e) {

            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    log("Order rollback failed.", rollbackError);
                }
            }

            log("Unable to place order.", e);

            response.sendRedirect(
                    contextPath + "/checkout?error=order");

        } finally {

            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    log("Unable to close database connection.", e);
                }
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/checkout");
    }
}
