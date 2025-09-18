<%@ include file="db.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: white;
            padding: 40px 50px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            width: 380px;
            text-align: center;
        }
        h2 {
            color: #333;
        }
        p {
            font-size: 16px;
            margin-top: 20px;
            color: #555;
        }
        .errorMsg {
            color: #842029;
            background: #f8d7da;
            padding: 12px;
            border-radius: 5px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
<div class="container">
<%
if(session.getAttribute("userId") == null){
  response.sendRedirect("login.jsp");
  return;
}

java.util.Map<Integer, Integer> cart = (java.util.Map<Integer, Integer>) session.getAttribute("cart");

if(cart != null && !cart.isEmpty()){
   int uid = (int) session.getAttribute("userId");
   double total = 0;
   conn.setAutoCommit(false);
   try {
       for (int pid : cart.keySet()) {
           PreparedStatement ps = conn.prepareStatement("SELECT price FROM products WHERE id=?");
           ps.setInt(1, pid);
           ResultSet rs = ps.executeQuery();
           if (rs.next()) {
               total += rs.getDouble(1) * cart.get(pid);
           }
           rs.close();
           ps.close();
       }

       PreparedStatement orderPs = conn.prepareStatement(
               "INSERT INTO orders(user_id,total,status) VALUES(?,?,?)", Statement.RETURN_GENERATED_KEYS);
       orderPs.setInt(1, uid);
       orderPs.setDouble(2, total);
       orderPs.setString(3, "Pending");
       orderPs.executeUpdate();

       ResultSet ors = orderPs.getGeneratedKeys();
       ors.next();
       int orderId = ors.getInt(1);

       for (int pid : cart.keySet()) {
           int qty = cart.get(pid);
           PreparedStatement itemPs = conn.prepareStatement(
                   "INSERT INTO order_items(order_id, product_id, quantity) VALUES(?,?,?)");
           itemPs.setInt(1, orderId);
           itemPs.setInt(2, pid);
           itemPs.setInt(3, qty);
           itemPs.executeUpdate();
           itemPs.close();
       }

       conn.commit();
       session.removeAttribute("cart");
%>
    <h2>Order placed!</h2>
    <p>Your Order ID is: <strong><%= orderId %></strong></p>
    <p>Thank you for shopping with us.</p>
<%
   } catch (Exception e) {
       conn.rollback();
       out.println("<div class='errorMsg'>Failed to place order. Error: " + e.getMessage() + "</div>");
       e.printStackTrace();
   } finally {
       conn.setAutoCommit(true);
   }
} else {
%>
    <p>Your cart is empty.</p>
<%
}
%>
</div>
</body>
</html>
