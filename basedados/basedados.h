<%@ page import="java.sql.*" %>
<%
Connection conn = null;
try {
    // Try different MySQL drivers
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e1) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e2) {
            throw new ServletException("MySQL JDBC Driver not found. Please add mysql-connector-java.jar to WEB-INF/lib/");
        }
    }

    // Connection string with additional parameters for compatibility
    String url = "jdbc:mysql://localhost:3306/felixbus?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    conn = DriverManager.getConnection(url, "root", "");

} catch (SQLException e) {
    throw new ServletException("Database connection failed: " + e.getMessage() + ". Please check if MySQL server is running and database 'felixbus' exists.");
} catch (Exception e) {
    throw new ServletException("Connection failed: " + e.getMessage());
}
%>