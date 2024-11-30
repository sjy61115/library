<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서 추천 결과 | BOOKS</title>
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    <style>
        :root {
            --main-bg: #fbf0df;
            --text-dark: #292420;
            --accent: #D4AF37;
            --primary-color: #8B4513;
            --secondary-color: #DEB887;
            --text-light: #fff;
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
            padding-top: 80px;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 30px;
            margin-top: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 8px rgba(139, 69, 19, 0.2);
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .page-title {
            color: var(--primary-color);
            font-size: 2.5rem;
            margin-bottom: 1rem;
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 1rem;
        }

        .result-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(139, 69, 19, 0.1);
            border: 1px solid var(--secondary-color);
            transition: transform 0.3s ease;
        }

        .result-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.2);
        }

        .book-cover {
            width: 160px;
            height: 230px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(139, 69, 19, 0.15);
        }

        .book-title {
            color: var(--primary-color);
            font-size: 1.6em;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .book-author {
            color: var(--text-dark);
            font-size: 0.9em;
            opacity: 0.8;
            margin-top: 5px;
        }

        .rating-stars {
            color: var(--accent);
            margin: 15px 0;
            font-size: 1.2em;
            letter-spacing: 2px;
        }

        .action-buttons {
            margin-top: 40px;
            display: flex;
            gap: 20px;
            justify-content: center;
        }

        .btn-primary, .btn-retry {
            padding: 12px 35px;
            border-radius: 30px;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            font-size: 1.1em;
            font-weight: 500;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: var(--text-light);
        }

        .btn-primary:hover {
            background-color: #6b3410;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(139, 69, 19, 0.2);
        }

        .btn-retry {
            background-color: var(--secondary-color);
            color: var(--text-dark);
        }

        .btn-retry:hover {
            background-color: #c19a6b;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(139, 69, 19, 0.15);
        }

        .alert-info {
            background-color: rgba(255, 255, 255, 0.9);
            border: 1px solid var(--secondary-color);
            color: var(--text-dark);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin: 30px 0;
        }

        .books-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            margin: 40px auto;
            max-width: 1200px;
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

        .book-title {
            font-size: 1.2em;
            margin-bottom: 10px;
            line-height: 1.3;
            color: var(--text-dark);
        }

        .book-quote {
            color: var(--text-dark);
            font-style: italic;
            margin-top: 8px;
            line-height: 1.4;
            opacity: 0.8;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-size: 0.9em;
        }

        .book-match {
            color: var(--accent);
            font-size: 0.9em;
            margin-top: 5px;
            font-weight: 500;
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
    </style>
</head>
<body>
    <%@ include file="includes/nav.jsp" %>
    <main>
        <div class="container">
            <h2 class="page-title">맞춤 도서 추천 결과</h2>
            
            <div class="books-grid">
                <%
                ArrayList<HashMap<String, Object>> recommendedBooks = 
                    (ArrayList<HashMap<String, Object>>) session.getAttribute("recommendedBooks");
                
                if(recommendedBooks != null && !recommendedBooks.isEmpty()) {
                    for(HashMap<String, Object> book : recommendedBooks) {
                %>
                        <a href="bookDetail.jsp?isbn=<%= book.get("isbn") %>" class="book-card">
                            <div class="book-cover-wrapper">
                                <img src="uploads/<%= book.get("cover_image") != null ? book.get("cover_image") : "default-book.jpg" %>" 
                                     class="book-cover" alt="<%= book.get("title") %>의 표지">
                            </div>
                            <div class="book-info">
                                <h3 class="book-title"><%= book.get("title") %></h3>
                                <p class="book-match">매칭 점수: <%= 100 - ((Integer)book.get("match_score") * 2) %>%</p>
                                <% if(book.get("quote") != null && !book.get("quote").toString().isEmpty()) { %>
                                    <p class="book-quote">"<%= book.get("quote") %>"</p>
                                <% } %>
                            </div>
                        </a>
                <%
                    }
                } else {
                %>
                    <div class="alert alert-info">
                        죄송합니다. 추천할 만한 도서를 찾지 못했습니다.
                    </div>
                <%
                }
                %>
            </div>
            
            <div class="action-buttons">
                <a href="recommendTest.jsp" class="btn btn-retry">다시 테스트하기</a>
                <a href="bookList.jsp" class="btn btn-primary">도서 목록 보기</a>
            </div>
        </div>
    </main>
    <%@ include file="includes/footer.jsp" %>
</body>
</html> 