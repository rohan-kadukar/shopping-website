<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="connect.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.jsp.JspWriter" %>

<html>
<head>
    <title>Your Cart</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .cart-header {
            margin: 20px 0;
            text-align: center; /* Center the header */
        }
        .cart-item {
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 15px;
            background-color: white;
            margin-bottom: 15px;
            transition: box-shadow 0.2s;
            height: auto; /* Adjust height to fit content */
        }
        .cart-item:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .cart-image {
            width: 100%;
            height: 150px; /* Fixed height for images */
            object-fit: cover; /* Maintain aspect ratio */
            border-radius: 8px;
        }
        .cart-item-details {
            text-align: center; /* Centered text for item details */
        }
        .btn-container {
            display: flex;
            justify-content: center; /* Center buttons */
            gap: 10px; /* Space between buttons */
            margin-top: 15px; /* Spacing above buttons */
        }
        .btn {
            flex: 1; /* Make buttons take equal width */
        }
        @media (max-width: 576px) {
            .cart-item {
                margin-bottom: 10px; /* Reduce spacing on smaller screens */
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="cart-header">
        <h2>Your Cart</h2>
    </div>

    <%
//        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            out.println("<p>You are not logged in. Please <a href='login.jsp'>login</a> to see your cart.</p>");
        } else {
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                con = DBConnection.getConnection();
                String sql = "SELECT products.id, products.name, products.price, products.image, cart_items.quantity " +
                             "FROM cart_items " +
                             "JOIN products ON cart_items.product_id = products.id " +
                             "WHERE cart_items.user_id = ?";
                stmt = con.prepareStatement(sql);
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>Your cart is empty.</p>");
                } else {
                    %>
                    <div class="row">
                    <% while (rs.next()) {
                        String productId = rs.getString("id");
                        String productName = rs.getString("name");
                        double productPrice = rs.getDouble("price");
                        String productImage = rs.getString("image");
                        int quantity = rs.getInt("quantity");
                        double itemTotalPrice = productPrice * quantity; // Calculate total price for the item
                    %>
                        <div class="col-md-4 mb-3"> <!-- Added margin bottom for spacing between items -->
                            <div class="cart-item">
                                <img src="product-images/<%= productImage %>" alt="<%= productName %>" class="cart-image"/>
                                <div class="cart-item-details">
                                    <h5><%= productName %></h5>
                                    <p>Quantity: <%= quantity %></p>
                                    <p>Price: $<%= productPrice %> each</p>
                                    <p><strong>Total: $<%= itemTotalPrice %></strong></p>
                                    <div class="btn-container">
                                        <form action="CartServlet" method="post" class="remove-button">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="productId" value="<%= productId %>">
                                            <button type="submit" class="btn btn-danger">Remove</button>
                                        </form>
                                        <form action="CartServlet" method="post">
                                            <input type="hidden" name="action" value="buy">
                                            <input type="hidden" name="productId" value="<%= productId %>">
                                            <button type="submit" class="btn btn-primary">Proceed to Checkout</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    </div>
    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error retrieving cart items. Please try again later.</p>");
            } finally {
                // Safely close resources
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    %>
</div>
</body>
</html>
