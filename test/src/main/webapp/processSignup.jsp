<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.math.BigInteger" %>
<%
    request.setCharacterEncoding("UTF-8");

    String jdbcUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
    String dbUser = "root";
    String dbPassword = "1234";
    
    // 사용자 입력값 받기
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    
    // 비밀번호 해시 처리
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    md.update(password.getBytes());
    String hashedPassword = String.format("%064x", new BigInteger(1, md.digest()));
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        
        String sql = "INSERT INTO users (username, password, name, email, phone) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, username);
        pstmt.setString(2, hashedPassword);
        pstmt.setString(3, name);
        pstmt.setString(4, email);
        pstmt.setString(5, phone);
        
        pstmt.executeUpdate();
        
        session.setAttribute("message", "회원가입이 완료되었습니다. 로그인해주세요.");
        response.sendRedirect("login.jsp");
        
    } catch(Exception e) {
        session.setAttribute("error", "회원가입 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("signup.jsp");
        
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 