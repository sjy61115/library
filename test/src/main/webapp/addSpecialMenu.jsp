<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    // POST 요청 파라미터 받기
    request.setCharacterEncoding("UTF-8");
    String menuTitle = request.getParameter("menuTitle");
    String menuUrl = request.getParameter("menuUrl");
    int menuOrder = Integer.parseInt(request.getParameter("menuOrder"));
    String menuDescription = request.getParameter("menuDescription");
    boolean isActive = "1".equals(request.getParameter("isActive"));

    // 데이터베이스 연결 정보
    String jdbcUrl = "jdbc:mysql://localhost:3306/library";
    String dbId = "root";
    String dbPass = "1234";

    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        // JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // 데이터베이스 연결
        conn = DriverManager.getConnection(jdbcUrl, dbId, dbPass);
        
        // SQL 쿼리 준비
        String sql = "INSERT INTO special_menu (title, url, menu_order, description, is_active) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        
        // 파라미터 설정
        pstmt.setString(1, menuTitle);
        pstmt.setString(2, menuUrl);
        pstmt.setInt(3, menuOrder);
        pstmt.setString(4, menuDescription);
        pstmt.setBoolean(5, isActive);
        
        // 쿼리 실행
        pstmt.executeUpdate();
        
        // 성공 시 관리 페이지로 리다이렉트
        response.sendRedirect("manageSpecialMenu.jsp?success=true");
        
    } catch(Exception e) {
        // 오류 로깅
        e.printStackTrace();
        response.sendRedirect("manageSpecialMenu.jsp?error=true&message=" + e.getMessage());
    } finally {
        // 리소스 정리
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
