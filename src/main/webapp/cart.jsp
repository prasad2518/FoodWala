
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.CartItem" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Cart | Foodwala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/cart.css">
</head>

<body>

    <%
        List<CartItem> cart =
            (List<CartItem>) session.getAttribute("cart");

        double subtotal = 0.0;

        if (cart != null) {
            for (CartItem item : cart) {
                subtotal += item.getTotalPrice();
            }
        }

        double deliveryFee = 40.0;
        double grandTotal = subtotal + deliveryFee;
    %>

    <!-- Shared Navbar -->
    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="cart-page">

        <div class="container">

            <h1 class="page-title">My Shopping Cart</h1>

            <% if (cart == null || cart.isEmpty()) { %>

                <section class="empty-cart">

                    <div class="empty-cart-icon" aria-hidden="true">
                        &#128722;
                    </div>

                    <h2>Your cart is empty!</h2>

                    <p>
                        Add some delicious food to get started.
                    </p>

                    <a class="shop-btn"
                       href="<%= request.getContextPath() %>/restaurants">
                        Explore Restaurants
                    </a>

                </section>

            <% } else { %>

                <div class="cart-layout">

                    <!-- Cart items -->
                    <section class="cart-items">

                        <% for (CartItem item : cart) { %>

                            <article class="cart-item">

                                <% if (item.getImagePath() != null
                                       && !item.getImagePath().trim().isEmpty()) { %>

                                    <img
                                        class="item-image"
                                        src="<%= item.getImagePath() %>"
                                        alt="<%= item.getItemName() %>">

                                <% } else { %>

                                    <div class="item-image empty-cart-icon"
                                         role="img"
                                         aria-label="Food image unavailable">
                                        &#127836;
                                    </div>

                                <% } %>

                                <div class="item-details">

                                    <h2 class="item-name">
                                        <%= item.getItemName() %>
                                    </h2>

                                    <p class="item-price">
                                        Price:
                                        &#8377;<%= String.format("%.2f",
                                            item.getPrice()) %>
                                    </p>

                                    <!-- Quantity controls -->
                                    <div class="quantity-section">

                                        <form class="quantity-form"
                                              action="<%= request.getContextPath() %>/cart"
                                              method="post">

                                            <input type="hidden"
                                                   name="action"
                                                   value="decrease">

                                            <input type="hidden"
                                                   name="menuId"
                                                   value="<%= item.getMenuId() %>">

                                            <button type="submit"
                                                    class="quantity-btn"
                                                    aria-label="Decrease quantity">
                                                &minus;
                                            </button>

                                        </form>

                                        <span class="quantity">
                                            <%= item.getQuantity() %>
                                        </span>

                                        <form class="quantity-form"
                                              action="<%= request.getContextPath() %>/cart"
                                              method="post">

                                            <input type="hidden"
                                                   name="action"
                                                   value="increase">

                                            <input type="hidden"
                                                   name="menuId"
                                                   value="<%= item.getMenuId() %>">

                                            <button type="submit"
                                                    class="quantity-btn"
                                                    aria-label="Increase quantity">
                                                +
                                            </button>

                                        </form>

                                    </div>

                                    <p class="item-total">
                                        Item Total:
                                        &#8377;<%= String.format("%.2f",
                                            item.getTotalPrice()) %>
                                    </p>

                                    <!-- Remove item -->
                                    <form class="remove-form"
                                          action="<%= request.getContextPath() %>/cart"
                                          method="post">

                                        <input type="hidden"
                                               name="action"
                                               value="remove">

                                        <input type="hidden"
                                               name="menuId"
                                               value="<%= item.getMenuId() %>">

                                        <button type="submit"
                                                class="remove-btn">
                                            Remove
                                        </button>

                                    </form>

                                </div>

                            </article>

                        <% } %>

                    </section>

                    <!-- Order summary -->
                    <aside class="summary">

                        <h2>Order Summary</h2>

                        <div class="summary-row">
                            <span>Subtotal</span>
                            <span>
                                &#8377;<%= String.format("%.2f", subtotal) %>
                            </span>
                        </div>

                        <div class="summary-row">
                            <span>Delivery Fee</span>
                            <span>
                                &#8377;<%= String.format("%.2f", deliveryFee) %>
                            </span>
                        </div>

                        <div class="summary-row summary-total">
                            <span>Total</span>
                            <span>
                                &#8377;<%= String.format("%.2f", grandTotal) %>
                            </span>
                        </div>

                        <form class="checkout-form"
                              action="<%= request.getContextPath() %>/checkout"
                              method="get">

                            <button type="submit" class="checkout-btn">
                                Proceed to Checkout
                            </button>

                        </form>

                        <a class="continue-shopping"
                           href="<%= request.getContextPath() %>/restaurants">
                            Continue Shopping
                        </a>

                    </aside>

                </div>

            <% } %>

        </div>

    </main>

    <!-- Shared Footer -->
    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

</body>
</html>
