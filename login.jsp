<%@ include file="db.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Login</title>
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
            padding: 30px 40px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            width: 360px;
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
            font-weight: 700;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-bottom: 6px;
            font-weight: 600;
            color: #555;
        }
        input[type="email"],
        input[type="password"] {
            padding: 10px 12px;
            margin-bottom: 18px;
            border: 1.5px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: #007BFF;
            outline: none;
        }
        input[type="submit"] {
            background: #007BFF;
            border: none;
            padding: 12px;
            color: white;
            font-weight: 700;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background: #0056b3;
        }
        .message {
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 4px;
        }
        .error {
            background-color: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }
        a {
            color: #007BFF;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>User Login</h2>
    <%
    if(request.getParameter("submit") != null){
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        if(email == null || email.isEmpty() || pass == null || pass.isEmpty()){
            out.println("<div class='message error'>Please enter both email and password.</div>");
        } else {
            try {
                PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE email=? AND password=?");
                ps.setString(1, email);
                ps.setString(2, pass);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    session.setAttribute("userId", rs.getInt("id"));
                    response.sendRedirect("dashboard.jsp");
                    return;
                } else {
                    out.println("<div class='message error'>Invalid email or password.</div>");
                }
                rs.close();
                ps.close();
            } catch(Exception e){
                out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
            }
        }
    }
    %>
    <form method="post" action="login.jsp">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" required placeholder="Enter your email">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required placeholder="Enter your password">
        <input type="submit" name="submit" value="Login">
    </form>
</div>
</body>
</html>
