<%@ include file="db.jsp" %>
<%
if(session.getAttribute("userId") == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Products</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7f8;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .products {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .product-card {
            background: #fff;
            border: 1.5px solid #ddd;
            border-radius: 6px;
            width: 220px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
            transition: box-shadow 0.3s;
        }
        .product-card:hover {
            box-shadow: 0 5px 12px rgba(0,0,0,0.15);
        }
        .product-name {
            font-weight: 700;
            margin-bottom: 10px;
            color: #007BFF;
        }
        .product-price {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
        }
        .add-to-cart {
            background: #007BFF;
            border: none;
            padding: 10px 14px;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .add-to-cart:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Available Products</h2>
    <div class="products">
        <%
            try {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM products");

                while(rs.next()) {
        %>
                    <div class="product-card">
                        <div class="product-name"><%= rs.getString("name") %></div>
                        <div class="product-price">&#8377; <%= rs.getDouble("price") %></div>
                        <a href="cart.jsp?add=<%= rs.getInt("id") %>" class="add-to-cart">Add to Cart</a>
                    </div>
        <%
                }
                rs.close();
                st.close();
            } catch(Exception e) {
                out.println("<p style='color:red'>Failed to load products.</p>");
            }
        %>
    </div>
</div>

</body>
</html>
