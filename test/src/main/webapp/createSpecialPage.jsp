<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
   // 관리자 권한 체크
   if (session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
       response.sendRedirect("index.jsp");
       return;
   }
   request.setCharacterEncoding("UTF-8");

   try {
       // 폼 데이터 받기
       String menuTitle = request.getParameter("menuTitle");
       String pageContent = request.getParameter("pageContent");
       String menuDescription = request.getParameter("menuDescription");
       int menuOrder = Integer.parseInt(request.getParameter("menuOrder"));
       boolean isActive = "1".equals(request.getParameter("isActive"));

       // 파일명 생성 (현재 시간을 사용하여 고유한 파일명 생성)
       String pageFileName = "special_" + System.currentTimeMillis() + ".jsp";

       // 템플릿 파일 경로 및 실경로 설정
       String templatePath = application.getRealPath("template.jsp");
       String realPath = application.getRealPath("/special/");
       File dir = new File(realPath);
       if (!dir.exists()) {
           dir.mkdirs();
       }

       // 템플릿 파일 읽기
       StringBuilder templateContent = new StringBuilder();
       try (BufferedReader br = new BufferedReader(new FileReader(templatePath))) {
           String line;
           while ((line = br.readLine()) != null) {
               templateContent.append(line).append("\n");
           }
       }

       // 템플릿 내용에 데이터 삽입
       String generatedContent = templateContent.toString()
           .replace("${menuTitle}", menuTitle)
           .replace("${pageContent}", pageContent);

       // 컨텐츠 페이지 생성
       File contentFile = new File(dir, pageFileName);
       try (FileWriter writer = new FileWriter(contentFile)) {
           writer.write(generatedContent);
       }

       // DB에 정보 저장
       Class.forName("com.mysql.cj.jdbc.Driver");
       String dbUrl = "jdbc:mysql://localhost:3306/library_db?useUnicode=true&characterEncoding=utf8";
       String dbUser = "root";
       String dbPassword = "1234";

       String sql = "INSERT INTO special_menu (title, url, description, menu_order, is_active) VALUES (?, ?, ?, ?, ?)";

       try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

           pstmt.setString(1, menuTitle);
           pstmt.setString(2, "special/" + pageFileName); // URL 경로 수정
           pstmt.setString(3, menuDescription);
           pstmt.setInt(4, menuOrder);
           pstmt.setBoolean(5, isActive);

           pstmt.executeUpdate();
       }

       response.sendRedirect("manageSpecialMenu.jsp?success=true");

   } catch (Exception e) {
       e.printStackTrace();
       response.sendRedirect("manageSpecialMenu.jsp?error=true&message=" +
                           java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
   }
%>
