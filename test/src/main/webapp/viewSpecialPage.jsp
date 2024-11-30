<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<%
    String idStr = request.getParameter("id");
    if(idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    String title = "";
    String content = "";
    String createdAt = "";
    
    String sql = "SELECT menu_title, page_content, DATE_FORMAT(created_at, '%Y년 %m월 %d일') as formatted_date FROM special_pages WHERE id = ? AND is_active = 1";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, Integer.parseInt(idStr));
        ResultSet specialRs = stmt.executeQuery();
        
        if(specialRs.next()) {
            title = specialRs.getString("menu_title");
            content = specialRs.getString("page_content");
            createdAt = specialRs.getString("formatted_date");
        } else {
            response.sendRedirect("index.jsp");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>특집 - <%= title %></title>
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    
    <style>
        :root {
            --main-bg: #fbf0df;
            --text-dark: #292420;
            --accent: #D4AF37;
            --quote-bg: #2C2622;
            --quote-text: #fbf0df;
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

        .special-page-container {
            padding: 120px 40px 60px;
            max-width: 1200px;
            margin: 0 auto;
            position: relative;
        }

        .special-header {
            text-align: center;
            margin-bottom: 60px;
            position: relative;
        }

        .special-title {
            font-size: 3.5em;
            color: var(--text-dark);
            margin-bottom: 20px;
            font-weight: 600;
            line-height: 1.2;
        }

        .special-date {
            color: var(--text-dark);
            opacity: 0.7;
            font-size: 1.1em;
        }

        .special-content {
            background: rgba(255, 255, 255, 0.9);
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            font-size: 1.1em;
            line-height: 1.8;
            margin-bottom: 40px;
            backdrop-filter: blur(10px);
        }

        .special-content p {
            margin-bottom: 1.5em;
        }

        .special-content img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            margin: 20px 0;
        }

        .moon-diagram {
            position: fixed;
            width: 800px;
            height: 800px;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }

        .moon-left {
            left: -400px;
            top: -200px;
        }

        .moon-right {
            right: -400px;
            bottom: -200px;
        }

        @media (max-width: 768px) {
            .special-page-container {
                padding: 100px 20px 40px;
            }

            .special-title {
                font-size: 2.5em;
            }

            .special-content {
                padding: 30px;
            }

            .moon-diagram {
                width: 400px;
                height: 400px;
            }

            .moon-left {
                left: -200px;
                top: -100px;
            }

            .moon-right {
                right: -200px;
                bottom: -100px;
            }
        }

        .featured-books {
            margin-top: 60px;
        }

        .book-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            margin: 40px auto;
            justify-content: center;
        }

        .book-card {
            flex: 0 0 calc(25% - 30px);
            max-width: calc(25% - 30px);
            margin: 0;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(222, 184, 135, 0.3);
            box-shadow: 
                0 5px 15px rgba(139, 69, 19, 0.1),
                0 3px 6px rgba(0, 0, 0, 0.05);
            transform: perspective(1000px) rotateX(0deg);
            backdrop-filter: blur(10px);
            cursor: pointer;
            text-decoration: none;
            display: block;
        }

        .book-card:hover {
            transform: perspective(1000px) rotateX(2deg) translateY(-10px);
            box-shadow: 
                0 15px 30px rgba(139, 69, 19, 0.15),
                0 5px 10px rgba(0, 0, 0, 0.08);
            text-decoration: none;
        }

        .book-cover {
            width: 100%;
            height: 340px;
            object-fit: cover;
            border-bottom: 1px solid rgba(222, 184, 135, 0.2);
            transition: transform 0.3s ease;
        }

        .book-card:hover .book-cover {
            transform: scale(1.03);
        }

        .book-info {
            padding: 20px;
            background: linear-gradient(
                to bottom,
                rgba(255, 255, 255, 0.95),
                rgba(251, 240, 223, 0.95)
            );
        }

        .book-info h3 {
            font-size: 1.2em;
            margin-bottom: 10px;
            line-height: 1.3;
            color: var(--text-dark);
        }

        .author {
            color: var(--text-dark);
            font-size: 0.9em;
            opacity: 0.8;
            margin-top: 5px;
        }

        .description {
            color: var(--text-dark);
            font-style: italic;
            margin-top: 8px;
            line-height: 1.4;
            opacity: 0.8;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-size: 0.9em;
        }

        @media (max-width: 1200px) {
            .book-card {
                flex: 0 0 calc(33.333% - 20px);
                max-width: calc(33.333% - 20px);
            }
        }

        @media (max-width: 768px) {
            .book-card {
                flex: 0 0 calc(50% - 15px);
                max-width: calc(50% - 15px);
            }
        }

        @media (max-width: 480px) {
            .book-card {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }

        /* 배경 이미지 스타일 */
        .special-page-container {
            position: relative;
            width: 100%;
            overflow-x: hidden;
        }

        .moon-diagram {
            position: fixed;
            width: 800px;
            height: 800px;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }

        .moon-left {
            left: -400px;
            top: -200px;
        }

        .moon-right {
            right: -400px;
            bottom: -200px;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .rotating {
            animation: rotate 60s linear infinite;
        }

        @media (max-width: 768px) {
            .moon-diagram {
                width: 400px;
                height: 400px;
            }

            .moon-left {
                left: -200px;
                top: -100px;
            }

            .moon-right {
                right: -200px;
                bottom: -100px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/nav.jsp" />
    

    <div class="special-page-container">
        <img src="${pageContext.request.contextPath}/images/bg-orbit.webp" alt="Moon Phases" class="moon-diagram moon-left">
        <img src="${pageContext.request.contextPath}/images/bg-orbit.webp" alt="Moon Phases" class="moon-diagram moon-right">
        
        <div class="special-header">
            <h1 class="special-title"><%= title %></h1>
            <p class="special-date">게시일: <%= createdAt %></p>
        </div>
        
        <div class="special-content">
            <%= content.replace("\n", "<br>") %>
        </div>

        <!-- 특집 도서 목록 섹션 -->
        <div class="featured-books">
            <h2>특집 도서</h2>
            <div class="book-grid">
                <%
                String featuredSql = "SELECT fb.*, b.title, b.author, b.cover_image, b.isbn " +
                                    "FROM featured_books fb " +
                                    "JOIN books b ON fb.book_id = b.id " +
                                    "WHERE fb.special_page_id = ? ORDER BY fb.display_order";
                try (PreparedStatement featuredStmt = conn.prepareStatement(featuredSql)) {
                    featuredStmt.setInt(1, Integer.parseInt(idStr));
                    ResultSet featuredRs = featuredStmt.executeQuery();
                    while(featuredRs.next()) {
                %>
                    <a href="bookDetail.jsp?isbn=<%= featuredRs.getString("isbn") %>" class="book-card">
                        <div class="book-cover-wrapper">
                            <img src="uploads/<%= featuredRs.getString("cover_image") != null ? featuredRs.getString("cover_image") : "default-book.jpg" %>" 
                                 class="book-cover" alt="<%= featuredRs.getString("title") %>의 표지">
                        </div>
                        <div class="book-info">
                            <h3><%= featuredRs.getString("title") %></h3>
                            <p class="author"><%= featuredRs.getString("author") %></p>
                            <% if(featuredRs.getString("description") != null && !featuredRs.getString("description").isEmpty()) { %>
                                <p class="description">"<%= featuredRs.getString("description") %>"</p>
                            <% } %>
                        </div>
                    </a>
                <%
                    }
                }
                %>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const moonLeft = document.querySelector('.moon-left');
            const moonRight = document.querySelector('.moon-right');
            moonLeft.classList.add('rotating');
            moonRight.classList.add('rotating');
        });
    </script>
</body>
</html> 