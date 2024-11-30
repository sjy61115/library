<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ include file="../includes/dbConfig.jsp" %>

<%
    // 관리자 권한 확인
    String userRole = (String)session.getAttribute("role");
    if(!"admin".equals(userRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String uploadPath = application.getRealPath("/uploads");
    int maxSize = 10 * 1024 * 1024;  // 10MB

    try {
        MultipartRequest multi = new MultipartRequest(
            request,
            uploadPath,
            maxSize,
            "UTF-8",
            new DefaultFileRenamePolicy()
        );

        String isbn = multi.getParameter("isbn");
        String title = multi.getParameter("title");
        String author = multi.getParameter("author");
        String publisher = multi.getParameter("publisher");
        String category = multi.getParameter("category");
        String description = multi.getParameter("description");
        
        String sql;
        String coverImage = multi.getFilesystemName("coverImage");
        
        if(coverImage != null && !coverImage.isEmpty()) {
            sql = "UPDATE books SET title=?, author=?, publisher=?, category=?, description=?, cover_image=? WHERE isbn=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, publisher);
            pstmt.setString(4, category);
            pstmt.setString(5, description);
            pstmt.setString(6, coverImage);
            pstmt.setString(7, isbn);
        } else {
            sql = "UPDATE books SET title=?, author=?, publisher=?, category=?, description=? WHERE isbn=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, publisher);
            pstmt.setString(4, category);
            pstmt.setString(5, description);
            pstmt.setString(6, isbn);
        }
        
        int result = pstmt.executeUpdate();
        
        if(result > 0) {
            session.setAttribute("message", "도서 정보가 성공적으로 수정되었습니다.");
        } else {
            session.setAttribute("error", "도서 정보 수정에 실패했습니다.");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "오류가 발생했습니다: " + e.getMessage());
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
    
    response.sendRedirect("bookList.jsp");
%> 