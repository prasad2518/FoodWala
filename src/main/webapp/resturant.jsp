
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>

<%
    List<Restaurant> restaurants =
        (List<Restaurant>) request.getAttribute("restaurants");

    if (restaurants == null) {
        restaurants = java.util.Collections.emptyList();
    }

    String selectedCategory =
        request.getParameter("category") != null
            ? request.getParameter("category")
            : (String) request.getAttribute("selectedCategory");

    if (selectedCategory == null || selectedCategory.isBlank()) {
        selectedCategory = "All";
    }

    String searchText =
        request.getParameter("search") != null
            ? request.getParameter("search")
            : (String) request.getAttribute("searchText");

    if (searchText == null) {
        searchText = "";
    }

    // Unique variable name to avoid conflict with navbar.jspf
    String restaurantContextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodWala - Discover Delicious Food</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            color: #282c3f;
            background: #fffaf5;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .page-container {
            width: min(1500px, 90%);
            margin: 28px auto 60px;
        }

        /* HERO SECTION */

        .hero {
            min-height: 220px;
            display: flex;
            align-items: center;
            padding: 38px 48px;
            border-radius: 28px;
            background: linear-gradient(115deg, #fff0d9, #ffdfd2);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        }

        .hero-content {
            max-width: 800px;
        }

        .hero h1 {
            font-size: clamp(30px, 3vw, 46px);
            margin: 0 0 15px;
            color: #282c3f;
            line-height: 1.2;
        }

        .hero h1 span {
            color: #fc8019;
        }

        .hero p {
            font-size: 18px;
            line-height: 1.8;
            color: #686b78;
            margin: 0;
        }

        /* CATEGORY SECTION */

        .food-explore {
            margin-top: 38px;
        }

        .section-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 22px;
        }

        .section-heading h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 750;
            color: #282c3f;
        }

        .category-arrows {
            display: flex;
            gap: 10px;
        }

        .arrow-btn {
            width: 42px;
            height: 42px;
            border: none;
            border-radius: 50%;
            background: #eeeeee;
            color: #282c3f;
            font-size: 23px;
            cursor: pointer;
        }

        .arrow-btn:hover {
            background: #dddddd;
        }

        .food-category-list {
            display: flex;
            align-items: flex-start;
            gap: 24px;
            overflow-x: auto;
            overflow-y: hidden;
            padding: 6px 2px 18px;
            scroll-behavior: smooth;
            scrollbar-width: none;
        }

        .food-category-list::-webkit-scrollbar {
            display: none;
        }

        .food-category {
            flex: 0 0 145px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            text-align: center;
            color: #282c3f;
        }

        .category-image {
            width: 140px;
            height: 140px;
            flex: 0 0 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff4e9;
            border-radius: 50%;
            overflow: hidden;
            box-shadow: 0 3px 12px rgba(40, 44, 63, 0.08);
        }

        .category-image img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            transition: transform 0.25s ease;
        }

        .food-category:hover .category-image img {
            transform: scale(1.06);
        }

        .food-category span {
            font-size: 16px;
            font-weight: 600;
            line-height: 1.4;
        }

        .food-category.active span {
            color: #fc8019;
        }

        .food-category.active .category-image {
            outline: 2px solid #fc8019;
            outline-offset: 2px;
        }

        /* SEARCH */

        .search-form {
            display: flex;
            align-items: stretch;
            gap: 12px;
            margin: 42px 0;
        }

        .search-form input {
            flex: 1;
            min-width: 0;
            height: 62px;
            padding: 0 22px;
            font-size: 16px;
            border: 1px solid #dedede;
            border-radius: 14px;
            outline: none;
            background: #ffffff;
        }

        .search-form input:focus {
            border-color: #fc8019;
            box-shadow: 0 0 0 3px rgba(252, 128, 25, 0.10);
        }

        .search-form button {
            min-width: 115px;
            padding: 0 25px;
            border: none;
            border-radius: 13px;
            background: #fc8019;
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        .search-form button:hover {
            background: #e96e0a;
        }

        /* RESTAURANT GRID */

        .restaurant-section {
            margin-top: 35px;
        }

        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 25px;
        }

        .restaurant-card {
            min-width: 0;
            overflow: hidden;
            border-radius: 20px;
            background: #ffffff;
            box-shadow: 0 5px 22px rgba(0, 0, 0, 0.07);
            transition: transform 0.22s, box-shadow 0.22s;
        }

        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
        }

        .restaurant-image-wrap {
            width: 100%;
            height: 205px;
            overflow: hidden;
            background: #fff0e6;
        }

        .restaurant-image {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            transition: transform 0.3s;
        }

        .restaurant-card:hover .restaurant-image {
            transform: scale(1.04);
        }

        .restaurant-details {
            padding: 20px;
        }

        .restaurant-name {
            font-size: 20px;
            font-weight: 750;
            margin: 0 0 10px;
            color: #282c3f;
            line-height: 1.4;
        }

        .restaurant-cuisine {
            color: #777985;
            font-size: 15px;
            margin-bottom: 13px;
        }

        .restaurant-meta {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 14px;
            margin-bottom: 14px;
            font-size: 14px;
            font-weight: 600;
        }

        .rating {
            color: #16803c;
        }

        .restaurant-address {
            min-height: 40px;
            margin-bottom: 16px;
            font-size: 14px;
            line-height: 1.6;
            color: #777985;
        }

        .menu-button {
            display: block;
            width: 100%;
            padding: 15px 12px;
            text-align: center;
            border-radius: 12px;
            background: #fc8019;
            color: #ffffff;
            font-weight: 700;
            transition: background 0.2s;
        }

        .menu-button:hover {
            background: #e96e0a;
        }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 55px 20px;
            background: #ffffff;
            border-radius: 18px;
        }

        .empty-state h3 {
            margin-top: 0;
            font-size: 24px;
        }

        .empty-state p {
            color: #777985;
        }

        .clear-search {
            display: inline-block;
            margin-top: 10px;
            color: #fc8019;
            font-weight: 700;
        }

        /* FOOTER */

        .footer {
            padding: 28px 5%;
            background: #282c3f;
            color: #ffffff;
            text-align: center;
            font-size: 14px;
        }

        .footer span {
            color: #fc8019;
            font-weight: 700;
        }

        /* TABLET */

        @media (max-width: 1100px) {
            .restaurant-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .food-category-list {
                gap: 18px;
            }

            .food-category {
                flex-basis: 125px;
            }

            .category-image {
                width: 120px;
                height: 120px;
                flex-basis: 120px;
            }
        }

        /* MOBILE */

        @media (max-width: 760px) {
            .page-container {
                width: 92%;
                margin-top: 20px;
            }

            .hero {
                min-height: 180px;
                padding: 28px 24px;
                border-radius: 20px;
            }

            .hero p {
                font-size: 15px;
            }

            .section-heading h2 {
                font-size: 23px;
            }

            .food-category {
                flex-basis: 105px;
            }

            .category-image {
                width: 100px;
                height: 100px;
                flex-basis: 100px;
            }

            .food-category span {
                font-size: 14px;
            }

            .search-form {
                margin: 28px 0;
            }

            .search-form input {
                height: 54px;
                padding: 0 14px;
                font-size: 14px;
            }

            .search-form button {
                min-width: 85px;
                padding: 0 14px;
                font-size: 14px;
            }

            .restaurant-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 15px;
            }

            .restaurant-image-wrap {
                height: 160px;
            }

            .restaurant-details {
                padding: 14px;
            }

            .restaurant-name {
                font-size: 17px;
            }
        }

        @media (max-width: 480px) {
            .hero h1 {
                font-size: 29px;
            }

            .category-arrows {
                gap: 6px;
            }

            .arrow-btn {
                width: 34px;
                height: 34px;
                font-size: 19px;
            }

            .food-category {
                flex-basis: 92px;
            }

            .category-image {
                width: 88px;
                height: 88px;
                flex-basis: 88px;
            }

            .food-category span {
                font-size: 13px;
            }

            .restaurant-grid {
                grid-template-columns: 1fr;
            }

            .restaurant-image-wrap {
                height: 220px;
            }
        }
    </style>
