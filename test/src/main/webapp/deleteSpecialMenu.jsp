<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    
    if(idStr != null && !idStr.trim().isEmpty()) {
        try {
            int id = Integer.parseInt(idStr);
            String sql = "DELETE FROM special_pages WHERE id = ?";
            
            try (PreparedStatement deleteStmt = conn.prepareStatement(sql)) {
                deleteStmt.setInt(1, id);
                int result = deleteStmt.executeUpdate();
                
                if(result > 0) {
                    session.setAttribute("message", "특집 페이지가 성공적으로 삭제되었습니다.");
                } else {
                    session.setAttribute("error", "특집 페이지를 찾을 수 없습니다.");
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "삭제 중 오류가 발생했습니다: " + e.getMessage());
        }
    } else {
        session.setAttribute("error", "잘못된 요청입니다.");
    }
    
    response.sendRedirect("manageSpecialMenu.jsp");
%> 