<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
// 디버깅을 위한 출력
System.out.println("=== 리뷰 삭제 처리 시작 ===");

// 세션 체크
int userId = session.getAttribute("userId") != null ? (Integer)session.getAttribute("userId") : 0;
System.out.println("현재 로그인한 사용자 ID: " + userId);

if(userId == 0) {
    response.sendRedirect("login.jsp");
    return;
}

String jdbcUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
String dbUser = "root";
String dbPassword = "1234";

Connection conn = null;
PreparedStatement pstmt = null;

try {
    // 리뷰 ID와 ISBN 파라미터 받기
    int reviewId = Integer.parseInt(request.getParameter("reviewId"));
    String isbn = request.getParameter("isbn");
    
    System.out.println("삭제할 리뷰 ID: " + reviewId);
    System.out.println("도서 ISBN: " + isbn);
    
    // DB 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
    
    // 리뷰 삭제 쿼리 수정 - id를 review_id로 변경
    String deleteSql = "DELETE FROM book_reviews WHERE review_id = ? AND user_id = ?";
    pstmt = conn.prepareStatement(deleteSql);
    pstmt.setInt(1, reviewId);
    pstmt.setInt(2, userId);
    
    int result = pstmt.executeUpdate();
    System.out.println("삭제 결과: " + result);
    
    if(result > 0) {
        response.sendRedirect("bookDetail.jsp?isbn=" + isbn);
    } else {
        %>
        <script>
            alert("리뷰 삭제에 실패했습니다.");
            location.href = "bookDetail.jsp?isbn=<%= isbn %>";
        </script>
        <%
    }
    
} catch(Exception e) {
    System.out.println("오류 발생: " + e.getMessage());
    e.printStackTrace();
    %>
    <script>
        alert("리뷰 삭제 중 오류가 발생했습니다.");
        history.back();
    </script>
    <%
} finally {
    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if (conn != null) try { conn.close(); } catch(Exception e) {}
}
%> 