<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 네비게이션 바 -->
	<%@ include file="includes/header.jsp" %>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <h2 class="text-center mb-4">로그인</h2>
                
                <% if (session.getAttribute("message") != null) { %>
                    <div class="alert alert-success">
                        <%= session.getAttribute("message") %>
                        <% session.removeAttribute("message"); %>
                    </div>
                <% } %>
                
                <% if (session.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= session.getAttribute("error") %>
                        <% session.removeAttribute("error"); %>
                    </div>
                <% } %>
                
                <form action="processLogin.jsp" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">아이디</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">로그인</button>
                        <a href="signup.jsp" class="btn btn-secondary">회원가입</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%@ include file="../includes/footer.jsp" %>
</body>
</html> 