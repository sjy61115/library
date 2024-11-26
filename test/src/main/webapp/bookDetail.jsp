<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>도서 상세정보</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="container mt-5">
        <%
        // 세션 체크를 상단에서 한 번에 처리
        String userRole = (String)session.getAttribute("role");
        String username = (String)session.getAttribute("username");
        int userId = session.getAttribute("userId") != null ? (Integer)session.getAttribute("userId") : 0;
        boolean isAdmin = "admin".equals(userRole);
        boolean isLoggedIn = (userId > 0 && username != null);
        
        // 디버깅용 출력
        System.out.println("isLoggedIn: " + isLoggedIn);
        System.out.println("Session Check - userId: " + userId);
        System.out.println("Session Check - username: " + username);
        System.out.println("Session Check - role: " + userRole);
        %>
        <%
        String jdbcUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
        String dbUser = "root";
        String dbPassword = "1234";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String isbn = request.getParameter("isbn");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            
            // 도서 정보 조회
            String bookSql = "SELECT * FROM books WHERE isbn = ?";
            pstmt = conn.prepareStatement(bookSql);
            pstmt.setString(1, isbn);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                int bookId = rs.getInt("id");  // book_id 저장
        %>
        <div class="row">
            <!-- 도서 정보 -->
            <div class="col-md-4">
                <img src="uploads/<%= rs.getString("cover_image") %>" 
                     class="img-fluid" alt="책 표지">
            </div>
            <div class="col-md-8">
                <h2><%= rs.getString("title") %></h2>
                <p>저자: <%= rs.getString("author") %></p>
                <p>출판사: <%= rs.getString("publisher") %></p>
                <p>출판일: <%= rs.getDate("publish_date") %></p>
                <p>카테고리: <%= rs.getString("category") %></p>
                <% if(rs.getString("description") != null) { %>
                    <h4>책 소개</h4>
                    <p><%= rs.getString("description") %></p>
                <% } %>
                <% if(rs.getString("contents") != null) { %>
                    <h4>목차</h4>
                    <p><%= rs.getString("contents") %></p>
                <% } %>
                
                <!-- 명문장 섹션 -->
                <div class="mt-5">
                    <h3>명문장</h3>
                    <%
                    // 이전 ResultSet과 PreparedStatement 정리
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    
                    // 명문장 조회
                    String quotesSql = "SELECT * FROM famous_quotes WHERE book_id = ?";
                    pstmt = conn.prepareStatement(quotesSql);
                    pstmt.setInt(1, bookId);
                    ResultSet quotesRs = pstmt.executeQuery();
                    
                    boolean hasQuotes = false;
                    while(quotesRs.next()) {
                        hasQuotes = true;
                    %>
                        <div class="card mb-3">
                            <div class="card-body">
                                <blockquote class="blockquote mb-0">
                                    <p><%= quotesRs.getString("original_text") %></p>
                                    <% if(quotesRs.getString("translated_text") != null && !quotesRs.getString("translated_text").trim().isEmpty()) { %>
                                        <p class="text-muted"><%= quotesRs.getString("translated_text") %></p>
                                    <% } %>
                                    <footer class="blockquote-footer">
                                        <% if(quotesRs.getInt("page_number") > 0) { %>
                                            p.<%= quotesRs.getInt("page_number") %>
                                        <% } %>
                                        <% if(quotesRs.getString("scene_description") != null && !quotesRs.getString("scene_description").trim().isEmpty()) { %>
                                            - <%= quotesRs.getString("scene_description") %>
                                        <% } %>
                                    </footer>
                                </blockquote>
                            </div>
                        </div>
                    <%
                    }
                    if (!hasQuotes) {
                    %>
                        <p class="text-muted">등록된 명문장이 없습니다.</p>
                    <%
                    }
                    if (quotesRs != null) quotesRs.close();
                    %>
                </div>
            </div>
        </div>
        
        <!-- 리뷰 목록 표시 -->
        <div class="mt-5">
            <h3>리뷰 목록</h3>
            <%
            // 리뷰 조회 쿼리 수정
            String reviewsSql = "SELECT r.*, u.username FROM book_reviews r " +
                              "JOIN users u ON r.user_id = u.id " +
                              "WHERE r.book_id = ? " +
                              "ORDER BY r.created_at DESC";
            pstmt = conn.prepareStatement(reviewsSql);
            pstmt.setInt(1, bookId);
            ResultSet reviewsRs = pstmt.executeQuery();
            
            // 디버깅용 출력
            System.out.println("현재 로그인한 사용자 ID: " + userId);
            
            boolean hasReviews = false;
            while(reviewsRs.next()) {
                hasReviews = true;
                boolean isReviewAuthor = (userId == reviewsRs.getInt("user_id"));
                
                // 디버깅용 출력
                System.out.println("리뷰 ID: " + reviewsRs.getInt("review_id"));
                System.out.println("리뷰 작성자 ID: " + reviewsRs.getInt("user_id"));
                System.out.println("현재 사용자가 작성자인가?: " + isReviewAuthor);
            %>
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="card-subtitle mb-2 text-muted">
                                    <%= reviewsRs.getString("username") %>
                                </h6>
                                <div class="text-warning mb-2">
                                    <% for(int i = 0; i < reviewsRs.getInt("rating"); i++) { %>★<% } %>
                                </div>
                                <p class="card-text"><%= reviewsRs.getString("content") %></p>
                                <small class="text-muted">
                                    <%= reviewsRs.getTimestamp("created_at") %>
                                </small>
                            </div>
                            <% if(isReviewAuthor) { %>
                                <div>
                                    <form action="deleteReview.jsp" method="post" style="display: inline;">
                                        <input type="hidden" name="reviewId" value="<%= reviewsRs.getInt("review_id") %>">
                                        <input type="hidden" name="isbn" value="<%= isbn %>">
                                        <button type="submit" class="btn btn-danger btn-sm" 
                                                onclick="return confirm('리뷰를 삭제하시겠습니까?');">삭제</button>
                                    </form>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            <%
            }
            if (!hasReviews) {
            %>
                <p class="text-muted">아직 등록된 리뷰가 없습니다.</p>
            <%
            }
            if (reviewsRs != null) reviewsRs.close();
            %>
        </div>

        <!-- 리뷰 작성 폼 -->
        <% if(isLoggedIn) { %>
            <div class="mt-5">
                <h3>리뷰 작성</h3>
                <form action="addReview.jsp" method="post">
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
        <div class="mt-3">
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
        <% }
            
        } catch(Exception e) {
            out.println("오류 발생: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if (conn != null) try { conn.close(); } catch(Exception e) {}
        }
        %>
    </div>
    
    <!-- 삭제 확인 모달 - 관리자만 보임 -->
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
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">소</button>
                    <form action="admin/deleteBook.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="isbn" value="<%= isbn %>">
                        <button type="submit" class="btn btn-danger">삭제</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    
    <!-- Bootstrap JS 추가 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>