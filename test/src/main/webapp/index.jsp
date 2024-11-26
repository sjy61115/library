<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>책 추천 서비스</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 네비게이션 바 -->
	<%@ include file="includes/header.jsp" %>
    <!-- 메인 컨텐츠 -->
    <div class="container mt-5">
        <div class="row">
            <div class="col-lg-6">
                <h1>당신을 위한 책 추천</h1>
                <p>관심사를 선택하고 맞춤 도서를 추천받아보세요</p>
                <a href="recommendForm.jsp" class="btn btn-primary">추천받기</a>
            </div>
        </div>
    </div>
</body>
</html>
