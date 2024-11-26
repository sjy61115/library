<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>도서 추천 받기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 네비게이션 바 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">Book Service</a>
            <div class="navbar-nav">
                <a class="nav-link" href="bookList.jsp">도서목록</a>
                <a class="nav-link" href="recommendForm.jsp">추천하기</a>
                <a class="nav-link" href="register.jsp">회원가입</a>
            </div>
        </div>
    </nav>
    <div class="container mt-5">
        <h2>관심사 선택</h2>
        <form action="recommendResult.jsp" method="post">
            <div class="mb-3">
                <label class="form-label">선호하는 장르</label><br>
                <input type="checkbox" name="genre" value="소설"> 소설
                <input type="checkbox" name="genre" value="시/에세이"> 시/에세이
                <input type="checkbox" name="genre" value="자기계발"> 자기계발
            </div>
            
            <div class="mb-3">
                <label class="form-label">독서 수준</label>
                <select name="level" class="form-select">
                    <option value="beginner">입문</option>
                    <option value="intermediate">중급</option>
                    <option value="advanced">고급</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label">선호하는 페이지 수</label>
                <input type="radio" name="pageCount" value="short"> 300페이지 미만
                <input type="radio" name="pageCount" value="medium"> 300-500페이지
                <input type="radio" name="pageCount" value="long"> 500페이지 이상
            </div>
            
            <button type="submit" class="btn btn-primary">추천받기</button>
        </form>
    </div>
</body>
</html> 