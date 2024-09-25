<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="connect.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ include file="navbar.jsp" %>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <title>MyShop</title>
</head>

<body>
<div class="hero-section">
    <h1>Welcome to MyShop!</h1>
    <p>Explore our top products below!</p>
</div>

<div class="product-list">
    <%
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection(); // Using the connection utility
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT * FROM products LIMIT 4");

            // Get the current session to check login status
//            HttpSession session = request.getSession();
            Boolean isLoggedIn = (session.getAttribute("user") != null);

            while (rs.next()) {
    %>
                <div class="product-item">
                    <img src="product-images/<%= rs.getString("image") %>" alt="<%= rs.getString("name") %>" />
                    <h3><%= rs.getString("name") %></h3>
                    <p>Category: <%= rs.getString("category") %></p>
                    <p>Price: $<%= rs.getDouble("price") %></p>
                    <form action="CartServlet" method="post">
                        <input type="hidden" name="productId" value="<%= rs.getInt("id") %>" />
                        <%
                            if (isLoggedIn) {
                        %>
                            <button type="submit" name="action" value="add">Add to Cart</button>
                            <button type="submit" name="action" value="buy">Buy Now</button>
                        <%
                            } else {
                        %>
                            <button type="button" class="btn btn-secondary" disabled title="Please login to add to cart or buy">Login to Buy</button>
                        <%
                            }
                        %>
                    </form>
                </div>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</div>

<style>
    .hero-section {
        text-align: center;
        padding: 50px;
        background-color: #f4f4f4;
    }
    .product-list {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
    }
    .product-item {
        border: 1px solid #ddd;
        padding: 20px;
        margin: 20px;
        text-align: center;
        width: 22%;
    }
    .product-item img {
        width: 150px;
        height: 150px;
    }
    .product-item button {
        margin-top: 10px;
        padding: 10px;
        background-color: #28a745;
        color: white;
        border: none;
        cursor: pointer;
    }
    .product-item button:hover {
        background-color: #218838;
    }
    .product-item .btn-secondary {
        margin-top: 10px;
    }
</style>
</body>
