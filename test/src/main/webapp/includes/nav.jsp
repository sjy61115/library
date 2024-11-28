<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
<nav class="main-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="logo">Classics</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/bookList.jsp">Books</a>
            
            <!-- 로그인 상태에 따른 메뉴 표시 -->
            <% if(session.getAttribute("userId") != null) { %>
                <div class="dropdown">
                    <a href="#" class="dropdown-toggle" data-bs-toggle="dropdown">
                        <%= session.getAttribute("username") %>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/myPage.jsp">마이페이지</a></li>
                        <% if("admin".equals(session.getAttribute("role"))) { %>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard.jsp">관리자</a></li>
                        <% } %>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout.jsp">로그아웃</a></li>
                    </ul>
                </div>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp">로그인</a>
                <a href="${pageContext.request.contextPath}/signup.jsp">회원가입</a>
            <% } %>
        </div>
    </div>
</nav>

<style>
    .dropdown {
        position: relative;
        display: inline-block;
    }
    
    .dropdown-toggle {
        cursor: pointer;
        text-decoration: none;
        color: var(--text-dark);
    }
    
    .dropdown-menu {
        display: none;
        position: absolute;
        right: 0;
        background-color: white;
        min-width: 160px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        z-index: 1;
        border-radius: 8px;
        padding: 8px 0;
    }
    
    .dropdown-menu.show {
        display: block;
    }
    
    .dropdown-item {
        display: block;
        padding: 8px 16px;
        text-decoration: none;
        color: var(--text-dark);
    }
    
    .dropdown-item:hover {
        background-color: var(--main-bg);
    }
    
    .dropdown-divider {
        margin: 4px 0;
        border-top: 1px solid #e9ecef;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropdownToggle = document.querySelector('.dropdown-toggle');
        if(dropdownToggle) {
            dropdownToggle.addEventListener('click', function(e) {
                e.preventDefault();
                const dropdownMenu = this.nextElementSibling;
                dropdownMenu.classList.toggle('show');
            });
            
            // 외부 클릭시 드롭다운 닫기
            document.addEventListener('click', function(e) {
                if(!e.target.matches('.dropdown-toggle')) {
                    const dropdowns = document.getElementsByClassName('dropdown-menu');
                    for(let dropdown of dropdowns) {
                        if(dropdown.classList.contains('show')) {
                            dropdown.classList.remove('show');
                        }
                    }
                }
            });
        }
    });
</script> 