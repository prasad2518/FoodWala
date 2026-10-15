
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    @Override
    public List<Restaurant> getRestaurants(
            String category, String search) {

        List<Restaurant> restaurants = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT r.restaurant_id, r.name, " +
            "r.cuisine_type, r.delivery_time, r.address, " +
            "r.admin_user_id, r.rating, r.is_active, r.image_path " +
            "FROM restaurants r " +
            "LEFT JOIN menu m ON r.restaurant_id = m.restaurant_id " +
            "WHERE r.is_active = 1 "
        );

        List<Object> parameters = new ArrayList<>();

        // Filter by the selected food category.
        if (category != null
                && !category.isBlank()
                && !category.equalsIgnoreCase("All")) {

            String categoryPattern;

            switch (category.toLowerCase()) {
                case "biryani":
                    categoryPattern = "%biryani%";
                    break;

                case "north indian":
                    categoryPattern = "%north indian%";
                    break;

                case "south indian":
                    categoryPattern = "%south indian%";
                    break;

                case "fast food":
                    categoryPattern = "%fast food%";
                    break;

                case "pizzas":
                    categoryPattern = "%pizza%";
                    break;

                case "chinese":
                    categoryPattern = "%chinese%";
                    break;

                case "desserts":
                    categoryPattern = "%dessert%";
                    break;

                case "beverages":
                    categoryPattern = "%beverage%";
                    break;

                default:
                    categoryPattern = "%" + category + "%";
                    break;
            }

            sql.append(
                "AND (LOWER(COALESCE(r.cuisine_type, '')) LIKE LOWER(?) " +
                "OR LOWER(COALESCE(m.item_name, '')) LIKE LOWER(?)) "
            );

            parameters.add(categoryPattern);
            parameters.add(categoryPattern);
        }

        // Search by restaurant name, cuisine, or menu item.
        if (search != null && !search.isBlank()) {

            String searchPattern = "%" + search.trim() + "%";

            sql.append(
                "AND (LOWER(r.name) LIKE LOWER(?) " +
                "OR LOWER(COALESCE(r.cuisine_type, '')) LIKE LOWER(?) " +
                "OR LOWER(COALESCE(m.item_name, '')) LIKE LOWER(?)) "
            );

            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        sql.append(
            "ORDER BY r.rating DESC, r.name ASC"
        );

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {

                    int adminUserId = resultSet.getInt("admin_user_id");

                    if (resultSet.wasNull()) {
                        adminUserId = 0;
                    }

                    Restaurant restaurant = new Restaurant(
                        resultSet.getInt("restaurant_id"),
                        resultSet.getString("name"),
                        resultSet.getString("cuisine_type"),
                        resultSet.getInt("delivery_time"),
                        resultSet.getString("address"),
                        adminUserId,
                        resultSet.getDouble("rating"),
                        resultSet.getBoolean("is_active"),
                        resultSet.getString("image_path")
                    );

                    restaurants.add(restaurant);
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                "Unable to fetch restaurants", e
            );
        }

        return restaurants;
    }
}
