<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    
    String menuId = request.getParameter("menuId");
    String title = request.getParameter("menuTitle");
    String content = request.getParameter("pageContent");
    String menuOrder = request.getParameter("menuOrder");
    String description = request.getParameter("menuDescription");
    boolean isActive = "1".equals(request.getParameter("isActive"));
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/library_db",
            "root",
            "1234"
        );
        
        String sql = "UPDATE special_menu SET title=?, content=?, menu_order=?, description=?, is_active=? WHERE id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, menuOrder);
        pstmt.setString(4, description);
        pstmt.setBoolean(5, isActive);
        pstmt.setString(6, menuId);
        
        pstmt.executeUpdate();
        response.sendRedirect("manageSpecialMenu.jsp?success=true");
        
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageSpecialMenu.jsp?error=true&message=" + e.getMessage());
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 