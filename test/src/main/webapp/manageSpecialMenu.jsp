<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>특집 페이지 관리</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- 기존 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    
    <!-- Bootstrap Icons (선택사항) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    
    <style>
        body {
            font-family: 'GmarketSans', sans-serif;
        }
        
        .page-content {
            padding-top: 100px;
            min-height: calc(100vh - 60px);
            background-color: var(--text-light);
        }
        
        .page-title {
            color: var(--text-dark);
            font-family: 'GmarketSans', sans-serif;
            margin-bottom: 2rem;
            font-size: 2.5rem;
        }
        
        .content-table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
            font-size: 0.9em;
            border-radius: 5px 5px 0 0;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        .content-table thead tr {
            background-color: var(--header-bg);
            color: var(--text-light);
            text-align: left;
            font-weight: bold;
        }

        .content-table th,
        .content-table td {
            padding: 12px 15px;
        }

        .content-table tbody tr {
            border-bottom: 1px solid var(--border-color);
            background-color: white;
            transition: background-color 0.3s ease;
        }

        .content-table tbody tr:hover {
            background-color: rgba(212, 175, 55, 0.1);
        }
        
        .special-btn {
            display: inline-block;
            background-color: #8B4513;
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 14px;
            cursor: pointer;
        }

        .special-btn:hover {
            background-color: #6b3410;
            color: #fff;
            text-decoration: none;
        }

        .special-btn.btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }

        .btn-group .special-btn {
            margin-right: 4px;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/nav.jsp" />

    <div class="page-content">
        <div class="container">
            <h2 class="page-title">특집 페이지 관리</h2>
            
            <% if(session.getAttribute("message") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= session.getAttribute("message") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("message"); %>
            <% } %>
            
            <% if(session.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= session.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("error"); %>
            <% } %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="mb-0" style="color: var(--text-dark);">특집 페이지 목록</h3>
                <a href="createSpecialPage.jsp" class="special-btn">새 특집 페이지 추가</a>
            </div>

            <div class="table-responsive">
                <table class="content-table">
                    <thead>
                        <tr>
                            <th>제목</th>
                            <th>내용</th>
                            <th>순서</th>
                            <th>상태</th>
                            <th>작성일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String sql = "SELECT *, DATE_FORMAT(created_at, '%Y-%m-%d') as formatted_date FROM special_pages ORDER BY menu_order ASC";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                String preview = rs.getString("page_content");
                                if(preview.length() > 50) {
                                    preview = preview.substring(0, 50) + "...";
                                }
                        %>
                            <tr>
                                <td><%= rs.getString("menu_title") %></td>
                                <td><%= preview %></td>
                                <td><%= rs.getInt("menu_order") %></td>
                                <td>
                                    <span class="badge <%= rs.getInt("is_active") == 1 ? "text-bg-success" : "text-bg-secondary" %>">
                                        <%= rs.getInt("is_active") == 1 ? "활성" : "비활성" %>
                                    </span>
                                </td>
                                <td><%= rs.getString("formatted_date") %></td>
                                <td>
                                    <div class="btn-group">
                                        <a href="editSpecialMenu.jsp?id=<%= rs.getInt("id") %>" class="special-btn btn-sm">수정</a>
                                        <a href="manageFeaturedBooks.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-success">도서 관리</a>
                                        <button onclick="deleteMenu(<%= rs.getInt("id") %>)" class="btn btn-sm btn-danger">삭제</button>
                                    </div>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
        function deleteMenu(id) {
            if(confirm('이 특집 페이지를 삭제하시겠습니까?')) {
                location.href = 'deleteSpecialMenu.jsp?id=' + id;
            }
        }
    </script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
