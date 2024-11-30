<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../includes/dbConfig.jsp" %>
<%
    // 관리자 권한 확인
    String userRole = (String)session.getAttribute("role");
    if(!"admin".equals(userRole)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String isbn = request.getParameter("isbn");
    String sql = "SELECT * FROM books WHERE isbn = ?";
    
    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, isbn);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서 정보 수정</title>
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

        .form-label {
            color: var(--primary-color);
            font-weight: 500;
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

        .img-thumbnail {
            border-color: var(--secondary-color);
            box-shadow: 0 2px 4px rgba(139, 69, 19, 0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/nav.jsp" />
    
    <div class="container">
        <h2>도서 정보 수정</h2>
        <form action="processEditBook.jsp" method="post" enctype="multipart/form-data">
            <input type="hidden" name="isbn" value="<%= isbn %>">
            <input type="hidden" name="bookId" value="<%= rs.getInt("id") %>">
            
            <div class="mb-3">
                <label class="form-label">도서 제목</label>
                <input type="text" name="title" class="form-control" 
                       value="<%= rs.getString("title") %>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">저자</label>
                <input type="text" name="author" class="form-control" 
                       value="<%= rs.getString("author") %>" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">출판사</label>
                <input type="text" name="publisher" class="form-control" 
                       value="<%= rs.getString("publisher") %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">카테고리</label>
                <select name="category" class="form-control">
                    <option value="novel" <%= "novel".equals(rs.getString("category")) ? "selected" : "" %>>소설</option>
                    <option value="poetry" <%= "poetry".equals(rs.getString("category")) ? "selected" : "" %>>시/에세이</option>
                    <option value="self" <%= "self".equals(rs.getString("category")) ? "selected" : "" %>>자기계발</option>
                    <option value="history" <%= "history".equals(rs.getString("category")) ? "selected" : "" %>>역사</option>
                    <option value="science" <%= "science".equals(rs.getString("category")) ? "selected" : "" %>>과학</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label">현재 표지 이미지</label>
                <div class="text-center mb-3">
                    <% String coverImage = rs.getString("cover_image"); %>
                    <% if(coverImage != null && !coverImage.isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/uploads/<%= coverImage %>" 
                             class="img-thumbnail" style="max-width: 200px;" alt="도서 표지">
                    <% } else { %>
                        <p class="text-muted">등록된 표지 이미지가 없습니다.</p>
                    <% } %>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">새 표지 이미지 (선택사항)</label>
                <input type="file" name="coverImage" class="form-control" accept="image/*">
            </div>
            
            <div class="mb-3">
                <label class="form-label">도서 소개</label>
                <textarea name="description" class="form-control" rows="5" required>기존 도서 소개</textarea>
            </div>
            
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">수정하기</button>
                <a href="../bookList.jsp" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <jsp:include page="../includes/footer.jsp" />
<%
        } else {
%>
            <div class="alert alert-danger">
                도서를 찾을 수 없습니다.
            </div>
<%
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 