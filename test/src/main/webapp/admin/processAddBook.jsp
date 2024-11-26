<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
    String dbUser = "root";
    String dbPassword = "1234";
    
    String uploadPath = application.getRealPath("/uploads");
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdir();
    }
    
    int maxSize = 10 * 1024 * 1024;
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        MultipartRequest multi = new MultipartRequest(
            request,
            uploadPath,
            maxSize,
            "UTF-8",
            new DefaultFileRenamePolicy()
        );
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        conn.setAutoCommit(false);
        
        // 1. 도서 정보 입력
        String bookSql = "INSERT INTO books (title, author, isbn, publisher, publish_date, " +
                    "category, cover_image, description, contents) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        pstmt = conn.prepareStatement(bookSql, Statement.RETURN_GENERATED_KEYS);
        
        pstmt.setString(1, multi.getParameter("title"));
        pstmt.setString(2, multi.getParameter("author"));
        pstmt.setString(3, multi.getParameter("isbn"));
        pstmt.setString(4, multi.getParameter("publisher"));
        pstmt.setString(5, multi.getParameter("publishDate"));
        pstmt.setString(6, multi.getParameter("category"));
        pstmt.setString(7, multi.getFilesystemName("coverImage"));
        pstmt.setString(8, multi.getParameter("description"));
        pstmt.setString(9, multi.getParameter("contents"));
        
        pstmt.executeUpdate();
        
        // 생성된 book_id 가져오기
        rs = pstmt.getGeneratedKeys();
        int bookId = 0;
        if (rs.next()) {
            bookId = rs.getInt(1);
        }
        
        // 2. 명문장 정보 입력
        String originalText = multi.getParameter("originalText");
        if (originalText != null && !originalText.trim().isEmpty()) {
            String quoteSql = "INSERT INTO famous_quotes (book_id, original_text, translated_text, " +
                            "page_number, scene_description) VALUES (?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(quoteSql);
            pstmt.setInt(1, bookId);
            pstmt.setString(2, originalText);
            pstmt.setString(3, multi.getParameter("translatedText"));
            
            String pageNumber = multi.getParameter("pageNumber");
            if (pageNumber != null && !pageNumber.trim().isEmpty()) {
                pstmt.setInt(4, Integer.parseInt(pageNumber));
            } else {
                pstmt.setNull(4, Types.INTEGER);
            }
            
            pstmt.setString(5, multi.getParameter("sceneDescription"));
            pstmt.executeUpdate();
        }
        
        conn.commit();
        session.setAttribute("message", "도서가 성공적으로 등록되었습니다.");
        response.sendRedirect(request.getContextPath() + "/bookList.jsp");
        
    } catch(Exception e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch(Exception ex) {}
        }
        session.setAttribute("error", "도서 등록 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/admin/addBook.jsp");
        
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch(Exception e) {}
        }
    }
%> 