<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    // 로그인 체크
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String isbn = request.getParameter("isbn");
    int reviewId = Integer.parseInt(request.getParameter("review_id"));
    int userId = Integer.parseInt(session.getAttribute("userId").toString());
    String userRole = (String)session.getAttribute("role");
    boolean isAdmin = "admin".equals(userRole);

    try {
        conn.setAutoCommit(false); // 트랜잭션 시작
        
        // 리뷰 작성자 또는 관리자 확인
        String checkSql = "SELECT user_id FROM book_reviews WHERE review_id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, reviewId);
        rs = pstmt.executeQuery();

        if(rs.next() && (rs.getInt("user_id") == userId || isAdmin)) {
            // 리뷰 삭제
            String deleteSql = "DELETE FROM book_reviews WHERE review_id = ?";
            pstmt = conn.prepareStatement(deleteSql);
            pstmt.setInt(1, reviewId);
            int result = pstmt.executeUpdate();

            if(result > 0) {
                conn.commit();
                session.setAttribute("message", "리뷰가 성공적으로 삭제되었습니다.");
            } else {
                conn.rollback();
                session.setAttribute("error", "리뷰 삭제에 실패했습니다.");
            }
        } else {
            conn.rollback();
            session.setAttribute("error", "리뷰를 삭제할 권한이 없습니다.");
        }

    } catch(Exception e) {
        if(conn != null) try { conn.rollback(); } catch(Exception ex) {}
        e.printStackTrace();
        session.setAttribute("error", "리뷰 삭제 중 오류가 발생했습니다: " + e.getMessage());
    } finally {
        if(conn != null) try { conn.setAutoCommit(true); } catch(Exception e) {}
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
    
    response.sendRedirect("bookDetail.jsp?isbn=" + isbn);
%> 