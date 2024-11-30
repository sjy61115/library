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
    <title>특집 도서 관리 | BOOKS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    <style>
        :root {
            --main-bg: #fbf0df;
            --text-dark: #292420;
            --accent: #D4AF37;
            --primary-color: #8B4513;
            --secondary-color: #DEB887;
            --error-color: #dc3545;
        }

        body {
            background-color: var(--main-bg);
            color: var(--text-dark);
            line-height: 1.6;
            padding-top: 80px;
            font-family: 'GmarketSans', sans-serif;
        }

        .page-content {
            padding-top: 100px;
            min-height: calc(100vh - 60px);
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 30px;
            margin-top: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 8px rgba(139, 69, 19, 0.2);
        }

        h2 {
            color: var(--primary-color);
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 10px;
            margin-bottom: 30px;
        }

        .book-list {
            margin-top: 2rem;
        }

        .book-item {
            padding: 1.5rem;
            border-bottom: 1px solid var(--secondary-color);
            transition: all 0.3s ease;
            background-color: rgba(255, 255, 255, 0.7);
        }

        .book-item:hover {
            background-color: rgba(255, 255, 255, 0.9);
            transform: translateY(-2px);
        }

        .book-cover {
            width: 120px;
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(139, 69, 19, 0.2);
        }

        .form-control {
            border: 1px solid var(--secondary-color);
            background-color: rgba(255, 255, 255, 0.9);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(139, 69, 19, 0.25);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #6b3410;
            border-color: #6b3410;
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: var(--text-dark);
        }

        .btn-secondary:hover {
            background-color: #c19a6b;
            border-color: #c19a6b;
            color: var(--text-dark);
        }

        .alert {
            border-radius: 10px;
            margin-bottom: 2rem;
        }

        .alert-success {
            background-color: rgba(212, 237, 218, 0.9);
            border-color: #c3e6cb;
        }

        input[type="checkbox"] {
            width: 20px;
            height: 20px;
            border: 2px solid var(--secondary-color);
            border-radius: 4px;
            cursor: pointer;
        }

        input[type="checkbox"]:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
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