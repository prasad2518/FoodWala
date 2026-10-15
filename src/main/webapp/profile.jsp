
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = user.getUsername() == null ? "" : user.getUsername();
    String email = user.getEmail() == null ? "" : user.getEmail();
    String phone = user.getPhone() == null ? "" : user.getPhone();
    String address = user.getAddress() == null ? "" : user.getAddress();
    String role = user.getRole() == null ? "" : user.getRole();

    username = username.replace("&", "&amp;").replace("<", "&lt;")
        .replace(">", "&gt;").replace("\"", "&quot;")
        .replace("'", "&#39;");

    email = email.replace("&", "&amp;").replace("<", "&lt;")
        .replace(">", "&gt;").replace("\"", "&quot;")
        .replace("'", "&#39;");

    phone = phone.replace("&", "&amp;").replace("<", "&lt;")
        .replace(">", "&gt;").replace("\"", "&quot;")
        .replace("'", "&#39;");

    address = address.replace("&", "&amp;").replace("<", "&lt;")
        .replace(">", "&gt;").replace("\"", "&quot;")
        .replace("'", "&#39;");

    role = role.replace("&", "&amp;").replace("<", "&lt;")
        .replace(">", "&gt;").replace("\"", "&quot;")
        .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Profile | Foodwala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/profile.css">
</head>

<body>

    <!-- Shared Navbar -->
    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="profile-page">

        <div class="profile-container">

            <section class="profile-card">

                <header class="profile-header">

                    <div class="profile-avatar" aria-hidden="true">
                        &#128100;
                    </div>

                    <h1>My Profile</h1>

                    <p>Your Foodwala account details</p>

                </header>

                <div class="profile-details">

                    <div class="profile-detail">
                        <span class="profile-detail-label">User ID</span>
                        <span class="profile-detail-value">
                            <%= user.getUserId() %>
                        </span>
                    </div>

                    <div class="profile-detail">
                        <span class="profile-detail-label">Username</span>
                        <span class="profile-detail-value">
                            <%= username %>
                        </span>
                    </div>

                    <div class="profile-detail">
                        <span class="profile-detail-label">Email Address</span>
                        <span class="profile-detail-value">
                            <%= email %>
                        </span>
                    </div>

                    <div class="profile-detail">
                        <span class="profile-detail-label">Phone Number</span>
                        <span class="profile-detail-value">
                            <%= phone.isEmpty() ? "Not provided" : phone %>
                        </span>
                    </div>

                    <div class="profile-detail">
                        <span class="profile-detail-label">Address</span>
                        <span class="profile-detail-value">
                            <%= address.isEmpty() ? "Not provided" : address %>
                        </span>
                    </div>

                    <div class="profile-detail">
                        <span class="profile-detail-label">Account Role</span>
                        <span class="profile-detail-value">
                            <span class="profile-role">
                                <%= role.isEmpty() ? "Customer" : role %>
                            </span>
                        </span>
                    </div>

                </div>

                <div class="profile-actions">

                    <a class="btn btn-primary"
                       href="<%= request.getContextPath() %>/restaurants">
                        Browse Restaurants
                    </a>

                    <a class="btn btn-secondary"
                       href="<%= request.getContextPath() %>/cart.jsp">
                        View My Cart
                    </a>

                </div>

            </section>

        </div>

    </main>

    <!-- Shared Footer -->
    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

</body>
</html>
