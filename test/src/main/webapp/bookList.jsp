<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/includes/dbConfig.jsp" %>

<%!
    // 카테고리 코드를 한글 이름으로 변환하는 헬퍼 메서드
    private String getCategoryName(String categoryCode) {
        if (categoryCode == null) return "기타";
        
        switch(categoryCode) {
            case "novel": return "소설";
            case "poetry": return "시/에세이";
            case "self": return "자기계발";
            case "history": return "역사";
            case "science": return "과학";
            default: return "기타";
        }
    }

    // 검색 조건 생성 메서드
    private String buildSearchConditions(String searchKeyword, String category, 
                                       List<String> conditions) {
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            conditions.add("(b.title LIKE ? OR b.author LIKE ? OR b.publisher LIKE ?)");
        }
        if (category != null && !category.trim().isEmpty()) {
            conditions.add("b.category = ?");
        }
        return String.join(" AND ", conditions);
    }
%>

<%
    // 세션에서 사용자 권한 확인
    String userRole = (String)session.getAttribute("role");
    boolean isAdmin = "admin".equals(userRole);

    // 페이지네이션 설정
    int currentPage = (request.getParameter("page") != null) ? 
                     Integer.parseInt(request.getParameter("page")) : 1;
    int recordsPerPage = 12;
    int start = (currentPage - 1) * recordsPerPage;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세계 고전문학 도서 목록</title>
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        :root {
            --main-bg: #fbf0df;
            --text-dark: #292420;
            --accent: #D4AF37;
            --primary-color: #8B4513;
            --secondary-color: #DEB887;
            --error-color: #dc3545;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'GmarketSans', sans-serif;
        }

        body {
            background-color: var(--main-bg);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .page-container {
            position: relative;
            width: 100%;
            min-height: 100vh;
            overflow-x: hidden;
        }

        main {
            padding-bottom: 60px;
        }

        .book-list-container {
            padding: 120px 40px 60px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .search-section {
            background: var(--nav-bg);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 50px;
            backdrop-filter: blur(10px);
        }

        .search-form {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .search-input,
        .category-select {
            flex: 1;
            min-width: 200px;
            padding: 15px 25px;
            border: 2px solid var(--secondary-color);
            border-radius: 30px;
            font-size: 1.1em;
            background: rgba(255, 255, 255, 0.9);
        }

        .search-btn {
            padding: 15px 40px;
            background: var(--primary-color);
            color: var(--text-light);
            border: none;
            border-radius: 30px;
            font-size: 1.1em;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: var(--text-dark);
        }

        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 40px;
        }

        .book-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s ease;
            border: 1px solid rgba(222, 184, 135, 0.3);
            backdrop-filter: blur(10px);
        }

        .book-card:hover {
            transform: translateY(-10px);
        }

        .book-cover {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

        .book-info {
            padding: 25px;
        }

        .book-title {
            font-size: 1.5em;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .book-meta {
            color: var(--text-dark);
            opacity: 0.8;
            margin-bottom: 5px;
        }

        .detail-btn {
            display: inline-block;
            padding: 10px 25px;
            background: var(--primary-color);
            color: var(--text-light);
            text-decoration: none;
            border-radius: 25px;
            margin-top: 15px;
            transition: all 0.3s ease;
        }

        .detail-btn:hover {
            background: var(--text-dark);
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 40px;
        }

        .pagination a {
            padding: 8px 16px;
            border: 1px solid var(--secondary-color);
            border-radius: 5px;
            text-decoration: none;
            color: var(--text-dark);
        }

        .pagination a.active {
            background: var(--primary-color);
            color: var(--text-light);
        }

        .error-message {
            text-align: center;
            padding: 40px;
            color: var(--error-color);
        }

        .error-detail {
            font-size: 0.9em;
            color: var(--text-dark);
            margin-top: 10px;
        }

        @media (max-width: 768px) {
            .book-list-container {
                padding: 100px 20px 40px;
            }

            .search-form {
                flex-direction: column;
            }

            .search-input,
            .category-select,
            .search-btn {
                width: 100%;
            }

            .books-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }

            .book-cover {
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <div class="page-container">
        <jsp:include page="includes/nav.jsp" />
        
        <main class="book-list-container">
            <div class="search-section">
                <form class="search-form" action="bookList.jsp" method="get">
                    <input type="text" name="searchKeyword" class="search-input" 
                           placeholder="제목, 저자, 출판사로 검색" 
                           value="<%= request.getParameter("searchKeyword") != null ? 
                                   request.getParameter("searchKeyword") : "" %>">
                    <select name="category" class="category-select">
                        <option value="">모든 장르</option>
                        <option value="novel" <%= "novel".equals(request.getParameter("category")) ? "selected" : "" %>>소설</option>
                        <option value="poetry" <%= "poetry".equals(request.getParameter("category")) ? "selected" : "" %>>시/에세이</option>
                        <option value="self" <%= "self".equals(request.getParameter("category")) ? "selected" : "" %>>자기계발</option>
                        <option value="history" <%= "history".equals(request.getParameter("category")) ? "selected" : "" %>>역사</option>
                        <option value="science" <%= "science".equals(request.getParameter("category")) ? "selected" : "" %>>과학</option>
                    </select>
                    <button type="submit" class="search-btn">검색</button>
                </form>
            </div>

            <div class="books-grid">
                <%
                boolean hasResults = false;
                String searchKeyword = request.getParameter("searchKeyword");
                String category = request.getParameter("category");
                
                try {
                    conn = DriverManager.getConnection(url, username, password);
                    
                    // 전체 레코드 수 조회
                    String countSql = "SELECT COUNT(*) FROM books b";
                    List<String> conditions = new ArrayList<>();
                    
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty() || 
                        category != null && !category.trim().isEmpty()) {
                        countSql += " WHERE " + buildSearchConditions(searchKeyword, category, conditions);
                    }
                    
                    pstmt = conn.prepareStatement(countSql);
                    
                    int paramIndex = 1;
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                        String likeParam = "%" + searchKeyword.trim() + "%";
                        pstmt.setString(paramIndex++, likeParam);
                        pstmt.setString(paramIndex++, likeParam);
                        pstmt.setString(paramIndex++, likeParam);
                    }
                    if (category != null && !category.trim().isEmpty()) {
                        pstmt.setString(paramIndex++, category);
                    }
                    
                    rs = pstmt.executeQuery();
                    rs.next();
                    int totalRecords = rs.getInt(1);
                    int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
                    
                    // 도서 목록 조회
                    String sql = "SELECT b.*, " +
                                "(SELECT COUNT(*) FROM book_reviews br WHERE br.book_id = b.id) as review_count, " +
                                "(SELECT AVG(rating) FROM book_reviews br WHERE br.book_id = b.id) as avg_rating " +
                                "FROM books b ";
                    
                    conditions = new ArrayList<>();
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty() || 
                        category != null && !category.trim().isEmpty()) {
                        sql += " WHERE " + buildSearchConditions(searchKeyword, category, conditions);
                    }
                    
                    sql += " ORDER BY b.registration_date DESC LIMIT ?, ?";
                    
                    pstmt = conn.prepareStatement(sql);
                    
                    paramIndex = 1;
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                        String likeParam = "%" + searchKeyword.trim() + "%";
                        pstmt.setString(paramIndex++, likeParam);
                        pstmt.setString(paramIndex++, likeParam);
                        pstmt.setString(paramIndex++, likeParam);
                    }
                    if (category != null && !category.trim().isEmpty()) {
                        pstmt.setString(paramIndex++, category);
                    }
                    pstmt.setInt(paramIndex++, start);
                    pstmt.setInt(paramIndex, recordsPerPage);
                    
                    rs = pstmt.executeQuery();
                    
                    while(rs.next()) {
                        hasResults = true;
                %>
                        <div class="book-card">
                            <img src="uploads/<%= rs.getString("cover_image") != null ? rs.getString("cover_image") : "default-book.jpg" %>" 
                                 class="book-cover" alt="<%= rs.getString("title") %>의 표지">
                            <div class="book-info">
                                <h3 class="book-title"><%= rs.getString("title") %></h3>
                                <p class="book-meta">저자: <%= rs.getString("author") %></p>
                                <p class="book-meta">장르: <%= getCategoryName(rs.getString("category")) %></p>
                                <p class="book-meta">출판사: <%= rs.getString("publisher") %></p>
                                <p class="book-meta">출판일: <%= rs.getDate("publish_date") %></p>
                                <% if (rs.getInt("review_count") > 0) { %>
                                    <p class="book-meta">
                                        평점: <%= String.format("%.1f", rs.getDouble("avg_rating")) %> 
                                        (리뷰 <%= rs.getInt("review_count") %>개)
                                    </p>
                                <% } %>
                                <a href="bookDetail.jsp?isbn=<%= rs.getString("isbn") %>" 
                                   class="detail-btn">상세보기</a>
                            </div>
                        </div>
                <%
                    }
                    
                    if (!hasResults) {
                %>
                        <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                            <p style="font-size: 1.2em; color: var(--text-dark);">검색 결과가 없습니다.</p>
                        </div>
                <%
                    }
                    
                } catch(Exception e) {
                %>
                    <div class="error-message">
                        <p>죄송합니다. 도서 목록을 불러오는 중 오류가 발생했습니다.</p>
                        <% if(isAdmin) { %>
                            <p class="error-detail"><%= e.getMessage() %></p>
                        <% } %>
                    </div>
                <%
                } finally {
                    if (rs != null) try { rs.close(); } catch(Exception e) {}
                    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                    if (conn != null) try { conn.close(); } catch(Exception e) {}
                }
                %>
            </div>

            <% if(isAdmin) { %>
            <div class="admin-actions">
                <a href="./addBook.jsp" class="add-book-btn">
                    <i class="bi bi-plus-circle me-2"></i>새 도서 등록
                </a>
            </div>
            <% } %>
        </main>
        
        <jsp:include page="includes/footer.jsp" />
    </div>
</body>
</html>