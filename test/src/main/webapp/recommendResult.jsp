<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>추천 도서 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>추천 도서 목록</h2>
        
        <%
        // 폼에서 전송된 데이터 받기
        request.setCharacterEncoding("UTF-8");
        String[] genres = request.getParameterValues("genre");
        String level = request.getParameter("level");
        String pageCount = request.getParameter("pageCount");
        %>
        
        <div class="alert alert-info">
            <h4>선택하신 조건</h4>
            <p>장르: 
            <%
            if(genres != null) {
                for(String genre : genres) {
                    out.print(genre + " ");
                }
            }
            %>
            </p>
            <p>독서 수준: <%= level %></p>
            <p>선호 페이지: <%= pageCount %></p>
        </div>
        
        <!-- 임시 추천 도서 목록 -->
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">추천도서 1</h5>
                        <p class="card-text">도서 설명...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 