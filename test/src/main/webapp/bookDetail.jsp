<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 상세 정보</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
        }

        .container {
            margin-top: 2rem;
        }

        .book-cover {
            max-width: 300px;
            height: auto;
            box-shadow: 0 4px 8px rgba(139, 69, 19, 0.2);
        }

        .book-info {
            padding: 30px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            box-shadow: 0 3px 6px rgba(139, 69, 19, 0.1);
        }

        .book-info h2 {
            color: var(--text-dark);
            font-size: 2.2em;
            margin-bottom: 25px;
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 15px;
        }

        .book-meta {
            font-size: 1.1em;
            color: var(--text-dark);
            opacity: 0.8;
            margin-bottom: 12px;
        }

        .review-card {
            background: var(--main-bg);
            border: 1px solid var(--secondary-color);
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 3px 6px rgba(139, 69, 19, 0.15);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--secondary-color);
        }

        .review-content {
            font-size: 1.1em;
            line-height: 1.6;
            margin: 15px 0;
        }

        .review-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 10px;
            border-top: 1px solid var(--secondary-color);
        }

        .review-form {
            background: var(--main-bg);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(139, 69, 19, 0.1);
            border: 1px solid var(--secondary-color);
            margin-top: 30px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(139, 69, 19, 0.2);
        }

        .form-control, .form-select {
            background-color: var(--main-bg);
            border: 1px solid var(--secondary-color);
        }

        .rating {
            color: var(--accent);
        }

        .quote-card {
            background: linear-gradient(145deg, #f4dec7, #f5e6d3);
            border: none;
            border-radius: 15px;
            padding: 35px;
            margin: 30px 0;
            box-shadow: 
                0 4px 15px rgba(139, 69, 19, 0.08),
                inset 0 0 20px rgba(255, 255, 255, 0.5);
        }

        .quote-content {
            position: relative;
            padding: 10px 30px;
        }

        .quote-content::before,
        .quote-content::after {
            content: '"';
            font-family: Georgia, serif;
            font-size: 4em;
            color: var(--primary-color);
            opacity: 0.2;
            position: absolute;
        }

        .quote-content::before {
            left: -10px;
            top: -20px;
        }

        .quote-content::after {
            right: -10px;
            bottom: -50px;
        }

        .original-text {
            font-size: 1.2em;
            line-height: 1.8;
            color: var(--text-dark);
            margin: 20px 0;
            font-style: italic;
            text-align: center;
        }

        .page-number {
            text-align: right;
            font-size: 0.9em;
            color: var(--primary-color);
            margin-top: 15px;
            font-weight: 500;
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
            String sql = "SELECT * FROM books WHERE isbn = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, isbn);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
    %>
    <div class="container">
        <!-- 도서 정보 섹션 -->
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

        <!-- 도서 정보와 리뷰 섹션 사이에 추가 -->
        <div class="book-quotes mt-5">
            <h3 class="mb-4">명언</h3>
            <%
            String quotesSql = "SELECT * FROM famous_quotes WHERE book_id = ?";
            PreparedStatement quotesPstmt = null;
            ResultSet quotesRs = null;
            
            try {
                quotesPstmt = conn.prepareStatement(quotesSql);
                quotesPstmt.setInt(1, rs.getInt("id"));
                quotesRs = quotesPstmt.executeQuery();
                
                if(quotesRs.next()) {
            %>
                <div class="quote-card">
                    <div class="quote-content">
                        <p class="original-text"><%= quotesRs.getString("original_text") %></p>
                        <% if(quotesRs.getString("page_number") != null) { %>
                            <p class="page-number text-muted">- p.<%= quotesRs.getString("page_number") %></p>
                        <% } %>
                    </div>
                </div>
            <%
                } else {
            %>
                <p class="text-muted">등록된 명언이 없습니다.</p>
            <%
                }
            } finally {
                if(quotesRs != null) try { quotesRs.close(); } catch(Exception e) {}
                if(quotesPstmt != null) try { quotesPstmt.close(); } catch(Exception e) {}
            }
            %>
        </div>

        <!-- 리뷰 섹션 -->
        <div class="review-section">
            <h3>리뷰 목록</h3>
            <div class="review-list">
                <%
                sql = "SELECT r.review_id, r.user_id, r.rating, r.content, r.created_at, u.username " +
                      "FROM book_reviews r " +
                      "JOIN users u ON r.user_id = u.id " +
                      "WHERE r.book_id = ? " +
                      "ORDER BY r.created_at DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, rs.getInt("id"));
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
                                    <input type="hidden" name="review_id" value="<%= reviewsRs.getInt("review_id") %>">
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
                <a href="editBook.jsp?isbn=<%= isbn %>" class="btn btn-primary">도서 정보 수정</a>
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
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">도서 삭제 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>정말로 이 도서를 삭제하시겠습니까?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <a href="deleteBook.jsp?isbn=<%= isbn %>" class="btn btn-danger">삭제</a>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>