<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String id = request.getParameter("id");
    if(id == null || id.trim().isEmpty()) {
        response.sendRedirect("manageSpecialMenu.jsp");
        return;
    }
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8",
            "root", "1234"
        );
        
        // 파일 경로 조회
        String sql = "SELECT url FROM special_menu WHERE id=?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        ResultSet rs = pstmt.executeQuery();
        
        if(rs.next()) {
            // 파일 삭제
            String fileName = rs.getString("url");
            String realPath = application.getRealPath("/");
            File file = new File(realPath + fileName);
            if(file.exists()) {
                file.delete();
            }
        }
        
        // DB에서 삭제
        sql = "DELETE FROM special_menu WHERE id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        pstmt.executeUpdate();
        
        response.sendRedirect("manageSpecialMenu.jsp?success=true");
        
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageSpecialMenu.jsp?error=true&message=" + 
                            java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    }
%> 