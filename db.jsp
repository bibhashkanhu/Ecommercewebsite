<%@ page import="java.sql.*" %>
<%
  String dburl = "jdbc:mysql://localhost:3306/adjava_project";
  String username = "root";
  String password = "Sai@2006";
  Class.forName("com.mysql.cj.jdbc.Driver");
  Connection conn = DriverManager.getConnection(dburl, username, password);
%>
