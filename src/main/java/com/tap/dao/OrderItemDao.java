
package com.tap.dao;

import java.util.List;
import com.tap.model.OrderItem;

public interface OrderItemDao {

    // Insert an order item and return its generated ID.
    int addOrderItem(OrderItem orderItem);

    OrderItem getOrderItemById(int orderItemId);

    List<OrderItem> getAllOrderItems();

    List<OrderItem> getOrderItemsByOrderId(int orderId);

    void updateOrderItem(OrderItem orderItem);

    void deleteOrderItem(int orderItemId);
}
