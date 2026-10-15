
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    }

    Number subtotalValue = (Number) request.getAttribute("subtotal");
    Number deliveryFeeValue = (Number) request.getAttribute("deliveryFee");
    Number grandTotalValue = (Number) request.getAttribute("grandTotal");

    double subtotal = subtotalValue == null ? 0.0 : subtotalValue.doubleValue();
    double deliveryFee = deliveryFeeValue == null ? 40.0 : deliveryFeeValue.doubleValue();
    double grandTotal = grandTotalValue == null
        ? subtotal + deliveryFee
        : grandTotalValue.doubleValue();

    String address = user.getAddress() == null ? "" : user.getAddress();

    address = address.replace("&", "&amp;")
                     .replace("<", "&lt;")
                     .replace(">", "&gt;")
                     .replace("\"", "&quot;")
                     .replace("'", "&#39;");

    String customerName = user.getUsername() == null
        ? ""
        : user.getUsername();

    customerName = customerName.replace("&", "&amp;")
                               .replace("<", "&lt;")
                               .replace(">", "&gt;")
                               .replace("\"", "&quot;")
                               .replace("'", "&#39;");

    String phone = user.getPhone() == null ? "" : user.getPhone();

    phone = phone.replace("&", "&amp;")
                 .replace("<", "&lt;")
                 .replace(">", "&gt;")
                 .replace("\"", "&quot;")
                 .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Checkout | Foodwala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/checkout.css">

    <style>
        .payment-note {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 13px;
            background: #fff0df;
            color: #795548;
            line-height: 1.6;
        }

        .checkout-error {
            padding: 12px 15px;
            margin-bottom: 18px;
            border-radius: 12px;
            background: #fff0ef;
            color: #a52620;
        }
    </style>
</head>

<body>

    <!-- Shared Navbar -->
    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="checkout-page">

        <div class="container">

            <h1 class="checkout-title">Complete Your Order</h1>

            <div class="checkout-layout">

                <!-- Delivery and payment details -->
                <div class="checkout-main">

                    <section class="checkout-card">

                        <h2>Delivery Details</h2>

                        <form action="<%= request.getContextPath() %>/place-order"
                              method="post">

                            <div class="form-group">
                                <label for="customerName">Full Name</label>

                                <input
                                    class="form-control"
                                    type="text"
                                    id="customerName"
                                    name="customerName"
                                    value="<%= customerName %>"
                                    maxlength="100"
                                    autocomplete="name"
                                    required>
                            </div>

                            <div class="form-group">
                                <label for="phone">Phone Number</label>

                                <input
                                    class="form-control"
                                    type="tel"
                                    id="phone"
                                    name="phone"
                                    value="<%= phone %>"
                                    pattern="[0-9]{10}"
                                    maxlength="10"
                                    inputmode="numeric"
                                    autocomplete="tel"
                                    title="Enter a 10-digit phone number"
                                    required>
                            </div>

                            <div class="form-group">
                                <label for="address">Delivery Address</label>

                                <textarea
                                    class="form-control"
                                    id="address"
                                    name="address"
                                    maxlength="500"
                                    autocomplete="street-address"
                                    required><%= address %></textarea>
                            </div>

                            <h2>Payment Method</h2>

                            <label class="payment-option">
                                <input
                                    type="radio"
                                    name="paymentMode"
                                    value="COD"
                                    checked
                                    required>

                                <span>
                                    <strong>Cash on Delivery</strong>
                                    <small>
                                        Pay for your order when it arrives.
                                    </small>
                                </span>
                            </label>

                            <div class="payment-note">
                                <strong>Pay safely on delivery.</strong>
                                <br>
                                Have the order amount ready when your food
                                reaches your delivery address.
                            </div>

                            <button type="submit"
                                    class="place-order-btn">
                                Place Order
                            </button>

                        </form>

                        <a class="back-to-cart"
                           href="<%= request.getContextPath() %>/cart.jsp">
                            &larr; Back to Cart
                        </a>

                    </section>

                </div>

                <!-- Order summary -->
                <aside class="checkout-summary">

                    <h2>Your Order</h2>

                    <% for (CartItem item : cart) { %>

                        <div class="checkout-summary-row">
                            <span>
                                <%= item.getItemName() %>
                                &times; <%= item.getQuantity() %>
                            </span>

                            <span>
                                &#8377;<%= String.format("%.2f",
                                    item.getTotalPrice()) %>
                            </span>
                        </div>

                    <% } %>

                    <hr class="divider">

                    <div class="checkout-summary-row">
                        <span>Subtotal</span>

                        <span>
                            &#8377;<%= String.format("%.2f", subtotal) %>
                        </span>
                    </div>

                    <div class="checkout-summary-row">
                        <span>Delivery Fee</span>

                        <span>
                            &#8377;<%= String.format("%.2f", deliveryFee) %>
                        </span>
                    </div>

                    <div class="checkout-summary-row checkout-summary-total">
                        <span>Total</span>

                        <span>
                            &#8377;<%= String.format("%.2f", grandTotal) %>
                        </span>
                    </div>

                    <p class="checkout-note">
                        Please verify your delivery details before
                        placing your order.
                    </p>

                </aside>

            </div>

        </div>

    </main>

    <!-- Shared Footer -->
    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

</body>
</html>
