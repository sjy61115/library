<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // 특집 메뉴 목록 가져오기
    List<Map<String, String>> specialMenus = new ArrayList<>();
    try {
        // DB 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
        String dbUser = "root";
        String dbPassword = "1234";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT title, url FROM special_menu WHERE is_active = 1 ORDER BY menu_order ASC")) {

            while (rs.next()) {
                Map<String, String> menu = new HashMap<>();
                menu.put("title", rs.getString("title"));
                menu.put("url", rs.getString("url"));
                specialMenus.add(menu);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- Bootstrap CSS를 header.jsp에 포함 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- 커스텀 CSS (필요한 경우) -->
<link href="<%=request.getContextPath()%>/css/custom.css" rel="stylesheet">

<!-- 네비게이션 바 시작 -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container">
        <a class="navbar-brand" href="<%=request.getContextPath()%>/index.jsp">도서관</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="토글 내비게이션">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- 왼쪽 메뉴 -->
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">홈</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=request.getContextPath()%>/bookList.jsp">도서목록</a>
                </li>
                <!-- 특집 드롭다운 메뉴 -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="specialsDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        특집
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="specialsDropdown">
                        <% for (Map<String, String> menu : specialMenus) { %>
                            <li>
                                <a class="dropdown-item" href="<%=request.getContextPath()%>/<%=menu.get("url")%>">
                                    <%=menu.get("title")%>
                                </a>
                            </li>
                        <% } %>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/popularQuotes.jsp">인기 명언</a></li>
                    </ul>
                </li>
            </ul>
            <!-- 검색 폼 -->
            <form class="d-flex me-2" action="<%=request.getContextPath()%>/bookList.jsp" method="get">
                <select class="form-select me-2" name="category" style="width: auto;">
                    <option value="all" selected>전체</option>
                    <option value="novel">소설</option>
                    <option value="poem">시/에세이</option>
                    <option value="economy">경제/경영</option>
                    <option value="self">자기계발</option>
                    <option value="humanities">인문학</option>
                    <option value="children">아동/청소년</option>
                    <option value="language">외국어</option>
                    <option value="it">컴퓨터/IT</option>
                </select>
                <input class="form-control me-2" type="search"
                       placeholder="검색어를 입력하세요"
                       name="keyword"
                       value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>"
                       aria-label="Search">
                <button class="btn btn-outline-success" type="submit">검색</button>
            </form>
            <!-- 오른쪽 메뉴 -->
            <ul class="navbar-nav">
                <% if(session.getAttribute("userId") != null) { %>
                    <!-- 로그인 상태 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <%= session.getAttribute("username") %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/mypage.jsp">마이페이지</a></li>
                            <% if("admin".equals(session.getAttribute("role"))) { %>
                                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/dashboard.jsp">관리자 페이지</a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <!-- 비로그인 상태 -->
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/login.jsp">로그인</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/register.jsp">회원가입</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
<!-- 네비게이션 바 끝 -->

<!-- Bootstrap JS와 Popper.js 추가 -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
