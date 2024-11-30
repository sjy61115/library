<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    int specialPageId = Integer.parseInt(request.getParameter("specialPageId"));
    int bookId = Integer.parseInt(request.getParameter("bookId"));
    String description = request.getParameter("description");
    int displayOrder = Integer.parseInt(request.getParameter("displayOrder"));
    
    String insertSql = "INSERT INTO featured_books (special_page_id, book_id, description, display_order) VALUES (?, ?, ?, ?)";
    
    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
        insertStmt.setInt(1, specialPageId);
        insertStmt.setInt(2, bookId);
        insertStmt.setString(3, description);
        insertStmt.setInt(4, displayOrder);
        
        int result = insertStmt.executeUpdate();
        
        if(result > 0) {
            session.setAttribute("message", "특집 도서가 성공적으로 추가되었습니다.");
        } else {
            session.setAttribute("error", "특집 도서 추가에 실패했습니다.");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "오류가 발생했습니다: " + e.getMessage());
    }
    
    response.sendRedirect("editSpecialMenu.jsp?id=" + specialPageId);
%> 