<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
   // 관리자 권한 체크
   if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
       response.sendRedirect("index.jsp");
       return;
   }
%>
<jsp:include page="includes/header.jsp" />
<div class="container mt-5">
   <h2 class="mb-4">특집 페이지 관리</h2>
   
   <!-- 메시지 표시 -->
   <% if(request.getParameter("success") != null) { %>
       <div class="alert alert-success" role="alert">
           작업이 성공적으로 완료되었습니다.
       </div>
   <% } else if(request.getParameter("error") != null) { %>
       <div class="alert alert-danger" role="alert">
           오류가 발생했습니다: <%= request.getParameter("message") != null ? request.getParameter("message") : "알 수 없는 오류" %>
       </div>
   <% } %>
   
   <!-- 특집 페이지 추가 폼 -->
   <div class="card mb-4">
       <div class="card-body">
           <h5 class="card-title">새 특집 페이지 추가</h5>
           <form action="createSpecialPage.jsp" method="post">
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
                   <input type="number" class="form-control" id="menuOrder" name="menuOrder" min="1" required>
               </div>
               <div class="mb-3">
                   <label for="menuDescription" class="form-label">설명</label>
                   <textarea class="form-control" id="menuDescription" name="menuDescription" rows="3"></textarea>
               </div>
               <div class="mb-3">
                   <label for="isActive" class="form-label">상태</label>
                   <select class="form-select" id="isActive" name="isActive">
                       <option value="1">활성화</option>
                       <option value="0">비활성화</option>
                   </select>
               </div>
               <button type="submit" class="btn btn-primary">페이지 생성</button>
           </form>
       </div>
   </div>
   <!-- 특집 페이지 목록 -->
   <div class="card">
       <div class="card-body">
           <h5 class="card-title">특집 페이지 목록</h5>
           <table class="table">
               <thead>
                   <tr>
                       <th>순서</th>
                       <th>제목</th>
                       <th>페이지 링크</th>
                       <th>상태</th>
                       <th>관리</th>
                   </tr>
               </thead>
               <tbody>
                   <%
                       Connection conn = null;
                       Statement stmt = null;
                       ResultSet rs = null;
                       try {
                           Class.forName("com.mysql.cj.jdbc.Driver");
                           conn = DriverManager.getConnection(
                               "jdbc:mysql://localhost:3306/library_db",
                               "root",
                               "1234"
                           );
                           
                           String sql = "SELECT * FROM special_menu ORDER BY menu_order";
                           stmt = conn.createStatement();
                           rs = stmt.executeQuery(sql);
                           
                           while(rs.next()) {
                   %>
                       <tr>
                           <td><%= rs.getInt("menu_order") %></td>
                           <td><%= rs.getString("title") %></td>
                           <td><a href="<%= rs.getString("url") %>" target="_blank"><%= rs.getString("url") %></a></td>
                           <td>
                               <span class="badge <%= rs.getBoolean("is_active") ? "bg-success" : "bg-secondary" %>">
                                   <%= rs.getBoolean("is_active") ? "활성화" : "비활성화" %>
                               </span>
                           </td>
                           <td>
                               <button class="btn btn-sm btn-warning" onclick="admin_editMenu(<%= rs.getInt("id") %>)">수정</button>
                               <button class="btn btn-sm btn-danger" onclick="admin_deleteMenu(<%= rs.getInt("id") %>)">삭제</button>
                           </td>
                       </tr>
                   <%
                           }
                       } catch(Exception e) {
                           out.println("<tr><td colspan='5' class='text-danger'>데이터를 불러오는 중 오류가 발생했습니다.</td></tr>");
                           e.printStackTrace();
                       } finally {
                           if(rs != null) try { rs.close(); } catch(Exception e) {}
                           if(stmt != null) try { stmt.close(); } catch(Exception e) {}
                           if(conn != null) try { conn.close(); } catch(Exception e) {}
                       }
                   %>
               </tbody>
           </table>
       </div>
   </div>
</div>
<jsp:include page="includes/footer.jsp" />
<script>
function admin_editMenu(id) {
   window.location.href = 'editSpecialMenu.jsp?id=' + id;
}

function admin_deleteMenu(id) {
   if(confirm('정말 삭제하시겠습니까?')) {
       window.location.href = 'deleteSpecialMenu.jsp?id=' + id;
   }
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>