<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// 관리자 권한 체크
if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
    response.sendRedirect("../login.jsp");
    return;
}

request.setCharacterEncoding("UTF-8");

int bookId = Integer.parseInt(request.getParameter("bookId"));
String featureCategory = request.getParameter("featureCategory");
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
String featureDescription = request.getParameter("featureDescription");
int displayOrder = Integer.parseInt(request.getParameter("displayOrder"));

try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");
    
    String sql = "INSERT INTO featured_books (book_id, feature_category, feature_start_date, feature_end_date, " +
                 "feature_description, display_order) VALUES (?, ?, ?, ?, ?, ?)";
    
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, bookId);
    pstmt.setString(2, featureCategory);
    pstmt.setString(3, startDate);
    pstmt.setString(4, endDate);
    pstmt.setString(5, featureDescription);
    pstmt.setInt(6, displayOrder);
    
    pstmt.executeUpdate();
    
    pstmt.close();
    conn.close();
    
    session.setAttribute("message", "특집 도서가 성공적으로 추가되었습니다.");
    
} catch(Exception e) {
    session.setAttribute("message", "오류가 발생했습니다: " + e.getMessage());
    e.printStackTrace();
}

response.sendRedirect("manageFeaturedBooks.jsp");
%> 