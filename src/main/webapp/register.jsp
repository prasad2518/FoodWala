
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sign Up | Foodwala</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/auth.css">
</head>

<body>

    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="auth-page">

        <section class="auth-card">

            <h1 class="auth-heading">Create Account</h1>

            <p class="auth-subtitle">
                Join Foodwala and order your favourite food.
            </p>

            <% if ("1".equals(request.getParameter("error"))) { %>
                <div class="auth-error" role="alert">
                    Registration failed. Please check your details and try again.
                </div>
            <% } %>

            <% if ("email".equals(request.getParameter("error"))) { %>
                <div class="auth-error" role="alert">
                    This email address is already registered. Please log in.
                </div>
            <% } %>

            <form class="auth-form"
                  action="<%= request.getContextPath() %>/register"
                  method="post"
                  onsubmit="return validateSignup()">

                <div class="form-group">
                    <label for="username">Full Name</label>
                    <input class="form-control"
                           type="text"
                           id="username"
                           name="username"
                           placeholder="Enter your full name"
                           minlength="2"
                           maxlength="100"
                           autocomplete="name"
                           required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input class="form-control"
                           type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           maxlength="254"
                           autocomplete="email"
                           required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input class="form-control"
                           type="password"
                           id="password"
                           name="password"
                           placeholder="Create a password"
                           minlength="8"
                           autocomplete="new-password"
                           required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input class="form-control"
                           type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           placeholder="Re-enter your password"
                           minlength="8"
                           autocomplete="new-password"
                           required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input class="form-control"
                           type="tel"
                           id="phone"
                           name="phone"
                           placeholder="Enter 10-digit phone number"
                           pattern="[0-9]{10}"
                           maxlength="10"
                           inputmode="numeric"
                           autocomplete="tel"
                           required>
                </div>

                <div class="form-group">
                    <label for="address">Delivery Address</label>
                    <textarea class="form-control"
                              id="address"
                              name="address"
                              placeholder="Enter your delivery address"
                              maxlength="500"
                              autocomplete="street-address"
                              required></textarea>
                </div>

                <button type="submit" class="auth-btn">
                    Create Account
                </button>

            </form>

            <p class="auth-switch">
                Already have an account?
                <a href="<%= request.getContextPath() %>/login.jsp">
                    Login
                </a>
            </p>

        </section>

    </main>

    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

    <script>
        function validateSignup() {
            const password = document.getElementById("password").value;
            const confirmPassword =
                document.getElementById("confirmPassword").value;

            if (password !== confirmPassword) {
                alert("Passwords do not match. Please try again.");
                return false;
            }

            return true;
        }
    </script>

</body>
</html>
