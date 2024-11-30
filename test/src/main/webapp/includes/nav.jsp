<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbConfig.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
<nav class="main-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="logo">Classics</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/bookList.jsp">Books</a>
            
            <!-- 특집 메뉴 드롭다운 -->
            <div class="custom-dropdown">
                <button class="custom-dropdown-toggle nav-link" type="button">
                    특집
                </button>
                <ul class="custom-dropdown-menu">
                    <%
                    try {
                        String specialMenuSql = "SELECT id, menu_title FROM special_pages WHERE is_active = 1 ORDER BY menu_order ASC";
                        PreparedStatement specialMenuStmt = conn.prepareStatement(specialMenuSql);
                        ResultSet specialMenuRs = specialMenuStmt.executeQuery();
                        
                        while(specialMenuRs.next()) {
                    %>
                            <li>
                                <a class="custom-dropdown-item" 
                                   href="${pageContext.request.contextPath}/viewSpecialPage.jsp?id=<%= specialMenuRs.getInt("id") %>">
                                    <%= specialMenuRs.getString("menu_title") %>
                                </a>
                            </li>
                    <%
                        }
                        specialMenuRs.close();
                        specialMenuStmt.close();
                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                    %>
                </ul>
            </div>
            
            <!-- 로그인 상태에 따른 메뉴 표시 -->
            <% if(session.getAttribute("userId") != null) { %>
                <div class="custom-dropdown">
                    <button class="custom-dropdown-toggle nav-link" type="button">
                        <%= session.getAttribute("username") %>
                    </button>
                    <ul class="custom-dropdown-menu">
                        <li><a class="custom-dropdown-item" href="${pageContext.request.contextPath}/myPage.jsp">마이페이지</a></li>
                        <% if("admin".equals(session.getAttribute("role"))) { %>
                            <li><a class="custom-dropdown-item" href="${pageContext.request.contextPath}/dashboard.jsp">관리자</a></li>
                        <% } %>
                        <li><hr class="custom-dropdown-divider"></li>
                        <li><a class="custom-dropdown-item" href="${pageContext.request.contextPath}/logout.jsp">로그아웃</a></li>
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
    .custom-dropdown {
        position: relative;
        display: inline-block;
    }
    
    .custom-dropdown-toggle {
        cursor: pointer;
        text-decoration: none;
        color: var(--text-light) !important;
        background: none;
        border: none;
        padding: 0;
        font-size: inherit;
        font-family: inherit;
        font-weight: inherit;
        margin: 0 15px;
    }
    
    .nav-links {
        display: flex;
        align-items: center;
    }
    
    .nav-links a,
    .nav-links .custom-dropdown-toggle {
        font-size: 1.1rem;
        color: var(--text-light);
        text-decoration: none;
        margin: 0 15px;
        position: relative;
        transition: color 0.3s ease;
    }
    
    .custom-dropdown-toggle::after {
        content: '';
        position: absolute;
        width: 0;
        height: 2px;
        bottom: -2px;
        left: 0;
        background-color: var(--text-light);
        transition: width 0.3s ease;
    }
    
    .custom-dropdown-toggle:hover::after {
        width: 100%;
    }
    
    .custom-dropdown-menu {
        display: block;
        position: absolute;
        right: 0;
        background-color: #fbf0df !important;
        min-width: 160px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        z-index: 1;
        border-radius: 8px;
        padding: 8px 0;
        border: 1px solid #8B4513;
        
        opacity: 0;
        transform: translateY(-10px);
        transition: all 0.2s ease-in-out;
        pointer-events: none;
        
        list-style: none;
        padding-left: 0;
        margin: 0;
    }
    
    .custom-dropdown-menu.show {
        opacity: 1;
        transform: translateY(0);
        pointer-events: auto;
    }
    
    .custom-dropdown-menu .custom-dropdown-item {
        display: block;
        padding: 8px 16px;
        text-decoration: none;
        color: var(--text-dark) !important;
    }
    
    .custom-dropdown-menu .custom-dropdown-item:hover {
        background-color: rgba(139, 69, 19, 0.1);
    }
    
    .custom-dropdown-divider {
        margin: 4px 0;
        border-top: 1px solid #8B4513;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropdowns = document.querySelectorAll('.custom-dropdown');
        
        dropdowns.forEach(dropdown => {
            const button = dropdown.querySelector('.custom-dropdown-toggle');
            const menu = dropdown.querySelector('.custom-dropdown-menu');
            
            button.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                menu.classList.toggle('show');
            });
        });
        
        // 외부 클릭시 모든 드롭다운 닫기
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.custom-dropdown')) {
                document.querySelectorAll('.custom-dropdown-menu').forEach(menu => {
                    menu.classList.remove('show');
                });
            }
        });
    });
</script> 