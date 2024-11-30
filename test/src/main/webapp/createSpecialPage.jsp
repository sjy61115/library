<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>새 특집 페이지 추가</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
</head>
<body>
    <jsp:include page="includes/nav.jsp" />

    <div class="page-content">
        <div class="container">
            <h2 class="page-title">새 특집 페이지 추가</h2>
            
            <div class="card">
                <div class="card-body">
                    <form action="addSpecialMenu.jsp" method="post">
                        <div class="mb-3">
                            <label for="menuTitle" class="form-label">페이지 제목</label>
                            <input type="text" class="form-control" id="menuTitle" name="menuTitle" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="pageContent" class="form-label">페이지 내용</label>
                            <textarea class="form-control" id="pageContent" name="pageContent" rows="10" required></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="menuOrder" class="form-label">표시 순서</label>
                            <input type="number" class="form-control" id="menuOrder" name="menuOrder" value="1" min="1" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="isActive" class="form-label">상태</label>
                            <select class="form-select" id="isActive" name="isActive">
                                <option value="1" selected>활성화</option>
                                <option value="0">비활성화</option>
                            </select>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn-classic">저장</button>
                            <a href="manageSpecialMenu.jsp" class="btn-classic" style="background-color: var(--secondary-color);">취소</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
