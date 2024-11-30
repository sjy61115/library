<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul";
        String username = "root";
        String password = "1234";
        
        conn = DriverManager.getConnection(url, username, password);
    } catch(Exception e) {
        out.println("<div class='alert alert-danger'>데이터베이스 연결 오류: " + e.getMessage() + "</div>");
    }
%> 