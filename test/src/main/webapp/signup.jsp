<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
    function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;
        
        if (password !== confirmPassword) {
            alert("비밀번호가 일치하지 않습니다.");
            return false;
        }
        return true;
    }
    </script>
</head>
<body>
    <!-- 네비게이션 바 -->
	<%@ include file="includes/header.jsp" %>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <h2 class="text-center mb-4">회원가입</h2>
                
                <% if (session.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= session.getAttribute("error") %>
                        <% session.removeAttribute("error"); %>
                    </div>
                <% } %>
                
                <form action="processSignup.jsp" method="post" onsubmit="return validateForm()">
                    <div class="mb-3">
                        <label for="username" class="form-label">아이디</label>
                        <input type="text" class="form-control" id="username" name="username" 
                               required pattern="[a-zA-Z0-9]{4,20}"
                               title="4~20자의 영문 대소문자와 숫자로만 입력하세요">
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               required pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"
                               title="최소 8자, 최소 하나의 문자와 하나의 숫자를 포함해야 합니다">
                    </div>
                    
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                        <input type="password" class="form-control" id="confirmPassword" 
                               required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">이름</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="phone" class="form-label">전화번호</label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}"
                               title="000-0000-0000 형식으로 입력하세요">
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">회원가입</button>
                        <a href="login.jsp" class="btn btn-secondary">로그인 페이지로</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html> 