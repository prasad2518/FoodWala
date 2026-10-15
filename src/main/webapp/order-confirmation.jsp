
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession orderSession = request.getSession(false);

    if (orderSession == null
            || orderSession.getAttribute("loggedInUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Object orderIdObject = orderSession.getAttribute("lastOrderId");
    Object totalObject = orderSession.getAttribute("lastOrderTotal");

    if (orderIdObject == null || totalObject == null) {
        response.sendRedirect(request.getContextPath() + "/restaurants");
        return;
    }

    int orderId = (Integer) orderIdObject;
    double total = ((Number) totalObject).doubleValue();

    String customerName =
        (String) orderSession.getAttribute("lastOrderName");
    String phone =
        (String) orderSession.getAttribute("lastOrderPhone");
    String address =
        (String) orderSession.getAttribute("lastOrderAddress");

    if (customerName == null) customerName = "";
    if (phone == null) phone = "";
    if (address == null) address = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed | Foodwala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <style>
        .confirmation-wrapper {
            max-width: 760px;
            margin: 55px auto;
            padding: 20px;
        }

        .confirmation-card {
            background: #fff;
            border-radius: 24px;
            padding: 40px 30px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.08);
            text-align: center;
        }

        .success-icon {
            width: 82px;
            height: 82px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: #e6f8ed;
            color: #18864b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 42px;
        }

        .confirmation-card h1 {
            color: #18864b;
            margin-bottom: 12px;
        }

        .confirmation-card p {
            color: #666;
            line-height: 1.7;
        }

        .order-details {
            margin-top: 30px;
            padding: 22px;
            background: #f7f1e9;
            border-radius: 16px;
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            padding: 12px 0;
            border-bottom: 1px solid #e6ded4;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-row strong {
            text-align: right;
            overflow-wrap: anywhere;
        }

        .total-row {
            color: #f45b35;
            font-size: 19px;
            font-weight: bold;
        }

        .confirmation-actions {
            display: flex;
            justify-content: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 28px;
        }

        .confirmation-actions a {
            display: inline-block;
            padding: 13px 22px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }

        .primary-action {
            background: #f45b35;
            color: white;
        }

        .secondary-action {
            background: #f1f1f1;
            color: #333;
        }

        @media (max-width: 500px) {
            .confirmation-card {
                padding: 28px 18px;
            }

            .detail-row {
                flex-direction: column;
                gap: 5px;
            }

            .detail-row strong {
                text-align: left;
            }
        }
    </style>
</head>

<body>

    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="confirmation-wrapper">
        <section class="confirmation-card">

            <div class="success-icon" aria-hidden="true">
                &#10003;
            </div>

            <h1>Order Placed Successfully!</h1>

            <p>
                Thank you for ordering with Foodwala.
                Your order has been recorded successfully.
            </p>

            <div class="order-details">

                <div class="detail-row">
                    <span>Order ID</span>
                    <strong>#<%= orderId %></strong>
                </div>

                <div class="detail-row">
                    <span>Customer Name</span>
                    <strong><%= customerName %></strong>
                </div>

                <div class="detail-row">
                    <span>Phone Number</span>
                    <strong><%= phone %></strong>
                </div>

                <div class="detail-row">
                    <span>Delivery Address</span>
                    <strong><%= address %></strong>
                </div>

                <div class="detail-row">
                    <span>Payment Method</span>
                    <strong>Cash on Delivery</strong>
                </div>

                <div class="detail-row">
                    <span>Order Status</span>
                    <strong>PLACED</strong>
                </div>

                <div class="detail-row total-row">
                    <span>Total Amount</span>
                    <strong>
                        &#8377;<%= String.format("%.2f", total) %>
                    </strong>
                </div>

            </div>

            <div class="confirmation-actions">
                <a class="primary-action"
                   href="<%= request.getContextPath() %>/restaurants">
                    Order More Food
                </a>

                <a class="secondary-action"
                   href="<%= request.getContextPath() %>/profile.jsp">
                    My Profile
                </a>
            </div>

        </section>
    </main>

    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

</body>
</html>
