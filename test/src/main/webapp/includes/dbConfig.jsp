<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String url = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
    String username = "root";
    String password = "1234";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch(Exception e) {
        e.printStackTrace();
    }
%> 