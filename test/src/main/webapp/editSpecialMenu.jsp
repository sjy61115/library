<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 관리자 권한 체크
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    // ID 파라미터 체크
    String menuId = request.getParameter("id");
    if(menuId == null || menuId.trim().isEmpty()) {
        response.sendRedirect("manageSpecialMenu.jsp?error=true&message=잘못된 접근입니다.");
        return;
    }

    // 데이터베이스에서 메뉴 정보 조회
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String title = "";
    String content = "";
    int menuOrder = 0;
    String description = "";
    boolean isActive = true;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/library_db",
            "root",
            "1234"
        );
        
        String sql = "SELECT * FROM special_menu WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, menuId);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
            menuOrder = rs.getInt("menu_order");
            description = rs.getString("description");
            isActive = rs.getBoolean("is_active");
        } else {
            response.sendRedirect("manageSpecialMenu.jsp?error=true&message=메뉴를 찾을 수 없습니다.");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageSpecialMenu.jsp?error=true&message=" + e.getMessage());
        return;
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
<jsp:include page="includes/header.jsp" />

<div class="container mt-5">
    <h2 class="mb-4">특집 페이지 수정</h2>
    
    <div class="card">
        <div class="card-body">
            <form action="updateSpecialMenu.jsp" method="post">
                <input type="hidden" name="menuId" value="<%= menuId %>">
                
                <div class="mb-3">
                    <label for="menuTitle" class="form-label">페이지 제목</label>
                    <input type="text" class="form-control" id="menuTitle" name="menuTitle" 
                           value="<%= title %>" required>
                </div>
                
                <div class="mb-3">
                    <label for="pageContent" class="form-label">페이지 내용</label>
                    <textarea class="form-control" id="pageContent" name="pageContent" 
                              rows="10" required><%= content %></textarea>
                </div>
                
                <div class="mb-3">
                    <label for="menuOrder" class="form-label">표시 순서</label>
                    <input type="number" class="form-control" id="menuOrder" name="menuOrder" 
                           value="<%= menuOrder %>" min="1" required>
                </div>
                
                <div class="mb-3">
                    <label for="menuDescription" class="form-label">설명</label>
                    <textarea class="form-control" id="menuDescription" name="menuDescription" 
                              rows="3"><%= description %></textarea>
                </div>
                
                <div class="mb-3">
                    <label for="isActive" class="form-label">상태</label>
                    <select class="form-select" id="isActive" name="isActive">
                        <option value="1" <%= isActive ? "selected" : "" %>>활성화</option>
                        <option value="0" <%= !isActive ? "selected" : "" %>>비활성화</option>
                    </select>
                </div>
                
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">수정 저장</button>
                    <a href="manageSpecialMenu.jsp" class="btn btn-secondary">취소</a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" /> 