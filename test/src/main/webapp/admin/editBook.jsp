<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>도서 정보 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>도서 정보 수정</h2>
        <form action="processEditBook.jsp" method="post" enctype="multipart/form-data">
            <input type="hidden" name="bookId" value="1">
            
            <div class="mb-3">
                <label class="form-label">도서 제목</label>
                <input type="text" name="title" class="form-control" 
                       value="기존 도서 제목" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">저자</label>
                <input type="text" name="author" class="form-control" 
                       value="기존 저자" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">현재 표지 이미지</label>
                <img src="../uploads/current-cover.jpg" class="img-thumbnail" 
                     style="max-width: 200px;">
            </div>
            
            <div class="mb-3">
                <label class="form-label">새 표지 이미지 (선택사항)</label>
                <input type="file" name="coverImage" class="form-control" 
                       accept="image/*">
            </div>
            
            <div class="mb-3">
                <label class="form-label">도서 소개</label>
                <textarea name="description" class="form-control" 
                          rows="5" required>기존 도서 소개</textarea>
            </div>
            
            <button type="submit" class="btn btn-primary">수정하기</button>
            <a href="bookList.jsp" class="btn btn-secondary">취소</a>
        </form>
    </div>
</body>
</html> 