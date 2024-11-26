<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>도서 추가</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
    <div class="container mt-5">
        <h2>새로운 도서 추가</h2>
        <form action="${pageContext.request.contextPath}/admin/processAddBook.jsp" method="post" 
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
                       pattern="\d{13}" title="13자리 숫자를 입력하세요" required>
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
            
            <div class="mb-3">
                <label class="form-label">목차</label>
                <textarea name="contents" class="form-control" 
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
                    
                    <div class="mb-3">
                        <label class="form-label">번역문</label>
                        <textarea name="translatedText" class="form-control" rows="3"></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">페이지</label>
                                <input type="number" name="pageNumber" class="form-control" min="1">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">장면 설명</label>
                        <textarea name="sceneDescription" class="form-control" rows="2"></textarea>
                    </div>
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary">도서 등록</button>
            <a href="${pageContext.request.contextPath}/admin/bookList.jsp" class="btn btn-secondary">취소</a>
        </form>
    </div>
</body>
</html>