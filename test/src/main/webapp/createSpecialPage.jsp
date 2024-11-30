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
    <style>
        :root {
            --bg-color: #FDF5E6;  /* 전체 배경색 */
            --primary-color: #8B4513;  /* 주요 버튼 색상 */
            --secondary-color: #DEB887;  /* 보조 버튼 색상 */
            --text-dark: #2C1810;  /* 텍스트 색상 */
            --accent-color: #BC8F8F;  /* 강조 색상 */
        }

        .page-content {
            padding: 40px 0;
            background-color: #FDF5E6;  /* var(--bg-color) 대신 직접 색상 지정 */
            min-height: calc(100vh - 60px);
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .page-title {
            color: var(--primary-color);
            font-size: 2em;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--accent-color);
        }

        .card {
            background: #FFFFFF;  /* 불투명한 흰색으로 변경 */
            border-radius: 15px;
            border: 1px solid #DEB887;
            box-shadow: 
                0 5px 15px rgba(139, 69, 19, 0.1),
                0 3px 6px rgba(0, 0, 0, 0.05);
            backdrop-filter: blur(10px);
        }

        .card-body {
            padding: 30px;
        }

        .form-label {
            color: var(--text-dark);
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 1px solid rgba(222, 184, 135, 0.3);
            border-radius: 8px;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(139, 69, 19, 0.1);
        }

        .btn-classic {
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            background-color: #8B4513;  /* var(--primary-color) */
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-classic:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 69, 19, 0.2);
        }

        .btn-classic.btn-secondary {
            background-color: #DEB887;  /* var(--secondary-color) */
        }

        textarea.form-control {
            min-height: 200px;
            resize: vertical;
        }

        .mb-3 {
            margin-bottom: 20px;
        }

        .d-flex.gap-2 {
            margin-top: 30px;
        }
    </style>
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
