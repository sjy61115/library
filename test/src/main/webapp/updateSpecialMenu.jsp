<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String idStr = request.getParameter("id");
    String menuTitle = request.getParameter("menuTitle");
    String pageContent = request.getParameter("pageContent");
    int menuOrder = Integer.parseInt(request.getParameter("menuOrder"));
    int isActive = Integer.parseInt(request.getParameter("isActive"));
    
    String sql = "UPDATE special_pages SET menu_title=?, page_content=?, menu_order=?, is_active=? WHERE id=?";
    
    try (PreparedStatement updateStmt = conn.prepareStatement(sql)) {
        updateStmt.setString(1, menuTitle);
        updateStmt.setString(2, pageContent);
        updateStmt.setInt(3, menuOrder);
        updateStmt.setInt(4, isActive);
        updateStmt.setInt(5, Integer.parseInt(idStr));
        
        int result = updateStmt.executeUpdate();
        
        if(result > 0) {
            session.setAttribute("message", "특집 페이지가 성공적으로 수정되었습니다.");
        } else {
            session.setAttribute("error", "특집 페이지 수정에 실패했습니다.");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "오류가 발생했습니다: " + e.getMessage());
    }
    
    response.sendRedirect("manageSpecialMenu.jsp");
%> 