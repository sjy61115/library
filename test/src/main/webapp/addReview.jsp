<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 로그인 체크
    if(session.getAttribute("userId") == null) {
        session.setAttribute("error", "리뷰를 작성하려면 로그인이 필요합니다.");
        response.sendRedirect("login.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String isbn = request.getParameter("isbn");
    int rating = Integer.parseInt(request.getParameter("rating"));
    String content = request.getParameter("content");
    int userId = (Integer)session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8",
            "root", "1234"
        );

        // book_id 조회
        String bookSql = "SELECT id FROM books WHERE isbn = ?";
        pstmt = conn.prepareStatement(bookSql);
        pstmt.setString(1, isbn);
        rs = pstmt.executeQuery();

        if(rs.next()) {
            int bookId = rs.getInt("id");

            // 이미 리뷰를 작성했는지 확인
            String checkSql = "SELECT review_id FROM book_reviews WHERE book_id = ? AND user_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, bookId);
            pstmt.setInt(2, userId);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                session.setAttribute("error", "이미 이 도서에 대한 리뷰를 작성하셨습니다.");
            } else {
                // 리뷰 저장
                String insertSql = "INSERT INTO book_reviews (book_id, user_id, rating, content) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertSql);
                pstmt.setInt(1, bookId);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, rating);
                pstmt.setString(4, content);
                pstmt.executeUpdate();

                session.setAttribute("message", "리뷰가 성공적으로 등록되었습니다.");
            }
        }

        response.sendRedirect("bookDetail.jsp?isbn=" + isbn);

    } catch(Exception e) {
        session.setAttribute("error", "리뷰 등록 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("bookDetail.jsp?isbn=" + isbn);
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 