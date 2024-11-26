<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.math.BigInteger" %>
<%
    request.setCharacterEncoding("UTF-8");

    String jdbcUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
    String dbUser = "root";
    String dbPassword = "1234";
    
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // 비밀번호 해시 처리
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    md.update(password.getBytes());
    String hashedPassword = String.format("%064x", new BigInteger(1, md.digest()));
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, hashedPassword);
        
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // 로그인 성공
            session.setAttribute("loggedIn", true);
            session.setAttribute("userId", rs.getInt("id"));
            session.setAttribute("username", username);
            session.setAttribute("name", rs.getString("name"));
            session.setAttribute("role", rs.getString("role"));
            
            // 관리자인 경우 관리자 페이지로, 일반 사용자인 경우 메인 페이지로
            if ("admin".equals(rs.getString("role"))) {
                response.sendRedirect("bookList.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // 로그인 실패
            session.setAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            response.sendRedirect("login.jsp");
        }
        
    } catch(Exception e) {
        session.setAttribute("error", "로그인 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("login.jsp");
        
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 