<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 관리자 권한 확인
    String userRole = (String)session.getAttribute("role");
    if(!"admin".equals(userRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String isbn = request.getParameter("isbn");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");
        conn.setAutoCommit(false); // 트랜잭션 시작
        
        // 1. book_id 조회
        String selectSql = "SELECT id FROM books WHERE isbn = ?";
        pstmt = conn.prepareStatement(selectSql);
        pstmt.setString(1, isbn);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            int bookId = rs.getInt("id");
            
            // 2. 먼저 famous_quotes 테이블에서 관련 데이터 삭제
            String deleteQuotesSql = "DELETE FROM famous_quotes WHERE book_id = ?";
            pstmt = conn.prepareStatement(deleteQuotesSql);
            pstmt.setInt(1, bookId);
            pstmt.executeUpdate();
            
            // 3. books 테이블에서 도서 삭제
            String deleteBookSql = "DELETE FROM books WHERE id = ?";
            pstmt = conn.prepareStatement(deleteBookSql);
            pstmt.setInt(1, bookId);
            pstmt.executeUpdate();
        }
        
        conn.commit(); // 트랜잭션 커밋
        session.setAttribute("message", "도서가 성공적으로 삭제되었습니다.");
        response.sendRedirect("../bookList.jsp");
        
    } catch(Exception e) {
        if (conn != null) {
            try {
                conn.rollback(); // 오류 발생 시 롤백
            } catch(Exception ex) {}
        }
        session.setAttribute("error", "도서 삭제 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("../bookDetail.jsp?isbn=" + isbn);
        
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) {
            try {
                conn.setAutoCommit(true); // 자동 커밋 모드 복원
                conn.close();
            } catch(Exception e) {}
        }
    }
%> 