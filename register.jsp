<%@ include file="db.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
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
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            padding: 10px 12px;
            margin-bottom: 18px;
            border: 1.5px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus,
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
        .success {
            background-color: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
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
    <h2>User Registration</h2>

    <%
    if(request.getParameter("submit") != null){
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        // Basic validation
        if(name == null || name.isEmpty() || email == null || email.isEmpty() || pass == null || pass.isEmpty()){
            out.println("<div class='message error'>Please fill all fields properly.</div>");
        } else {
            try {
                // Check if email already exists
                PreparedStatement checkPs = conn.prepareStatement("SELECT id FROM users WHERE email=?");
                checkPs.setString(1, email);
                ResultSet checkRs = checkPs.executeQuery();
                if(checkRs.next()){
                    out.println("<div class='message error'>Email already registered.</div>");
                } else {
                    PreparedStatement ps = conn.prepareStatement("INSERT INTO users(name,email,password) VALUES(?,?,?)");
                    ps.setString(1, name);
                    ps.setString(2, email);
                    ps.setString(3, pass);  // Plain text password
                    ps.executeUpdate();
                    out.println("<div class='message success'>Registered Successfully! Please <a href='login.jsp'>Login</a></div>");
                }
                checkRs.close();
                checkPs.close();
            } catch(Exception e) {
                out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
            }
        }
    }
    %>

    <form method="post" action="register.jsp">
        <label for="name">Name</label>
        <input type="text" id="name" name="name" required placeholder="Enter your full name">

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required placeholder="Enter your email address">

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required placeholder="Enter a password">

        <input type="submit" name="submit" value="Register">
    </form>
</div>

</body>
</html>