</head>

<body>

    <!-- SHARED NAVBAR -->
    <%@ include file="/WEB-INF/jsp/common/navbar.jspf" %>

    <main class="page-container">

        <!-- HERO -->

        <section class="hero">
            <div class="hero-content">
                <h1>
                    Discover Delicious <span>Food</span>
                </h1>

                <p>
                    Explore your favourite restaurants, discover amazing
                    dishes, and enjoy delicious meals with FoodWala.
                </p>
            </div>
        </section>

        <!-- FOOD CATEGORIES -->

        <section class="food-explore">

            <div class="section-heading">
                <h2>What's on your mind?</h2>

                <div class="category-arrows">
                    <button type="button"
                            class="arrow-btn"
                            onclick="scrollCategories(-1)"
                            aria-label="Previous categories">
                        &#8592;
                    </button>

                    <button type="button"
                            class="arrow-btn"
                            onclick="scrollCategories(1)"
                            aria-label="Next categories">
                        &#8594;
                    </button>
                </div>
            </div>

            <div class="food-category-list" id="foodCategoryList">

                <%
                    String[][] categories = {
                        {"All", "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&auto=format&fit=crop"},
                        {"Biryani", "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300&auto=format&fit=crop"},
                        {"North Indian", "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=300&auto=format&fit=crop"},
                        {"South Indian", "https://images.unsplash.com/photo-1630383249896-424e482df921?w=300&auto=format&fit=crop"},
                        {"Fast Food", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&auto=format&fit=crop"},
                        {"Pizzas", "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&auto=format&fit=crop"},
                        {"Chinese", "https://images.unsplash.com/photo-1563245372-f21724e3856d?w=300&auto=format&fit=crop"},
                        {"Desserts", "https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300&auto=format&fit=crop"},
                        {"Beverages", "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=300&auto=format&fit=crop"}
                    };

                    for (String[] category : categories) {
                        String categoryName = category[0];
                        String categoryImage = category[1];

                        String categoryUrl =
                            restaurantContextPath + "/restaurants?category="
                            + java.net.URLEncoder.encode(
                                categoryName,
                                java.nio.charset.StandardCharsets.UTF_8
                            );

                        boolean active =
                            categoryName.equalsIgnoreCase(selectedCategory);
                %>

                    <a href="<%= categoryUrl %>"
                       class="food-category <%= active ? "active" : "" %>"
                       data-category="<%= categoryName %>">

                        <div class="category-image">
                            <img src="<%= categoryImage %>"
                                 alt="<%= categoryName %>"
                                 loading="lazy"
                                 onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&auto=format&fit=crop';">
                        </div>

                        <span><%= categoryName %></span>
                    </a>

                <%
                    }
                %>

            </div>
        </section>

        <!-- SEARCH -->

        <form class="search-form"
              action="<%= restaurantContextPath %>/restaurants"
              method="get">

            <input type="hidden"
                   name="category"
                   value="<%= selectedCategory %>">

            <input type="text"
                   name="search"
                   placeholder="Search restaurants, cuisines or dishes..."
                   value="<%= searchText.replace("&", "&amp;")
                                         .replace("\"", "&quot;")
                                         .replace("<", "&lt;")
                                         .replace(">", "&gt;") %>">

            <button type="submit">Search</button>
        </form>

        <!-- RESTAURANT LIST -->

        <section class="restaurant-section">

            <div class="section-heading">
                <h2>
                    <%= selectedCategory.equalsIgnoreCase("All")
                        ? "Top Restaurants Near You"
                        : selectedCategory + " Restaurants" %>
                </h2>
            </div>

            <div class="restaurant-grid">

                <%
                    if (restaurants.isEmpty()) {
                %>

                    <div class="empty-state">
                        <h3>No restaurants found</h3>

                        <p>
                            Try another category or search for a different
                            restaurant.
                        </p>

                        <a class="clear-search"
                           href="<%= restaurantContextPath %>/restaurants">
                            View all restaurants
                        </a>
                    </div>

                <%
                    } else {
                        for (Restaurant restaurant : restaurants) {

                            String imagePath = restaurant.getImagePath();

                            if (imagePath == null || imagePath.isBlank()) {
                                imagePath =
                                    "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop";
                            }

                            String restaurantName =
                                restaurant.getName() == null
                                    ? "Restaurant"
                                    : restaurant.getName();

                            String cuisine =
                                restaurant.getCuisineType() == null
                                    ? "Delicious Food"
                                    : restaurant.getCuisineType();

                            String address =
                                restaurant.getAddress() == null
                                    ? "Location not available"
                                    : restaurant.getAddress();
                %>

                    <article class="restaurant-card">

                        <div class="restaurant-image-wrap">
                            <img class="restaurant-image"
                                 src="<%= imagePath %>"
                                 alt="<%= restaurantName %>"
                                 loading="lazy"
                                 onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop';">
                        </div>

                        <div class="restaurant-details">

                            <h3 class="restaurant-name">
                                <%= restaurantName %>
                            </h3>

                            <div class="restaurant-cuisine">
                                <%= cuisine %>
                            </div>

                            <div class="restaurant-meta">

                                <span class="rating">
                                    &#9733;
                                    <%= String.format(
                                        java.util.Locale.US,
                                        "%.1f",
                                        restaurant.getRating()
                                    ) %>
                                </span>

                                <span>
                                    &#9201;
                                    <%= restaurant.getDeliveryTime() %> min
                                </span>

                            </div>

                            <div class="restaurant-address">
                                <%= address %>
                            </div>

                            <a class="menu-button"
                               href="<%= restaurantContextPath %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>">
                                View Menu
                            </a>

                        </div>
                    </article>

                <%
                        }
                    }
                %>

            </div>
        </section>

    </main>

    <!-- FOOTER -->

    <footer class="footer">
        Made with care by <span>FoodWala</span>
        &copy; <%= java.time.Year.now().getValue() %>
    </footer>

    <script>
        function scrollCategories(direction) {
            const categoryList =
                document.getElementById("foodCategoryList");

            if (categoryList) {
                categoryList.scrollBy({
                    left: direction * 500,
                    behavior: "smooth"
                });
            }
        }
    </script>

</body>
</html>
