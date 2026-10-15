
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login | FoodWala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/auth.css">
</head>

<body>

    <!-- Navbar removed from login page -->

    <main class="auth-page">

        <section class="auth-card">

            <h1 class="auth-heading">Welcome Back!</h1>

            <p class="auth-subtitle">
                Login to your Foodwala account and enjoy your favourite food.
            </p>

            <% if ("1".equals(request.getParameter("error"))) { %>

                <div class="auth-error" role="alert">
                    Invalid email or password. Please try again.
                </div>

            <% } %>

            <% if ("registered".equals(request.getParameter("message"))) { %>

                <div class="auth-success" role="status">
                    Registration successful! Please log in.
                </div>

            <% } %>

            <form class="auth-form"
                  action="<%= request.getContextPath() %>/login"
                  method="post">

                <div class="form-group">

                    <label for="email">Email Address</label>

                    <input
                        class="form-control"
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your email"
                        autocomplete="email"
                        maxlength="254"
                        required>

                </div>

                <div class="form-group">

                    <label for="password">Password</label>

                    <input
                        class="form-control"
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                </div>

                <button type="submit" class="auth-btn">
                    Login
                </button>

            </form>

            <p class="auth-switch">
                Don't have an account?

                <a href="<%= request.getContextPath() %>/register.jsp">
                    Sign Up
                </a>
            </p>

            <p class="auth-note">
                Welcome to Foodwala — delicious food is just a few clicks away.
            </p>

        </section>

    </main>

    <!-- Shared footer preserved -->

    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

</body>
</html>
