<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="/includes/dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

        .dashboard-container {
            padding: 120px 40px 60px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .stat-card h3 {
            color: var(--primary-color);
            margin-bottom: 10px;
            font-size: 1.5em;
        }

        .stat-number {
            font-size: 2.5em;
            color: var(--accent);
            font-weight: bold;
        }

        .recent-section {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }

        .recent-section h2 {
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-dashboard {
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-dashboard:hover {
            background-color: var(--text-dark);
            color: white !important;
            transform: translateY(-2px);
            text-decoration: none;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/nav.jsp" />
    
    <div class="dashboard-container">
        <h1 class="mb-4">관리자 대시보드</h1>

        <%
        // 통계 데이터 조회
        int totalBooks = 0;
        int totalUsers = 0;
        int totalReviews = 0;
        ResultSet recentReviews = null;
        
        try {
            // 전체 도서 수
            String bookQuery = "SELECT COUNT(*) as count FROM books";
            pstmt = conn.prepareStatement(bookQuery);
            rs = pstmt.executeQuery();
            if(rs.next()) totalBooks = rs.getInt("count");
            
            // 전체 회원 수 (관리자 제외)
            String userQuery = "SELECT COUNT(*) as count FROM users WHERE role != 'admin'";
            pstmt = conn.prepareStatement(userQuery);
            rs = pstmt.executeQuery();
            if(rs.next()) totalUsers = rs.getInt("count");
            
            // 전체 리뷰 수
            String reviewQuery = "SELECT COUNT(*) as count FROM book_reviews";
            pstmt = conn.prepareStatement(reviewQuery);
            rs = pstmt.executeQuery();
            if(rs.next()) totalReviews = rs.getInt("count");
        %>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>전체 도서</h3>
                <div class="stat-number"><%= totalBooks %></div>
            </div>
            <div class="stat-card">
                <h3>전체 회원</h3>
                <div class="stat-number"><%= totalUsers %></div>
            </div>
            <div class="stat-card">
                <h3>전체 리뷰</h3>
                <div class="stat-number"><%= totalReviews %></div>
            </div>
        </div>

        <div class="recent-section">
            <h2>최근 리뷰</h2>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>도서명</th>
                            <th>작성자</th>
                            <th>평점</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        String recentReviewsQuery = 
                            "SELECT b.title, u.username, r.rating, r.created_at " +
                            "FROM book_reviews r " +
                            "JOIN books b ON r.book_id = b.id " +
                            "JOIN users u ON r.user_id = u.id " +
                            "ORDER BY r.created_at DESC LIMIT 5";
                        pstmt = conn.prepareStatement(recentReviewsQuery);
                        recentReviews = pstmt.executeQuery();
                        
                        while(recentReviews.next()) {
                        %>
                            <tr>
                                <td><%= recentReviews.getString("title") %></td>
                                <td><%= recentReviews.getString("username") %></td>
                                <td>
                                    <% for(int i = 0; i < recentReviews.getInt("rating"); i++) { %>★<% } %>
                                </td>
                                <td><%= recentReviews.getTimestamp("created_at") %></td>
                            </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="action-buttons">
            <a href="addBook.jsp" class="btn btn-dashboard">도서 추가</a>
            <a href="bookList.jsp" class="btn btn-dashboard">도서 목록</a>
            <a href="manageSpecialMenu.jsp" class="btn btn-dashboard">특집 메뉴 관리</a>
        </div>

        <%
        } catch(Exception e) {
            out.println("<div class='alert alert-danger'>데이터베이스 오류: " + e.getMessage() + "</div>");
        } finally {
            if (recentReviews != null) try { recentReviews.close(); } catch(Exception e) {}
            if (rs != null) try { rs.close(); } catch(Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if (conn != null) try { conn.close(); } catch(Exception e) {}
        }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
