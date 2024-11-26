<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<jsp:include page="includes/header.jsp" />

<div class="container mt-5">
    <h2 class="mb-4">관리자 대시보드</h2>
    
    <div class="row">
        <!-- 도서 관리 -->
        <div class="col-md-4 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">도서 관리</h5>
                    <p class="card-text">도서 추가, 수정, 삭제를 관리합니다.</p>
                    <a href="<%=request.getContextPath()%>/bookList.jsp" class="btn btn-primary">도서 관리</a>
                    <a href="<%=request.getContextPath()%>/addBook.jsp" class="btn btn-success">도서 추가</a>
                </div>
            </div>
        </div>
        
        <!-- 회원 관리 -->
        <div class="col-md-4 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">회원 관리</h5>
                    <p class="card-text">회원 정보를 조회하고 관리합니다.</p>
                    <a href="userList.jsp" class="btn btn-primary">회원 목록</a>
                </div>
            </div>
        </div>
        
        <!-- 특집 페이지 관리 -->
        <div class="col-md-4 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">특집 페이지 관리</h5>
                    <p class="card-text">특집 메뉴와 페이지를 관리합니다.</p>
                    <a href="manageSpecialMenu.jsp" class="btn btn-primary">특집 관리</a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 통계 정보 -->
    <div class="row mt-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">도서 통계</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">전체 도서 수: <span id="totalBooks">0</span>권</li>
                        <li class="list-group-item">대출 중인 도서: <span id="borrowedBooks">0</span>권</li>
                        <li class="list-group-item">이번 달 신규 도서: <span id="newBooks">0</span>권</li>
                    </ul>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">회원 통계</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">전체 회원 수: <span id="totalUsers">0</span>명</li>
                        <li class="list-group-item">이번 달 신규 회원: <span id="newUsers">0</span>명</li>
                        <li class="list-group-item">현재 활성 회원: <span id="activeUsers">0</span>명</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html> 