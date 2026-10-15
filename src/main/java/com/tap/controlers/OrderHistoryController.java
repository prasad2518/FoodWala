
package com.tap.controlers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.dao.OrderDao;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Menu;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrderHistoryController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDao orderDao;
    private OrderItemDaoImpl orderItemDao;
    private MenuDaoImpl menuDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Only logged-in users can view their orders.
        if (session == null
                || session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        try {
            // Fetch orders belonging to this user only.
            List<Order> orders =
                    orderDao.getOrdersByUserId(user.getUserId());

            // Store each order's food items using its order ID.
            Map<Integer, List<Map<String, Object>>> orderItemsMap =
                    new HashMap<>();

            for (Order order : orders) {

                List<OrderItem> orderItems =
                        orderItemDao.getOrderItemsByOrderId(
                                order.getOrderId());

                List<Map<String, Object>> foodDetails =
                        new ArrayList<>();

                for (OrderItem orderItem : orderItems) {

                    Menu menu =
                            menuDao.getMenuById(orderItem.getMenuId());

                    Map<String, Object> food = new HashMap<>();

                    food.put("quantity", orderItem.getQuantity());
                    food.put("itemTotal", orderItem.getTotalAmount());

                    if (menu != null) {
                        food.put("itemName", menu.getItemName());
                        food.put("imagePath", menu.getImagePath());
                        food.put("price", menu.getPrice());
                    } else {
                        food.put("itemName", "Food item unavailable");
                        food.put("imagePath", null);
                        food.put("price", 0.0);
                    }

                    foodDetails.add(food);
                }

                orderItemsMap.put(order.getOrderId(), foodDetails);
            }

            request.setAttribute("orders", orders);
            request.setAttribute("orderItemsMap", orderItemsMap);

            request.getRequestDispatcher("/orders.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load order history", e);
        }
    }
}
