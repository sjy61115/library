<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 세션에서 사용자 권한 확인
    String userRole = (String)session.getAttribute("role");
    boolean isAdmin = "admin".equals(userRole);
%>
<!DOCTYPE html>
<html>
<head>
    <title>도서 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="container mt-5">
        <h2>도서 목록</h2>
        
        <% if (session.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("message") %>
                <% session.removeAttribute("message"); %>
            </div>
        <% } %>
        
        <!-- 검색 폼 -->
        <form class="row g-3 mb-4" action="bookList.jsp" method="get">
            <div class="col-md-4">
                <input type="text" name="searchKeyword" class="form-control" 
                       placeholder="도서명 또는 저자 검색"
                       value="<%= request.getParameter("searchKeyword") != null ? 
                              request.getParameter("searchKeyword") : "" %>">
            </div>
            <div class="col-md-3">
                <select name="category" class="form-select">
                    <option value="">전체 카테고리</option>
                    <option value="novel" <%= "novel".equals(request.getParameter("category")) ? "selected" : "" %>>소설</option>
                    <option value="poetry" <%= "poetry".equals(request.getParameter("category")) ? "selected" : "" %>>시/에세이</option>
                    <option value="self" <%= "self".equals(request.getParameter("category")) ? "selected" : "" %>>자기계발</option>
                    <option value="history" <%= "history".equals(request.getParameter("category")) ? "selected" : "" %>>역사</option>
                    <option value="science" <%= "science".equals(request.getParameter("category")) ? "selected" : "" %>>과학</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">검색</button>
            </div>
        </form>

        <!-- 도서 목록 -->
        <div class="row">
            <%
            String jdbcUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
            String dbUser = "root";
            String dbPassword = "1234";
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            // 검색어와 카테고리 파라미터 받기
            String keyword = request.getParameter("keyword");
            String category = request.getParameter("category");
            
            // 검색어 전처리
            if(keyword != null) {
                keyword = keyword.trim();
            }
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                
                String sql;
                
                if(keyword != null && !keyword.isEmpty()) {
                    if("all".equals(category) || category == null) {
                        // 전체 카테고리 검색
                        sql = "SELECT * FROM books WHERE " +
                              "LOWER(title) LIKE LOWER(?) OR " +
                              "LOWER(author) LIKE LOWER(?) OR " +
                              "LOWER(publisher) LIKE LOWER(?) OR " +
                              "isbn LIKE ? " +
                              "ORDER BY title ASC";
                        pstmt = conn.prepareStatement(sql);
                        String searchKeyword = "%" + keyword + "%";
                        pstmt.setString(1, searchKeyword);
                        pstmt.setString(2, searchKeyword);
                        pstmt.setString(3, searchKeyword);
                        pstmt.setString(4, searchKeyword);
                    } else {
                        // 특정 카테고리 내 검색
                        sql = "SELECT * FROM books WHERE category = ? AND " +
                              "(LOWER(title) LIKE LOWER(?) OR " +
                              "LOWER(author) LIKE LOWER(?) OR " +
                              "LOWER(publisher) LIKE LOWER(?) OR " +
                              "isbn LIKE ?) " +
                              "ORDER BY title ASC";
                        pstmt = conn.prepareStatement(sql);
                        String searchKeyword = "%" + keyword + "%";
                        pstmt.setString(1, category);
                        pstmt.setString(2, searchKeyword);
                        pstmt.setString(3, searchKeyword);
                        pstmt.setString(4, searchKeyword);
                        pstmt.setString(5, searchKeyword);
                    }
                } else if(category != null && !"all".equals(category)) {
                    // 카테고리만 선택된 경우
                    sql = "SELECT * FROM books WHERE category = ? ORDER BY title ASC";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, category);
                } else {
                    // 아무 조건도 없는 경우
                    sql = "SELECT * FROM books ORDER BY title ASC";
                    pstmt = conn.prepareStatement(sql);
                }
                
                System.out.println("카테고리: " + category);
                System.out.println("검색어: " + keyword);
                
                rs = pstmt.executeQuery();
                
                boolean hasBooks = false;
                
                while(rs.next()) {
                    hasBooks = true;
            %>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <img src="uploads/<%= rs.getString("cover_image") %>" 
                             class="card-img-top" alt="책 표지" style="height: 300px; object-fit: cover;">
                        <div class="card-body">
                            <h5 class="card-title"><%= rs.getString("title") %></h5>
                            <p class="card-text">저자: <%= rs.getString("author") %></p>
                            <p class="card-text">장르: <%= rs.getString("category") %></p>
                            <p class="card-text">출판사: <%= rs.getString("publisher") %></p>
                            <a href="bookDetail.jsp?isbn=<%= rs.getString("isbn") %>" 
                               class="btn btn-primary">상세보기</a>
                        </div>
                    </div>
                </div>
            <%
                }
                
                if (!hasBooks) {
            %>
                <div class="col-12">
                    <p class="text-center">검색 결과가 없습니다.</p>
                </div>
            <%
                }
                
            } catch(Exception e) {
                out.println("도서 목록을 불러오는 중 오류가 발생했습니다: " + e.getMessage());
                
            } finally {
                if (rs != null) try { rs.close(); } catch(Exception e) {}
                if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                if (conn != null) try { conn.close(); } catch(Exception e) {}
            }
            %>
        </div>
        
        <div class="mt-3">
            <% if(isAdmin) { %>
                <a href="admin/addBook.jsp" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-2"></i>새 도서 등록
                </a>
            <% } %>
        </div>
    </div>
</body>
</html>