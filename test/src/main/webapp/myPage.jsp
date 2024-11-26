<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>마이페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>마이페이지</h2>
        
        <!-- 프로필 정보 -->
        <div class="card mb-4">
            <div class="card-body">
                <h3>프로필 정보</h3>
                <p>이름: 홍길동</p>
                <p>이메일: user@example.com</p>
                <button class="btn btn-primary" onclick="location.href='editProfile.jsp'">
                    프로필 수정
                </button>
            </div>
        </div>

        <!-- 내가 작성한 리뷰 -->
        <div class="card mb-4">
            <div class="card-body">
                <h3>내가 작성한 리뷰</h3>
                <div class="list-group">
                    <a href="#" class="list-group-item list-group-item-action">
                        <div class="d-flex w-100 justify-content-between">
                            <h5 class="mb-1">도서제목 1</h5>
                            <small>★★★★★</small>
                        </div>
                        <p class="mb-1">리뷰 내용...</p>
                        <small>2024-03-15</small>
                    </a>
                </div>
            </div>
        </div>

        <!-- 찜한 도서 목록 -->
        <div class="card">
            <div class="card-body">
                <h3>찜한 도서</h3>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="card">
                            <img src="images/book1.jpg" class="card-img-top" alt="책 표지">
                            <div class="card-body">
                                <h5 class="card-title">도서제목 1</h5>
                                <p class="card-text">저자: 작가명</p>
                                <a href="bookDetail.jsp?id=1" class="btn btn-primary">상세보기</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 