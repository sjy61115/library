<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/dbConfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>특집 페이지 수정 | BOOKS</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

        body {
            background-color: var(--main-bg);
            color: var(--text-dark);
            line-height: 1.6;
            padding-top: 80px;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 30px;
            margin-top: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 8px rgba(139, 69, 19, 0.2);
        }

        h2 {
            color: var(--primary-color);
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 10px;
            margin-bottom: 30px;
        }

        .form-label {
            color: var(--primary-color);
            font-weight: 500;
        }

        .form-control, .form-select {
            border: 1px solid var(--secondary-color);
            background-color: rgba(255, 255, 255, 0.9);
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(139, 69, 19, 0.25);
        }

        .btn-classic {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-classic:hover {
            background-color: #6b3410;
            color: white;
            transform: translateY(-2px);
        }

        .featured-books {
            background-color: rgba(251, 240, 223, 0.5);
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
        }

        .table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .table thead {
            background-color: var(--primary-color);
            color: white;
        }

        .table th, .table td {
            padding: 1rem;
            vertical-align: middle;
        }

        .btn-danger {
            background-color: var(--error-color);
            border: none;
        }

        .btn-danger:hover {
            background-color: #bb2d3b;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .card-body {
            padding: 2rem;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/nav.jsp" />
    
    <%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if(idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("manageSpecialMenu.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);
    String menuTitle = "";
    String pageContent = "";
    int menuOrder = 1;
    int isActive = 1;

    // 기존 데이터 조회
    String sql = "SELECT * FROM special_pages WHERE id = ?";
    try (PreparedStatement selectStmt = conn.prepareStatement(sql)) {
        selectStmt.setInt(1, id);
        ResultSet specialRs = selectStmt.executeQuery();
        
        if(specialRs.next()) {
            menuTitle = specialRs.getString("menu_title");
            pageContent = specialRs.getString("page_content");
            menuOrder = specialRs.getInt("menu_order");
            isActive = specialRs.getInt("is_active");
        } else {
            response.sendRedirect("manageSpecialMenu.jsp");
            return;
        }
    }
    %>

    <div class="container">
        <h2 class="page-title">특집 페이지 수정</h2>
        
        <div class="card mb-4">
            <div class="card-body">
                <form action="updateSpecialMenu.jsp" method="post">
                    <input type="hidden" name="id" value="<%= id %>">
                    
                    <div class="mb-3">
                        <label for="menuTitle" class="form-label">페이지 제목</label>
                        <input type="text" class="form-control" id="menuTitle" name="menuTitle" 
                               value="<%= menuTitle %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="pageContent" class="form-label">페이지 내용</label>
                        <textarea class="form-control" id="pageContent" name="pageContent" 
                                  rows="10" required><%= pageContent %></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="menuOrder" class="form-label">표시 순서</label>
                        <input type="number" class="form-control" id="menuOrder" name="menuOrder" 
                               value="<%= menuOrder %>" min="1" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="isActive" class="form-label">상태</label>
                        <select class="form-select" id="isActive" name="isActive">
                            <option value="1" <%= isActive == 1 ? "selected" : "" %>>활성화</option>
                            <option value="0" <%= isActive == 0 ? "selected" : "" %>>비활성화</option>
                        </select>
                    </div>
                    
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn-classic">저장</button>
                        <a href="manageSpecialMenu.jsp" class="btn-classic" 
                           style="background-color: var(--secondary-color);">취소</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- 특집 도서 관리 섹션 -->
        <div class="card">
            <div class="card-body">
                <h3>특집 도서 관리</h3>
                
                <!-- 현재 등록된 특집 도서 목록 -->
                <div class="featured-books">
                    <h4>등록된 도서</h4>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>도서명</th>
                                    <th>설명</th>
                                    <th>순서</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                String featuredSql = "SELECT fb.*, b.title FROM featured_books fb " +
                                                   "JOIN books b ON fb.book_id = b.id " +
                                                   "WHERE fb.special_page_id = ? ORDER BY fb.display_order";
                                try (PreparedStatement featuredStmt = conn.prepareStatement(featuredSql)) {
                                    featuredStmt.setInt(1, id);
                                    ResultSet featuredRs = featuredStmt.executeQuery();
                                    while(featuredRs.next()) {
                                %>
                                    <tr>
                                        <td><%= featuredRs.getString("title") %></td>
                                        <td><%= featuredRs.getString("description") %></td>
                                        <td><%= featuredRs.getInt("display_order") %></td>
                                        <td>
                                            <form action="removeFeaturedBook.jsp" method="post" style="display: inline;">
                                                <input type="hidden" name="id" value="<%= featuredRs.getInt("id") %>">
                                                <input type="hidden" name="specialPageId" value="<%= id %>">
                                                <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                                            </form>
                                        </td>
                                    </tr>
                                <%
                                    }
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 새 특집 도서 추가 폼 -->
                <form action="addFeaturedBook.jsp" method="post">
                    <input type="hidden" name="specialPageId" value="<%= id %>">
                    
                    <div class="mb-3">
                        <label for="bookId" class="form-label">도서 선택</label>
                        <select class="form-select" id="bookId" name="bookId" required>
                            <option value="">도서를 선택하세요</option>
                            <%
                            String bookSql = "SELECT id, title FROM books ORDER BY title";
                            try (PreparedStatement bookStmt = conn.prepareStatement(bookSql)) {
                                ResultSet bookRs = bookStmt.executeQuery();
                                while(bookRs.next()) {
                            %>
                                <option value="<%= bookRs.getInt("id") %>">
                                    <%= bookRs.getString("title") %>
                                </option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">도서 설명</label>
                        <textarea class="form-control" id="description" name="description" 
                                  rows="3" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="displayOrder" class="form-label">표시 순서</label>
                        <input type="number" class="form-control" id="displayOrder" 
                               name="displayOrder" value="1" min="1" required>
                    </div>

                    <button type="submit" class="btn-classic">도서 추가</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 