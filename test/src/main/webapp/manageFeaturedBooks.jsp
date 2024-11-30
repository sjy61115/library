<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String specialPageId = request.getParameter("id");
    if(specialPageId == null) {
        response.sendRedirect("manageSpecialMenu.jsp");
        return;
    }

    // 특집 페이지 정보 조회
    String pageTitle = "";
    String titleSql = "SELECT menu_title FROM special_pages WHERE id = ?";
    try (PreparedStatement titleStmt = conn.prepareStatement(titleSql)) {
        titleStmt.setInt(1, Integer.parseInt(specialPageId));
        ResultSet titleRs = titleStmt.executeQuery();
        if(titleRs.next()) {
            pageTitle = titleRs.getString("menu_title");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>특집 도서 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    <style>
        .book-list {
            margin-top: 2rem;
        }
        .book-item {
            padding: 1rem;
            border-bottom: 1px solid #eee;
        }
        .book-item:hover {
            background-color: #f8f9fa;
        }
        .book-cover {
            width: 100px;
            height: 150px;
            object-fit: cover;
            border-radius: 5px;
        }
        .page-content {
            padding-top: 100px;
            min-height: calc(100vh - 60px);
        }
    </style>
</head>
<body>
    <jsp:include page="includes/nav.jsp" />

    <div class="page-content">
        <div class="container">
            <h2 class="mb-4"><%= pageTitle %> - 특집 도서 관리</h2>

            <% if(session.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <%= session.getAttribute("message") %>
                </div>
                <% session.removeAttribute("message"); %>
            <% } %>

            <form action="updateFeaturedBooks.jsp" method="post">
                <input type="hidden" name="specialPageId" value="<%= specialPageId %>">
                
                <div class="book-list">
                    <%
                    String bookSql = "SELECT b.*, CASE WHEN fb.book_id IS NOT NULL THEN 1 ELSE 0 END as is_featured, " +
                                   "fb.description as featured_description, " +
                                   "b.cover_image, b.author " +
                                   "FROM books b " +
                                   "LEFT JOIN featured_books fb ON b.id = fb.book_id " +
                                   "AND fb.special_page_id = ? " +
                                   "ORDER BY b.title";
                    try (PreparedStatement bookStmt = conn.prepareStatement(bookSql)) {
                        bookStmt.setInt(1, Integer.parseInt(specialPageId));
                        ResultSet bookRs = bookStmt.executeQuery();
                        while(bookRs.next()) {
                    %>
                        <div class="book-item d-flex align-items-center">
                            <div class="me-3">
                                <input type="checkbox" name="selectedBooks" 
                                       value="<%= bookRs.getInt("id") %>"
                                       <%= bookRs.getInt("is_featured") == 1 ? "checked" : "" %>>
                            </div>
                            <div class="me-3">
                                <img src="${pageContext.request.contextPath}/uploads/<%= bookRs.getString("cover_image") %>" 
                                     alt="<%= bookRs.getString("title") %>" class="book-cover">
                            </div>
                            <div class="flex-grow-1">
                                <h5><%= bookRs.getString("title") %></h5>
                                <p class="mb-2">저자: <%= bookRs.getString("author") %></p>
                                <textarea name="descriptions" class="form-control" 
                                          rows="2" placeholder="도서 설명"><%= bookRs.getString("featured_description") != null ? bookRs.getString("featured_description") : "" %></textarea>
                            </div>
                        </div>
                    <%
                        }
                    }
                    %>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary">변경사항 저장</button>
                    <a href="manageSpecialMenu.jsp" class="btn btn-secondary">돌아가기</a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 