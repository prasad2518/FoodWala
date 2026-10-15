
package com.tap.controlers;

import java.io.IOException;
import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurants")
public class RestaurantController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RestaurantDao restaurantDao;

    @Override
    public void init() throws ServletException {
        restaurantDao = new RestaurantDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String search = request.getParameter("search");

        if (category == null || category.isBlank()) {
            category = "All";
        }

        if (search == null) {
            search = "";
        }

        try {
            List<Restaurant> restaurants =
                    restaurantDao.getRestaurants(category, search);

            request.setAttribute("restaurants", restaurants);
            request.setAttribute("selectedCategory", category);
            request.setAttribute("searchText", search);

            request.getRequestDispatcher("/resturant.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load restaurants", e);
        }
    }
}
