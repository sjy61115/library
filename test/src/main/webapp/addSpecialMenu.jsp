<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String menuTitle = request.getParameter("menuTitle");
    String pageContent = request.getParameter("pageContent");
    int menuOrder = Integer.parseInt(request.getParameter("menuOrder"));
    int isActive = Integer.parseInt(request.getParameter("isActive"));
    
    String sql = "INSERT INTO special_pages (menu_title, page_content, menu_order, is_active) VALUES (?, ?, ?, ?)";
    
    try (PreparedStatement specialMenuStmt = conn.prepareStatement(sql)) {
        specialMenuStmt.setString(1, menuTitle);
        specialMenuStmt.setString(2, pageContent);
        specialMenuStmt.setInt(3, menuOrder);
        specialMenuStmt.setInt(4, isActive);
        
        int result = specialMenuStmt.executeUpdate();
        
        if(result > 0) {
            session.setAttribute("message", "특집 페이지가 성공적으로 추가되었습니다.");
        } else {
            session.setAttribute("error", "특집 페이지 추가에 실패했습니다.");
        }
        response.sendRedirect("manageSpecialMenu.jsp");
        
    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("manageSpecialMenu.jsp");
    }
%>
