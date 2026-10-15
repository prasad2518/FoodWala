
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.tap.model.Order" %>

<%
    List<Order> orders =
        (List<Order>) request.getAttribute("orders");

    Map<Integer, List<Map<String, Object>>> orderItemsMap =
        (Map<Integer, List<Map<String, Object>>>)
            request.getAttribute("orderItemsMap");

    if (orders == null || orderItemsMap == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }

    SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Orders | Foodwala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <style>
        .orders-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
        }

        .orders-heading {
            margin-bottom: 30px;
        }

        .orders-heading h1 {
            font-size: 36px;
            margin-bottom: 8px;
            color: #292929;
        }

        .orders-heading p {
            color: #777;
        }

        .order-card {
            background: #fff;
            border: 1px solid #eee8e1;
            border-radius: 18px;
            margin-bottom: 26px;
            overflow: hidden;
            box-shadow: 0 6px 24px rgba(0, 0, 0, 0.05);
        }

        .order-header {
            padding: 22px 25px;
            background: #fff;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .order-id {
            font-size: 19px;
            font-weight: 700;
            color: #252525;
        }

        .order-date {
            color: #777;
            font-size: 14px;
            margin-top: 7px;
        }

        .order-status {
            display: inline-block;
            background: #e6f8ed;
            color: #168447;
            border-radius: 20px;
            padding: 9px 15px;
            font-size: 13px;
            font-weight: 700;
        }

        .food-items {
            padding: 8px 25px;
        }

        .food-item {
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 20px 0;
            border-bottom: 1px solid #f0ece7;
        }

        .food-item:last-child {
            border-bottom: none;
        }

        .food-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 13px;
            background: #f5eee6;
            flex-shrink: 0;
        }

        .food-placeholder {
            width: 100px;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 13px;
            background: #f5eee6;
            font-size: 38px;
            flex-shrink: 0;
        }

        .food-info {
            flex: 1;
            min-width: 0;
        }

        .food-name {
            color: #292929;
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 9px;
            overflow-wrap: anywhere;
        }

        .food-quantity {
            color: #777;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .food-unit-price {
            color: #777;
            font-size: 13px;
        }

        .food-total {
            color: #292929;
            font-weight: 700;
            white-space: nowrap;
        }

        .order-footer {
            background: #fcfaf7;
            border-top: 1px solid #eee8e1;
            padding: 20px 25px;
        }

        .payment-row,
        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .payment-row {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .total-row {
            padding-top: 14px;
            border-top: 1px dashed #ddd3c8;
        }

        .total-label {
            font-weight: 700;
            color: #333;
        }

        .total-amount {
            font-size: 23px;
            color: #f45b35;
            font-weight: 800;
        }

        .empty-orders {
            background: #fff;
            border-radius: 18px;
            padding: 55px 20px;
            text-align: center;
            box-shadow: 0 5px 22px rgba(0, 0, 0, 0.05);
        }

        .empty-orders h2 {
            margin-bottom: 12px;
        }

        .empty-orders p {
            color: #777;
            margin-bottom: 24px;
        }

        .food-button {
            display: inline-block;
            background: #f45b35;
            color: white;
            padding: 13px 22px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 700;
        }

        .no-items {
            color: #777;
            padding: 20px 0;
        }

        @media (max-width: 600px) {
            .orders-container {
                margin: 20px auto;
                padding: 14px;
            }

            .orders-heading h1 {
                font-size: 29px;
            }

            .order-header {
                padding: 18px;
            }

            .food-items {
                padding: 5px 16px;
            }

            .food-item {
                gap: 12px;
                align-items: flex-start;
            }

            .food-image,
            .food-placeholder {
                width: 76px;
                height: 76px;
            }

            .food-placeholder {
                font-size: 30px;
            }

            .food-name {
                font-size: 15px;
            }

            .food-total {
                font-size: 14px;
            }

            .order-footer {
                padding: 18px;
            }

            .total-amount {
                font-size: 20px;
            }
        }
    </style>
</head>

<body>

    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="orders-container">

        <div class="orders-heading">
            <h1>My Orders</h1>
            <p>Your food orders, all in one place.</p>
        </div>

        <% if (orders.isEmpty()) { %>

            <section class="empty-orders">
                <h2>No orders yet!</h2>

                <p>
                    Your delicious food journey starts here.
                    Explore restaurants and order your favourite food.
                </p>

                <a class="food-button"
                   href="<%= request.getContextPath() %>/restaurants">
                    Explore Restaurants
                </a>
            </section>

        <% } else { %>

            <% for (Order order : orders) { %>

                <section class="order-card">

                    <div class="order-header">

                        <div>
                            <div class="order-id">
                                Order #<%= order.getOrderId() %>
                            </div>

                            <div class="order-date">
                                <% if (order.getOrderDate() != null) { %>
                                    <%= dateFormat.format(
                                        order.getOrderDate()) %>
                                <% } else { %>
                                    Date unavailable
                                <% } %>
                            </div>
                        </div>

                        <span class="order-status">
                            <%= order.getStatus() %>
                        </span>

                    </div>

                    <div class="food-items">

                        <%
                            List<Map<String, Object>> foodItems =
                                orderItemsMap.get(order.getOrderId());
                        %>

                        <% if (foodItems != null && !foodItems.isEmpty()) { %>

                            <% for (Map<String, Object> food : foodItems) { %>

                                <%
                                    String itemName =
                                        String.valueOf(food.get("itemName"));

                                    Object imageObject = food.get("imagePath");

                                    String imagePath =
                                        imageObject == null
                                            ? ""
                                            : imageObject.toString().trim();

                                    int quantity =
                                        ((Number) food.get("quantity")).intValue();

                                    double itemPrice =
                                        ((Number) food.get("price")).doubleValue();

                                    double itemTotal =
                                        ((Number) food.get("itemTotal")).doubleValue();

                                    String imageUrl = "";

                                    if (!imagePath.isEmpty()) {
                                        if (imagePath.startsWith("http://")
                                                || imagePath.startsWith("https://")) {
                                            imageUrl = imagePath;
                                        } else if (imagePath.startsWith("/")) {
                                            imageUrl =
                                                request.getContextPath() + imagePath;
                                        } else {
                                            imageUrl =
                                                request.getContextPath() + "/" + imagePath;
                                        }
                                    }
                                %>

                                <div class="food-item">

                                    <% if (!imageUrl.isEmpty()) { %>

                                        <img class="food-image"
                                             src="<%= imageUrl %>"
                                             alt="Food item"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">

                                        <div class="food-placeholder"
                                             style="display:none;">
                                            🍽️
                                        </div>

                                    <% } else { %>

                                        <div class="food-placeholder">
                                            🍽️
                                        </div>

                                    <% } %>

                                    <div class="food-info">

                                        <div class="food-name">
                                            <%= itemName %>
                                        </div>

                                        <div class="food-quantity">
                                            Quantity: <%= quantity %>
                                        </div>

                                        <div class="food-unit-price">
                                            ₹<%= String.format("%.2f", itemPrice) %>
                                            per item
                                        </div>

                                    </div>

                                    <div class="food-total">
                                        ₹<%= String.format("%.2f", itemTotal) %>
                                    </div>

                                </div>

                            <% } %>

                        <% } else { %>

                            <p class="no-items">
                                Food item details are unavailable for this order.
                            </p>

                        <% } %>

                    </div>

                    <div class="order-footer">

                        <div class="payment-row">
                            <span>Payment method</span>
                            <strong><%= order.getPaymentMode() %></strong>
                        </div>

                        <div class="total-row">
                            <span class="total-label">
                                Total paid on order
                            </span>

                            <span class="total-amount">
                                ₹<%= String.format(
                                    "%.2f", order.getTotalAmount()) %>
                            </span>
                        </div>

                    </div>

                </section>

            <% } %>

        <% } %>

    </main>

    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

</body>
</html>
