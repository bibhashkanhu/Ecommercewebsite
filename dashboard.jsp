<%@ include file="db.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7f8;
            margin: 0; padding: 20px;
        }
        h2 { color: #333; }
        .section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px; border-bottom: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
    </style>
</head>
<body>

<%
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<div class="section">
    <h2>Your Cart</h2>
    <%
    java.util.Map<Integer, Integer> cart = (java.util.Map<Integer, Integer>)session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        out.println("<p>Your cart is empty.</p>");
    } else {
        out.println("<ul>");
        double totalCart = 0;
        for (int pid : cart.keySet()) {
            PreparedStatement ps = conn.prepareStatement("SELECT name, price FROM products WHERE id = ?");
            ps.setInt(1, pid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String pname = rs.getString("name");
                double price = rs.getDouble("price");
                int quantity = cart.get(pid);
                double subtotal = price * quantity;
                totalCart += subtotal;
                out.println("<li>" + pname + " - Qty: " + quantity + " - ?" + String.format("%.2f", subtotal) + "</li>");
            }
            rs.close();
            ps.close();
        }
        out.println("</ul>");
        out.println("<p><strong>Total: ?" + String.format("%.2f", totalCart) + "</strong></p>");
    }
    %>
</div>

<div class="section">
    <h2>Your Past Orders</h2>
    <%
    PreparedStatement orderStmt = conn.prepareStatement("SELECT id, total, status FROM orders WHERE user_id = ? ORDER BY id DESC");
    orderStmt.setInt(1, userId);
    ResultSet orderRs = orderStmt.executeQuery();

    if (!orderRs.isBeforeFirst() ) { // No data
        out.println("<p>You have no previous orders.</p>");
    } else {
        out.println("<table>");
        out.println("<tr><th>Order ID</th><th>Total</th><th>Status</th></tr>");
        while(orderRs.next()){
            int oid = orderRs.getInt("id");
            double total = orderRs.getDouble("total");
            String status = orderRs.getString("status");
            out.println("<tr><td>" + oid + "</td><td>&#8377;" + String.format("%.2f", total) + "</td><td>" + status + "</td></tr>");
        }
        out.println("</table>");
    }
    orderRs.close();
    orderStmt.close();
    %>
</div>

</body>
</html>
