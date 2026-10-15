
package com.tap.dao;

import java.util.List;
import com.tap.model.Restaurant;

public interface RestaurantDao {

    List<Restaurant> getRestaurants(String category, String search);
}
