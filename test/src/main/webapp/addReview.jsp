<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/dbConfig.jsp" %>
<%
    // 로그인 체크
    if(session.getAttribute("userId") == null) {
        session.setAttribute("error", "리뷰를 작성하려면 로그인이 필요합니다.");
        response.sendRedirect("login.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String isbn = request.getParameter("isbn");
    int bookId = Integer.parseInt(request.getParameter("book_id"));
    int rating = Integer.parseInt(request.getParameter("rating"));
    String content = request.getParameter("content");
    int userId = Integer.parseInt(session.getAttribute("userId").toString());

    try {
        conn.setAutoCommit(false); // 트랜잭션 시작
        
        // 리뷰 저장
        String insertSql = "INSERT INTO book_reviews (book_id, user_id, rating, content, created_at) VALUES (?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setInt(1, bookId);
        pstmt.setInt(2, userId);
        pstmt.setInt(3, rating);
        pstmt.setString(4, content);
        int result = pstmt.executeUpdate();
        
        if(result > 0) {
            conn.commit();
            session.setAttribute("message", "리뷰가 성공적으로 등록되었습니다.");
        } else {
            conn.rollback();
            session.setAttribute("error", "리뷰 등록에 실패했습니다.");
        }

        response.sendRedirect("bookDetail.jsp?isbn=" + isbn);

    } catch(Exception e) {
        if(conn != null) try { conn.rollback(); } catch(Exception ex) {}
        e.printStackTrace();
        session.setAttribute("error", "리뷰 등록 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("bookDetail.jsp?isbn=" + isbn);
    } finally {
        if(conn != null) try { conn.setAutoCommit(true); } catch(Exception e) {}
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 