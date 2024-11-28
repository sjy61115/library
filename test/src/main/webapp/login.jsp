<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="/includes/dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'GmarketSans', sans-serif;
        }

        body {
            background-color: var(--main-bg);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .login-container {
            padding-top: 120px;
            padding-bottom: 60px;
        }

        .login-form {
            background: rgba(255, 255, 255, 0.9);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .login-form h2 {
            color: var(--primary-color);
            margin-bottom: 30px;
            text-align: center;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid var(--secondary-color);
            padding: 12px;
            margin-bottom: 20px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 12px;
            border-radius: 25px;
            width: 100%;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: var(--text-dark);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            border: none;
            padding: 12px;
            border-radius: 25px;
            width: 100%;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: var(--text-dark);
            transform: translateY(-2px);
        }

        .alert {
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/nav.jsp" />
    
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="login-form">
                    <h2>로그인</h2>
                    
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
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 