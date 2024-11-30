<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ include file="includes/dbConfig.jsp" %>

<%
    // 디버깅을 위한 로그 추가
    System.out.println("processAddBook.jsp 시작");
    
    String uploadPath = application.getRealPath("/uploads");
    System.out.println("업로드 경로: " + uploadPath);
    
    // uploads 폴더 생성 확인
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        boolean created = uploadDir.mkdir();
        System.out.println("uploads 폴더 생성: " + created);
    }
    
    int maxSize = 10 * 1024 * 1024;
    ResultSet generatedKeys = null;
    
    try {
        MultipartRequest multi = new MultipartRequest(
            request,
            uploadPath,
            maxSize,
            "UTF-8",
            new DefaultFileRenamePolicy()
        );
        System.out.println("파일 업로드 성공");
        
        // 폼 데이터 확인
        System.out.println("제목: " + multi.getParameter("title"));
        System.out.println("저자: " + multi.getParameter("author"));
        System.out.println("ISBN: " + multi.getParameter("isbn"));
        
        // ISBN 중복 체크
        String isbn = multi.getParameter("isbn");
        
        String checkSql = "SELECT COUNT(*) FROM books WHERE isbn = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, isbn);
        rs = pstmt.executeQuery();
        
        if (rs.next() && rs.getInt(1) > 0) {
            session.setAttribute("error", "이미 등록된 ISBN입니다: " + isbn);
            response.sendRedirect("addBook.jsp");
            return;
        }
        
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
        generatedKeys = pstmt.getGeneratedKeys();
        int bookId = 0;
        if (generatedKeys.next()) {
            bookId = generatedKeys.getInt(1);
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
        System.out.println("오류 발생: " + e.getMessage());
        e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback();
            } catch(Exception ex) {}
        }
        session.setAttribute("error", "도서 등록 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/addBook.jsp");
        
    } finally {
        if (generatedKeys != null) try { generatedKeys.close(); } catch(Exception e) {}
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