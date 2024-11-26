<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션 무효화 (모든 세션 데이터 삭제)
    session.invalidate();
    
    // 로그인 페이지로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/login.jsp");
%> 