
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDao;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    @Override
    public int addOrderItem(OrderItem orderItem) {

        String sql = "INSERT INTO order_items "
                + "(order_id, menu_id, quantity, total_amount) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, orderItem.getOrderId());
            statement.setInt(2, orderItem.getMenuId());
            statement.setInt(3, orderItem.getQuantity());
            statement.setDouble(4, orderItem.getTotalAmount());

            int rowsInserted = statement.executeUpdate();

            if (rowsInserted != 1) {
                throw new SQLException("Order item was not inserted.");
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }

            throw new SQLException(
                    "Generated order item ID was not returned.");

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Unable to save order item.", e);
        }
    }

    @Override
    public OrderItem getOrderItemById(int orderItemId) {

        String sql = "SELECT * FROM order_items WHERE order_item_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, orderItemId);

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrderItem(rs);
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Unable to retrieve order item.", e);
        }

        return null;
    }

    @Override
    public List<OrderItem> getAllOrderItems() {

        String sql = "SELECT * FROM order_items";
        List<OrderItem> items = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                items.add(mapResultSetToOrderItem(rs));
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Unable to retrieve order items.", e);
        }

        return items;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        List<OrderItem> items = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, orderId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToOrderItem(rs));
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Unable to retrieve order items.", e);
        }

        return items;
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {

        String sql = "UPDATE order_items SET order_id = ?, menu_id = ?, "
                + "quantity = ?, total_amount = ? WHERE order_item_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, orderItem.getOrderId());
            statement.setInt(2, orderItem.getMenuId());
            statement.setInt(3, orderItem.getQuantity());
            statement.setDouble(4, orderItem.getTotalAmount());
            statement.setInt(5, orderItem.getOrderItemId());

            statement.executeUpdate();

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Unable to update order item.", e);
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {

        String sql = "DELETE FROM order_items WHERE order_item_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, orderItemId);
            statement.executeUpdate();

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Unable to delete order item.", e);
        }
    }

    private OrderItem mapResultSetToOrderItem(ResultSet rs)
            throws SQLException {

        OrderItem item = new OrderItem();

        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setMenuId(rs.getInt("menu_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setTotalAmount(rs.getDouble("total_amount"));

        return item;
    }
}
