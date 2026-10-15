
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Menu" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Foodwala - Menu</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/base.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/components.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/menu.css">
</head>

<body>

    <!-- Shared Navbar -->
    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="menu-page">

        <div class="container">

            <!-- Menu Header -->
            <section class="menu-hero">
                <a class="menu-back-link"
                   href="<%= request.getContextPath() %>/restaurants">
                    &larr; Back to Restaurants
                </a>

                <h1>Explore Our <span>Menu</span></h1>

                <p>
                    Choose your favourite dishes and enjoy delicious food
                    freshly prepared for you.
                </p>
            </section>

            <!-- Menu Items -->
            <section class="menu-section">

                <div class="section-heading">
                    <h2>Available Dishes</h2>
                    <p>Find something delicious to enjoy.</p>
                </div>

                <%
                    List<Menu> menuList =
                        (List<Menu>) request.getAttribute("menuList");

                    if (menuList != null && !menuList.isEmpty()) {
                %>

                    <div class="menu-grid">

                        <%
                            for (Menu menu : menuList) {

                                String imagePath = menu.getImagePath();

                                boolean hasImage = imagePath != null
                                    && !imagePath.trim().isEmpty();
                        %>

                            <article class="menu-card">

                                <% if (hasImage) { %>

                                    <img
                                        class="menu-image"
                                        src="<%= imagePath %>"
                                        alt="<%= menu.getItemName() %>"
                                        loading="lazy">

                                <% } else { %>

                                    <div class="menu-image-placeholder"
                                         role="img"
                                         aria-label="Food image unavailable">
                                        🍽
                                    </div>

                                <% } %>

                                <div class="menu-card-content">

                                    <span class="menu-category">
                                        Food Item
                                    </span>

                                    <h3><%= menu.getItemName() %></h3>

                                    <p class="menu-description">
                                        <%= menu.getDescription() != null
                                            ? menu.getDescription()
                                            : "Freshly prepared and delicious." %>
                                    </p>

                                    <div class="menu-card-bottom">

                                        <span class="menu-price">
                                            &#8377;<%= String.format(
                                                "%.2f", menu.getPrice()) %>
                                        </span>

                                        <% if (menu.isAvailable()) { %>

                                            <span class="badge badge-success">
                                                Available
                                            </span>

                                        <% } else { %>

                                            <span class="badge">
                                                Unavailable
                                            </span>

                                        <% } %>

                                    </div>

                                    <% if (menu.isAvailable()) { %>

                                        <form
                                            action="<%= request.getContextPath() %>/cart"
                                            method="post">

                                            <input
                                                type="hidden"
                                                name="menuId"
                                                value="<%= menu.getMenuId() %>">

                                            <button type="submit"
                                                    class="btn btn-primary btn-full">
                                                Add to Cart
                                            </button>

                                        </form>

                                    <% } else { %>

                                        <button
                                            type="button"
                                            class="btn btn-secondary btn-full"
                                            disabled>
                                            Currently Unavailable
                                        </button>

                                    <% } %>

                                </div>

                            </article>

                        <%
                            }
                        %>

                    </div>

                <%
                    } else {
                %>

                    <div class="empty-state">
                        <h3>No menu items available</h3>

                        <p>
                            This restaurant has no menu items available
                            right now. Please check again later.
                        </p>

                        <a class="btn btn-primary"
                           href="<%= request.getContextPath() %>/restaurants">
                            Browse Restaurants
                        </a>
                    </div>

                <%
                    }
                %>

            </section>

        </div>

    </main>

    <!-- Shared Footer -->
    <%@ include file="/WEB-INF/jsp/common/footer.jspf" %>

</body>
</html>
