<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="includes/dbConfig.jsp" %>

<%
    // 관리자 권한 확인
    String userRole = (String)session.getAttribute("role");
    if(!"admin".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>관리자 대시보드 - Classics</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        :root {
            --main-bg: #fbf0df;
            --main-color: #8B4513;
            --text-dark: #292420;
        }
        
        .dashboard-container {
            max-width: 1200px;
            margin: 120px auto 50px;
            padding: 0 20px;
        }
        
        .stats-card {
            background-color: var(--main-bg);
            border: 1px solid var(--main-color);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.2s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-number {
            font-size: 2em;
            color: var(--main-color);
            font-weight: bold;
        }
        
        .stats-label {
            color: var(--text-dark);
            font-size: 1.1em;
            margin-top: 10px;
        }
        
        .action-button {
            background-color: var(--main-color);
            color: var(--main-bg);
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
            transition: background-color 0.2s ease;
        }
        
        .action-button:hover {
            background-color: #654321;
            color: var(--main-bg);
            text-decoration: none;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="dashboard-container">
        <h2 class="mb-4">관리자 대시보드</h2>
        
        <div class="row">
            <%
                int bookCount = 0;
                int userCount = 0;
                int reviewCount = 0;
                
                if(conn == null) {
                    out.println("<div class='col-12'><div class='alert alert-danger'>데이터베이스 연결이 실패했습니다. dbConfig.jsp를 확인해주세요.</div></div>");
                } else {
                    try {
                        // 전체 도서 수 조회
                        String bookCountSql = "SELECT COUNT(*) as count FROM books";
                        pstmt = conn.prepareStatement(bookCountSql);
                        rs = pstmt.executeQuery();
                        if(rs.next()) {
                            bookCount = rs.getInt("count");
                        }
                        
                        // 전체 회원 수 조회
                        String userCountSql = "SELECT COUNT(*) as count FROM users WHERE role != 'admin'";
                        pstmt = conn.prepareStatement(userCountSql);
                        rs = pstmt.executeQuery();
                        if(rs.next()) {
                            userCount = rs.getInt("count");
                        }
                        
                        // 전체 리뷰 수 조회
                        String reviewCountSql = "SELECT COUNT(*) as count FROM reviews";
                        pstmt = conn.prepareStatement(reviewCountSql);
                        rs = pstmt.executeQuery();
                        if(rs.next()) {
                            reviewCount = rs.getInt("count");
                        }
                    } catch(SQLException e) {
                        out.println("<div class='col-12'><div class='alert alert-warning'>SQL 쿼리 실행 중 오류 발생: " + e.getMessage() + "</div></div>");
                        e.printStackTrace();
                    }
                }
            %>
            
            <% if(conn != null) { %>
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="stats-number"><%= bookCount %></div>
                        <div class="stats-label">등록된 도서</div>
                        <a href="addBook.jsp" class="action-button">도서 등록</a>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="stats-number"><%= userCount %></div>
                        <div class="stats-label">가입 회원</div>
                        <a href="userList.jsp" class="action-button">회원 관리</a>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="stats-number"><%= reviewCount %></div>
                        <div class="stats-label">전체 리뷰</div>
                        <a href="reviewList.jsp" class="action-button">리뷰 관리</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html> 