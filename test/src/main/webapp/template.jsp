<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>${menuTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
</head>
<body>
    <%@ include file="../includes/header.jsp" %>
    <div class="container mt-5">
        <!-- 관리자용 특집 도서 추가 버튼 -->
        <% if (session.getAttribute("role") != null && session.getAttribute("role").equals("admin")) { %>
            <div class="mb-4">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addFeaturedBookModal">
                    <i class="bi bi-plus-circle"></i> 특집 도서 추가
                </button>
            </div>
            
            <!-- 특집 도서 추가 모달 -->
            <div class="modal fade" id="addFeaturedBookModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">특집 도서 추가</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form id="featuredBookForm" action="../admin/processFeaturedBook.jsp" method="post">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">도서 선택</label>
                                        <select name="bookId" class="form-select" required>
                                            <option value="">도서를 선택하세요</option>
                                            <% 
                                            try {
                                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");
                                                String bookSql = "SELECT id, title, author FROM books WHERE id NOT IN (SELECT book_id FROM featured_books)";
                                                PreparedStatement pstmt = conn.prepareStatement(bookSql);
                                                ResultSet rs = pstmt.executeQuery();
                                                while(rs.next()) {
                                            %>
                                                <option value="<%= rs.getInt("id") %>">
                                                    <%= rs.getString("title") %> - <%= rs.getString("author") %>
                                                </option>
                                            <%
                                                }
                                                rs.close();
                                                pstmt.close();
                                                conn.close();
                                            } catch(Exception e) {
                                                e.printStackTrace();
                                            }
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">특집 카테고리</label>
                                        <select name="featureCategory" class="form-select" required>
                                            <option value="">카테고리를 선택하세요</option>
                                            <% 
                                            try {
                                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");
                                                String categorySql = "SELECT id, title FROM special_menu WHERE is_active = TRUE ORDER BY menu_order";
                                                PreparedStatement pstmt = conn.prepareStatement(categorySql);
                                                ResultSet rs = pstmt.executeQuery();
                                                while(rs.next()) {
                                            %>
                                                <option value="<%= rs.getInt("id") %>">
                                                    <%= rs.getString("title") %>
                                                </option>
                                            <%
                                                }
                                                rs.close();
                                                pstmt.close();
                                                conn.close();
                                            } catch(Exception e) {
                                                e.printStackTrace();
                                            }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">특집 설명</label>
                                    <textarea name="featureDescription" class="form-control" rows="3" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">표시 순서</label>
                                    <input type="number" name="displayOrder" class="form-control" min="1" required>
                                </div>
                                <div class="text-end">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                                    <button type="submit" class="btn btn-primary">추가</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- 동적으로 삽입될 콘텐츠 영역 -->
          <% if (session.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("message") %>
                <% session.removeAttribute("message"); %>
            </div>
        <% } %>
        
        <!-- 검색 폼 -->
        <form class="row g-3 mb-4" action="" method="get">
            <div class="col-md-4">
                <input type="text" name="searchKeyword" class="form-control" 
                       placeholder="검색어를 입력하세요"
                       value="<%= request.getParameter("searchKeyword") != null ? 
                              request.getParameter("searchKeyword") : "" %>">
            </div>
            <div class="col-md-3">
                <select name="sortBy" class="form-select">
                    <option value="latest" <%= "latest".equals(request.getParameter("sortBy")) ? "selected" : "" %>>최신순</option>
                    <option value="popular" <%= "popular".equals(request.getParameter("sortBy")) ? "selected" : "" %>>인기순</option>
                    <option value="title" <%= "title".equals(request.getParameter("sortBy")) ? "selected" : "" %>>제목순</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">검색</button>
            </div>
        </form>

        <!-- 특집 도서 목록 -->
        <div class="row row-cols-1 row-cols-md-4 g-4">
            <% 
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");
                
                String searchKeyword = request.getParameter("searchKeyword");
                String sortBy = request.getParameter("sortBy");
                
                StringBuilder query = new StringBuilder("SELECT * FROM featured_books WHERE 1=1");
                
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    query.append(" AND (title LIKE ? OR author LIKE ? OR description LIKE ?)");
                }
                
                if (sortBy != null) {
                    switch(sortBy) {
                        case "latest": query.append(" ORDER BY publish_date DESC"); break;
                        case "popular": query.append(" ORDER BY view_count DESC"); break;
                        case "title": query.append(" ORDER BY title ASC"); break;
                    }
                }
                
                PreparedStatement pstmt = conn.prepareStatement(query.toString());
                
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    pstmt.setString(1, "%" + searchKeyword + "%");
                    pstmt.setString(2, "%" + searchKeyword + "%");
                    pstmt.setString(3, "%" + searchKeyword + "%");
                }
                
                ResultSet rs = pstmt.executeQuery();
                
                while(rs.next()) {
            %>
                <div class="col">
                    <div class="card h-100">
                        <img src="<%= rs.getString("image_url") %>" class="card-img-top" alt="<%= rs.getString("title") %>">
                        <div class="card-body">
                            <h5 class="card-title"><%= rs.getString("title") %></h5>
                            <p class="card-text">저자: <%= rs.getString("author") %></p>
                            <p class="card-text"><small class="text-muted">출판일: <%= rs.getDate("publish_date") %></small></p>
                            <p class="card-text text-truncate"><%= rs.getString("description") %></p>
                            <div class="d-flex justify-content-between align-items-center">
                                <a href="bookDetail.jsp?id=<%= rs.getInt("id") %>" class="btn btn-outline-primary">자세히 보기</a>
                                <% if (session.getAttribute("role") != null && session.getAttribute("role").equals("admin")) { %>
                                    <form action="admin/removeFeaturedBook.jsp" method="post" style="display: inline;">
                                        <input type="hidden" name="bookId" value="<%= rs.getInt("id") %>">
                                        <button type="submit" class="btn btn-outline-danger btn-sm" 
                                                onclick="return confirm('이 특집 도서를 제거하시겠습니까?')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                <% } %>
                                <small class="text-muted">
                                    <i class="bi bi-eye"></i> <%= rs.getInt("view_count") %>
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            <%
                }
                rs.close();
                pstmt.close();
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
            %>
        </div>

    </div>
    <%@ include file="../includes/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
