<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/includes/dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서 추가</title>
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

        .form-control, .form-select {
            border: 1px solid var(--secondary-color);
            background-color: rgba(255, 255, 255, 0.9);
        }

        .form-control:focus, .form-select:focus {
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

        .card {
            background-color: rgba(255, 255, 255, 0.8);
            border: 1px solid var(--secondary-color);
        }

        .card-header {
            background-color: var(--secondary-color);
            color: var(--text-dark);
            border-bottom: none;
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
    </style>
    <script>
    function validateBookForm() {
        var title = document.getElementById("title").value;
        var author = document.getElementById("author").value;
        var isbn = document.getElementById("isbn").value;
        
        if (title.trim() === "") {
            alert("도서 제목을 입력해주세요.");
            return false;
        }
        if (author.trim() === "") {
            alert("저자를 입력해주세요.");
            return false;
        }
        if (isbn.length !== 13) {
            alert("ISBN은 13자리여야 합니다.");
            return false;
        }
        return true;
    }
    </script>
</head>
<body>
    <jsp:include page="includes/nav.jsp" />
    
    <div class="container mt-5">
        <h2 class="mb-4">새로운 도서 추가</h2>
        
        <!-- 오류 메시지 표시 -->
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= session.getAttribute("error") %>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <!-- 성공 메시지 표시 -->
        <% if (session.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("message") %>
            </div>
            <% session.removeAttribute("message"); %>
        <% } %>
        
        <form action="processAddBook.jsp" method="post" 
              enctype="multipart/form-data" onsubmit="return validateBookForm()">
            <div class="mb-3">
                <label class="form-label">도서 제목</label>
                <input type="text" id="title" name="title" class="form-control" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">저자</label>
                <input type="text" id="author" name="author" class="form-control" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">ISBN</label>
                <input type="text" id="isbn" name="isbn" class="form-control" 
                       pattern="\d{13}" title="13자리 숫자를 입력하세요" 
                       placeholder="13자리 ISBN을 입력하세요 (중복 불가)" required>
                <div class="form-text">ISBN은 13자리 숫자이며, 이미 등록된 ISBN은 사용할 수 없습니다.</div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">출판사</label>
                <input type="text" name="publisher" class="form-control" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">출판일</label>
                <input type="date" name="publishDate" class="form-control" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">카테고리</label>
                <select name="category" class="form-select" required>
                    <option value="">카테고리 선택</option>
                    <option value="novel">소설</option>
                    <option value="poetry">시/에세이</option>
                    <option value="self">자기계발</option>
                    <option value="history">역사</option>
                    <option value="science">과학</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label">도서 표지</label>
                <input type="file" name="coverImage" class="form-control" 
                       accept="image/*" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">도서 소개</label>
                <textarea name="description" class="form-control" 
                          rows="5" required></textarea>
            </div>
            
            <div class="card mb-3">
                <div class="card-header">
                    <h5 class="mb-0">명대사 입력</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label">원문 *</label>
                        <textarea name="originalText" class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">페이지</label>
                                <input type="number" name="pageNumber" class="form-control" min="1">
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary">도서 등록</button>
            <a href="./bookList.jsp" class="btn btn-secondary">취소</a>
        </form>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>