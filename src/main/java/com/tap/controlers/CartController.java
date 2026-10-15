
package com.tap.controlers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        String action = req.getParameter("action");

        // STEP 1: Handle cart actions
        if (action != null) {

            if (cart == null) {
                resp.sendRedirect(req.getContextPath() + "/cart.jsp");
                return;
            }

            String menuIdParam = req.getParameter("menuId");

            if (menuIdParam == null || menuIdParam.isBlank()) {
                resp.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Menu ID is required");
                return;
            }

            int menuId;

            try {
                menuId = Integer.parseInt(menuIdParam);
            } catch (NumberFormatException e) {
                resp.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid menu ID");
                return;
            }

            Iterator<CartItem> iterator = cart.iterator();

            while (iterator.hasNext()) {

                CartItem item = iterator.next();

                if (item.getMenuId() == menuId) {

                    // Increase quantity
                    if ("increase".equals(action)) {
                        item.setQuantity(item.getQuantity() + 1);
                    }

                    // Decrease quantity; remove at zero
                    else if ("decrease".equals(action)) {

                        item.setQuantity(item.getQuantity() - 1);

                        if (item.getQuantity() <= 0) {
                            iterator.remove();
                        }
                    }

                    // Remove item completely
                    else if ("remove".equals(action)) {
                        iterator.remove();
                    }

                    else {
                        resp.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,
                                "Unknown cart action");
                        return;
                    }

                    break;
                }
            }

            session.setAttribute("cart", cart);

            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        // STEP 2: Add an item to the cart
        String menuIdParam = req.getParameter("menuId");

        if (menuIdParam == null || menuIdParam.isBlank()) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Menu ID is required");
            return;
        }

        int menuId;

        try {
            menuId = Integer.parseInt(menuIdParam);
        } catch (NumberFormatException e) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid menu ID");
            return;
        }

        MenuDaoImpl menuDao = new MenuDaoImpl();
        Menu menu = menuDao.getMenuById(menuId);

        if (menu == null) {
            resp.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Menu item not found");
            return;
        }

        if (!menu.isAvailable()) {
            resp.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    "This menu item is unavailable");
            return;
        }

        if (cart == null) {
            cart = new ArrayList<>();
        }

        boolean itemExists = false;

        for (CartItem item : cart) {

            if (item.getMenuId() == menuId) {
                item.setQuantity(item.getQuantity() + 1);
                itemExists = true;
                break;
            }
        }

        if (!itemExists) {

            CartItem cartItem = new CartItem(
                    menu.getMenuId(),
                    menu.getItemName(),
                    menu.getPrice(),
                    1,
                    menu.getImagePath()
            );

            cart.add(cartItem);
        }

        session.setAttribute("cart", cart);

        resp.sendRedirect(req.getContextPath() + "/cart.jsp");
    }
}
