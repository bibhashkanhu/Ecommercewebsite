<%@ include file="db.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7f8;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .cart-container {
            background: white;
            padding: 30px 40px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            width: 400px;
            text-align: center;
        }
        h1 {
            margin-bottom: 25px;
            color: #333;
            font-weight: 700;
        }
        .item {
            font-size: 18px;
            margin-bottom: 15px;
            color: #555;
        }
        .total {
            font-weight: 700;
            font-size: 20px;
            margin-top: 20px;
            color: #222;
            border-top: 1px solid #ddd;
            padding-top: 15px;
        }
        a.checkout-btn {
            display: inline-block;
            background: #007BFF;
            color: white;
            padding: 12px 25px;
            margin-top: 25px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: background 0.3s;
        }
        a.checkout-btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

<div class="cart-container">
    <h1>Your Shopping Cart</h1>
    <%
    java.util.Map<Integer, Integer> cart = (java.util.Map<Integer, Integer>)session.getAttribute("cart");
    if(cart == null || cart.isEmpty()){
        out.println("<p>Your cart is empty.</p>");
    } else {
        double total = 0;
        for(int pid : cart.keySet()){
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id=?");
            ps.setInt(1, pid);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                double price = rs.getDouble("price");
                int qty = cart.get(pid);
                total += price * qty;
    %>
                <div class="item">
                    <%=rs.getString("name")%> - Qty: <%=qty%> - &#8377;<%=String.format("%.2f",price * qty)%>
                </div>
    <%
            }
            rs.close();
            ps.close();
        }
    %>
    <div class="total">Total: &#8377;<%=String.format("%.2f", total)%></div>
    <a href="checkout.jsp" class="checkout-btn">Proceed to Checkout</a>
    <%
    }
    %>
</div>

</body>
</html>
