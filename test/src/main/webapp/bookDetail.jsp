<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="/includes/dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>도서 상세정보</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        .container {
            padding-top: 120px;
            padding-bottom: 60px;
        }

        /* 도서 정보 섹션 */
        .book-cover {
            width: 100%;
            max-width: 400px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .book-info h2 {
            color: var(--primary-color);
            font-size: 2.5em;
            margin-bottom: 20px;
        }

        .book-meta {
            color: var(--text-dark);
            opacity: 0.8;
            font-size: 1.1em;
            margin-bottom: 10px;
        }

        .book-description, .book-contents {
            margin-top: 30px;
        }

        .book-description h4, .book-contents h4 {
            color: var(--primary-color);
            margin-bottom: 15px;
        }

        /* 리뷰 섹션 */
        .review-section {
            margin-top: 50px;
        }

        .review-section h3 {
            color: var(--primary-color);
            margin-bottom: 30px;
        }

        .review-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .review-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .review-content {
            font-size: 1.1em;
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .review-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: var(--text-dark);
            opacity: 0.7;
        }

        .rating {
            color: var(--accent);
            font-size: 1.2em;
        }

        /* 리뷰 폼 */
        .review-form {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 15px;
            margin-top: 30px;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid var(--secondary-color);
        }

        /* 버튼 스타일 */
        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 10px 25px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: var(--text-dark);
            transform: translateY(-2px);
        }

        .btn-danger {
            border-radius: 25px;
            padding: 10px 25px;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .container {
                padding-top: 100px;
            }

            .book-info h2 {
                font-size: 2em;
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="./includes/nav.jsp" />
    
    <%
        String isbn = request.getParameter("isbn");
        ResultSet reviewsRs = null;
        
        String userRole = (String)session.getAttribute("role");
        boolean isAdmin = "admin".equals(userRole);
        boolean isLoggedIn = session.getAttribute("userId") != null;
        boolean hasReviews = false;
        
        try {
            conn = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT * FROM books WHERE isbn = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, isbn);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
    %>
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <img src="uploads/<%= rs.getString("cover_image") != null ? rs.getString("cover_image") : "default-book.jpg" %>" 
                     class="book-cover" alt="책 표지">
            </div>
            <div class="col-md-8 book-info">
                <h2><%= rs.getString("title") %></h2>
                <p class="book-meta">저자: <%= rs.getString("author") %></p>
                <p class="book-meta">출판사: <%= rs.getString("publisher") %></p>
                <p class="book-meta">출판일: <%= rs.getDate("publish_date") %></p>
                <p class="book-meta">카테고리: <%= rs.getString("category") %></p>
                <% if(rs.getString("description") != null) { %>
                    <div class="book-description">
                        <h4>책 소개</h4>
                        <p><%= rs.getString("description") %></p>
                    </div>
                <% } %>
                <% if(rs.getString("contents") != null) { %>
                    <div class="book-contents">
                        <h4>목차</h4>
                        <p><%= rs.getString("contents") %></p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- 리뷰 섹션 -->
        <div class="review-section">
            <h3>리뷰 목록</h3>
            <div class="review-list">
                <%
                // 리뷰 조회 쿼리 수정
                sql = "SELECT r.*, u.username FROM book_reviews r JOIN users u ON r.user_id = u.id WHERE r.book_id = ? ORDER BY r.created_at DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, rs.getInt("id")); // book_id를 사용
                reviewsRs = pstmt.executeQuery();
                
                while(reviewsRs.next()) {
                    hasReviews = true;
                    boolean isReviewAuthor = isLoggedIn && 
                        reviewsRs.getInt("user_id") == Integer.parseInt(session.getAttribute("userId").toString());
                %>
                    <div class="review-card">
                        <div class="review-header">
                            <h6><%= reviewsRs.getString("username") %></h6>
                            <div class="rating">
                                <% for(int i = 0; i < reviewsRs.getInt("rating"); i++) { %>★<% } %>
                            </div>
                        </div>
                        <p class="review-content"><%= reviewsRs.getString("content") %></p>
                        <div class="review-footer">
                            <small class="review-date"><%= reviewsRs.getTimestamp("created_at") %></small>
                            <% if(isReviewAuthor || isAdmin) { %>
                                <form action="deleteReview.jsp" method="post" style="display: inline;">
                                    <input type="hidden" name="review_id" value="<%= reviewsRs.getInt("id") %>">
                                    <input type="hidden" name="isbn" value="<%= isbn %>">
                                    <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                <%
                }
                if (!hasReviews) {
                %>
                    <p class="text-muted">아직 등록된 리뷰가 없습니다.</p>
                <%
                }
                %>
            </div>
        </div>

        <!-- 리뷰 작성 폼 -->
        <% if(isLoggedIn) { %>
            <div class="review-form">
                <h3>리뷰 작성</h3>
                <form action="addReview.jsp" method="post">
                    <input type="hidden" name="book_id" value="<%= rs.getInt("id") %>">
                    <input type="hidden" name="isbn" value="<%= isbn %>">
                    <div class="mb-3">
                        <label class="form-label">평점</label>
                        <select name="rating" class="form-select">
                            <option value="5">★★★★★</option>
                            <option value="4">★★★★</option>
                            <option value="3">★★★</option>
                            <option value="2">★★</option>
                            <option value="1">★</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">리뷰 내용</label>
                        <textarea name="content" class="form-control" rows="3" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">리뷰 등록</button>
                </form>
            </div>
        <% } else { %>
            <div class="mt-5">
                <p class="text-muted">리뷰를 작성하려면 <a href="login.jsp">로그인</a>이 필요합니다.</p>
            </div>
        <% } %>
        
        <!-- 목록 섹션 -->
        <div class="mt-5">
            <a href="bookList.jsp" class="btn btn-secondary">목록으로 돌아가기</a>
            <% if(isAdmin) { %>
                <a href="admin/editBook.jsp?isbn=<%= isbn %>" class="btn btn-primary">도서 정보 수정</a>
                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                    도서 삭제
                </button>
            <% } %>
        </div>
        
        <% } else { %>
            <div class="alert alert-danger">
                도서를 찾을 수 없습니다.
            </div>
            <a href="bookList.jsp" class="btn btn-secondary">목록으로</a>
        <%
        }
        } catch(Exception e) {
            out.println("오류 발생: " + e.getMessage());
        } finally {
            if (reviewsRs != null) try { reviewsRs.close(); } catch(Exception e) {}
            if (rs != null) try { rs.close(); } catch(Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if (conn != null) try { conn.close(); } catch(Exception e) {}
        }
        %>
    </div>
    
    <!-- 삭제 확인 모달 -->
    <% if(isAdmin) { %>
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">도서 삭제 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    정말로 이 도서를 삭제하시겠습니까?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">소소</button>
                    <form action="admin/deleteBook.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="isbn" value="<%= isbn %>">
                        <button type="submit" class="btn btn-danger">삭제</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>