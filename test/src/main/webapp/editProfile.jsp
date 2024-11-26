<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>프로필 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>프로필 수정</h2>
        <form action="updateProfile.jsp" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label class="form-label">프로필 이미지</label>
                <input type="file" name="profileImage" class="form-control">
            </div>
            
            <div class="mb-3">
                <label class="form-label">이름</label>
                <input type="text" name="name" class="form-control" value="홍길동">
            </div>
            
            <div class="mb-3">
                <label class="form-label">이메일</label>
                <input type="email" name="email" class="form-control" value="user@example.com" readonly>
            </div>
            
            <div class="mb-3">
                <label class="form-label">관심 장르</label><br>
                <input type="checkbox" name="interests" value="novel" checked> 소설
                <input type="checkbox" name="interests" value="poetry"> 시/에세이
                <input type="checkbox" name="interests" value="self" checked> 자기계발
            </div>
            
            <button type="submit" class="btn btn-primary">수정하기</button>
            <a href="myPage.jsp" class="btn btn-secondary">취소</a>
        </form>
    </div>
</body>
</html> 