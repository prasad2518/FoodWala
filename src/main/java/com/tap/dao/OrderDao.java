
package com.tap.dao;

import java.util.List;
import com.tap.model.Order;

public interface OrderDao {

    // Insert an order and return its generated order ID.
    int addOrder(Order order);

    Order getOrderById(int orderId);

    List<Order> getAllOrders();

    List<Order> getOrdersByUserId(int userId);

    List<Order> getOrdersByRestaurantId(int restaurantId);

    void updateOrder(Order order);

    void deleteOrder(int orderId);
}
