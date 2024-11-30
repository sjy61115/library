<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    int specialPageId = Integer.parseInt(request.getParameter("specialPageId"));
    String[] selectedBooks = request.getParameterValues("selectedBooks");
    String[] descriptions = request.getParameterValues("descriptions");
    
    try {
        // 기존 특집 도서 모두 삭제
        String deleteSql = "DELETE FROM featured_books WHERE special_page_id = ?";
        try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
            deleteStmt.setInt(1, specialPageId);
            deleteStmt.executeUpdate();
        }
        
        // 선택된 도서 추가
        if (selectedBooks != null && selectedBooks.length > 0) {
            String insertSql = "INSERT INTO featured_books (special_page_id, book_id, description, display_order) VALUES (?, ?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                for (int i = 0; i < selectedBooks.length; i++) {
                    insertStmt.setInt(1, specialPageId);
                    insertStmt.setInt(2, Integer.parseInt(selectedBooks[i]));
                    insertStmt.setString(3, descriptions != null ? descriptions[i] : "");
                    insertStmt.setInt(4, i + 1);
                    insertStmt.executeUpdate();
                }
            }
        }
        
        session.setAttribute("message", "특집 도서가 성공적으로 업데이트되었습니다.");
        
    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "오류가 발생했습니다: " + e.getMessage());
    }
    
    response.sendRedirect("manageFeaturedBooks.jsp?id=" + specialPageId);
%> 