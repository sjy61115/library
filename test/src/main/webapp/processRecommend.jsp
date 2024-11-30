<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="includes/dbConfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 사용자 응답 점수 계산 (최대 10점 기준)
    int philosophyScore = 0;
    int romanceScore = 0;
    int adventureScore = 0;
    int socialScore = 0;
    
    // Q1 점수 계산
    String q1 = request.getParameter("q1");
    if("philosophy_high".equals(q1)) {
        philosophyScore += 3;
        socialScore += 1;
    } else if("romance_high".equals(q1)) {
        romanceScore += 3;
        socialScore += 1;
    } else if("adventure_high".equals(q1)) {
        adventureScore += 3;
    } else if("social_high".equals(q1)) {
        socialScore += 3;
        philosophyScore += 1;
    }
    
    // Q2 점수 계산
    String q2 = request.getParameter("q2");
    if("romance_high".equals(q2)) {
        romanceScore += 3;
        socialScore += 1;
    } else if("adventure_high".equals(q2)) {
        adventureScore += 3;
    } else if("social_high".equals(q2)) {
        socialScore += 3;
        philosophyScore += 1;
    }
    
    // Q3 점수 계산 (책을 읽는 목적)
    String purpose = request.getParameter("purpose");
    if("healing".equals(purpose)) {
        romanceScore += 2;
        socialScore += 1;
    } else if("knowledge".equals(purpose)) {
        philosophyScore += 2;
        socialScore += 2;
    } else if("fun".equals(purpose)) {
        adventureScore += 2;
        romanceScore += 1;
    }
    
    // Q4 점수 계산 (선호 주제)
    String topic = request.getParameter("topic");
    if("life".equals(topic)) {
        socialScore += 2;
        romanceScore += 1;
    } else if("growth".equals(topic)) {
        philosophyScore += 2;
        socialScore += 1;
    } else if("adventure".equals(topic)) {
        adventureScore += 2;
    }
    
    // Q5 점수 계산 (중요 요소)
    String element = request.getParameter("element");
    if("story".equals(element)) {
        adventureScore += 2;
        romanceScore += 1;
    } else if("writing".equals(element)) {
        romanceScore += 2;
        philosophyScore += 1;
    } else if("message".equals(element)) {
        philosophyScore += 2;
        socialScore += 2;
    }
    
    // 책 추천 쿼리
    String sql = "SELECT b.*, bs.*, " +
                "ABS(bs.philosophy_score - ?) + " +
                "ABS(bs.romance_score - ?) + " +
                "ABS(bs.adventure_score - ?) + " +
                "ABS(bs.social_score - ?) as match_score " +
                "FROM books b " +
                "JOIN book_scores bs ON b.id = bs.book_id " +
                "ORDER BY match_score ASC " +
                "LIMIT 4";
    
    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, philosophyScore);
        pstmt.setInt(2, romanceScore);
        pstmt.setInt(3, adventureScore);
        pstmt.setInt(4, socialScore);
        
        rs = pstmt.executeQuery();
        
        ArrayList<HashMap<String, Object>> recommendedBooks = new ArrayList<>();
        while(rs.next()) {
            HashMap<String, Object> book = new HashMap<>();
            book.put("id", rs.getInt("id"));
            book.put("title", rs.getString("title"));
            book.put("author", rs.getString("author"));
            book.put("isbn", rs.getString("isbn"));
            book.put("cover_image", rs.getString("cover_image"));
            book.put("match_score", rs.getInt("match_score"));
            recommendedBooks.add(book);
        }
        
        session.setAttribute("recommendedBooks", recommendedBooks);
        response.sendRedirect("recommendResult.jsp");
        
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("recommendTest.jsp");
    }
%> 