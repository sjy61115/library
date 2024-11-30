<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>도서 취향 테스트 | BOOKS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    <style>
        :root {
            --main-bg: #F5E6D3;
            --card-bg: #FFFFFF;
            --text-dark: #292420;
            --accent: #D4AF37;
            --border-color: #E6CCB2;
        }
        
        body {
            background-color: var(--main-bg);
            color: var(--text-dark);
            line-height: 1.6;
            padding-top: 80px;
        }
        
        .container {
            background-color: transparent;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .question-card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border-color);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .question-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .progress {
            height: 8px;
            background-color: var(--main-bg);
            border-radius: 4px;
            margin: 20px 0 40px;
        }
        .progress-bar {
            background-color: var(--accent);
        }
        .form-check-input:checked {
            background-color: var(--accent);
            border-color: var(--accent);
        }
        .btn-find {
            background: var(--accent);
            color: white;
            padding: 15px 30px;
            border-radius: 8px;
            border: none;
            width: 100%;
            font-size: 1.1em;
            transition: all 0.3s ease;
            margin-top: 20px;
            box-shadow: 0 2px 8px rgba(212, 175, 55, 0.2);
        }
        .btn-find:hover {
            background: #B69121;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.3);
        }
        h4 {
            color: var(--text-dark);
            margin-bottom: 20px;
            font-weight: 600;
        }
        .form-check-label {
            color: var(--text-dark);
            padding: 8px 0;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-title {
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            text-align: center;
            font-size: 2.2em;
            font-weight: 600;
        }

        .text-muted {
            color: var(--text-dark) !important;
            opacity: 0.8;
            text-align: center;
            margin-bottom: 2.5rem;
            font-size: 1.1em;
        }

        .form-check {
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .question-card {
                padding: 20px;
            }
        }

        /* 배경 이미지 스타일 */
        .page-container {
            position: relative;
            width: 100%;
            overflow-x: hidden;
        }

        .moon-diagram {
            position: fixed;
            width: 800px;
            height: 800px;
            opacity: 0.1;
            pointer-events: none;
            z-index: -1;
        }

        .moon-left {
            left: -400px;
            top: -200px;
        }

        .moon-right {
            right: -400px;
            bottom: -200px;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .rotating {
            animation: rotate 60s linear infinite;
        }

        @media (max-width: 768px) {
            .moon-diagram {
                width: 400px;
                height: 400px;
            }

            .moon-left {
                left: -200px;
                top: -100px;
            }

            .moon-right {
                right: -200px;
                bottom: -100px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="includes/nav.jsp" %>
    <main>
        <div class="page-container">
            <img src="${pageContext.request.contextPath}/images/bg-orbit.webp" alt="Moon Phases" class="moon-diagram moon-left">
            <img src="${pageContext.request.contextPath}/images/bg-orbit.webp" alt="Moon Phases" class="moon-diagram moon-right">
        </div>
        
        <div class="container">
            <h2 class="page-title">나에게 맞는 책 찾기</h2>
            <p class="text-muted mb-4">몇 가지 질문에 답하고 맞춤 도서를 추천받으세요.</p>
            
            <form action="processRecommend.jsp" method="post">
                <div class="question-card">
                    <h4>Q1. 책을 읽을 때 가장 중요하게 생각하는 것은?</h4>
                    <div class="mt-3">
                        <div class="form-check">
                            <input type="radio" name="q1" value="philosophy_high" class="form-check-input" required>
                            <label class="form-check-label">삶의 의미와 깊이 있는 통찰</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="q1" value="romance_high" class="form-check-input">
                            <label class="form-check-label">등장인물들 간의 감정과 관계</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="q1" value="adventure_high" class="form-check-input">
                            <label class="form-check-label">흥미진진한 사건과 전개</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="q1" value="social_high" class="form-check-input">
                            <label class="form-check-label">사회 문제와 현실적 고찰</label>
                        </div>
                    </div>
                </div>

                <div class="question-card">
                    <h4>Q2. 선호하는 이야기 전개 방식은?</h4>
                    <div class="mt-3">
                        <div class="form-check">
                            <input type="radio" name="q2" value="philosophy_high" class="form-check-input" required>
                            <label class="form-check-label">철학적 사고와 깊이 있는 성찰</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="q2" value="romance_high" class="form-check-input">
                            <label class="form-check-label">섬세한 감정 묘사와 관계 발전</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="q2" value="adventure_high" class="form-check-input">
                            <label class="form-check-label">긴박감 넘치는 모험과 액션</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="q2" value="social_high" class="form-check-input">
                            <label class="form-check-label">사회 문제를 다루는 현실적 전개</label>
                        </div>
                    </div>
                </div>

                <div class="question-card">
                    <h4>Q3. 책을 읽는 주된 목적은 무엇인가요?</h4>
                    <div class="mt-3">
                        <div class="form-check">
                            <input type="radio" name="purpose" value="healing" class="form-check-input" required>
                            <label class="form-check-label">마음의 위로와 치유</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="purpose" value="knowledge" class="form-check-input">
                            <label class="form-check-label">지식과 인사이트 얻기</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="purpose" value="fun" class="form-check-input">
                            <label class="form-check-label">재미와 즐거움</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="purpose" value="growth" class="form-check-input">
                            <label class="form-check-label">자기 계발과 성장</label>
                        </div>
                    </div>
                </div>

                <div class="question-card">
                    <h4>Q4. 다음 중 가장 끌리는 주제는 무엇인가요?</h4>
                    <div class="mt-3">
                        <div class="form-check">
                            <input type="radio" name="topic" value="life" class="form-check-input" required>
                            <label class="form-check-label">일상과 삶의 이야기</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="topic" value="growth" class="form-check-input">
                            <label class="form-check-label">성장과 발전</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="topic" value="adventure" class="form-check-input">
                            <label class="form-check-label">모험과 판타지</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="topic" value="society" class="form-check-input">
                            <label class="form-check-label">사회와 인간관계</label>
                        </div>
                    </div>
                </div>

                <div class="question-card">
                    <h4>Q5. 책에서 어떤 요소를 가장 중요하게 생각하시나요?</h4>
                    <div class="mt-3">
                        <div class="form-check">
                            <input type="radio" name="element" value="story" class="form-check-input" required>
                            <label class="form-check-label">흥미로운 스토리</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="element" value="writing" class="form-check-input">
                            <label class="form-check-label">아름다운 문체</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="element" value="message" class="form-check-input">
                            <label class="form-check-label">깊이 있는 메시지</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" name="element" value="character" class="form-check-input">
                            <label class="form-check-label">매력적인 캐릭터</label>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-find">나에게 맞는 책 찾기</button>
            </form>
        </div>
    </main>
    <%@ include file="includes/footer.jsp" %>
    <script>
    document.querySelector('form').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const q1 = document.querySelector('input[name="q1"]:checked');
        const q2 = document.querySelector('input[name="q2"]:checked');
        const purpose = document.querySelector('input[name="purpose"]:checked');
        const topic = document.querySelector('input[name="topic"]:checked');
        const element = document.querySelector('input[name="element"]:checked');
        
        if (!q1 || !q2 || !purpose || !topic || !element) {
            alert('모든 질문에 답해주세요.');
            return;
        }
        
        this.submit();
    });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const moonLeft = document.querySelector('.moon-left');
            const moonRight = document.querySelector('.moon-right');
            moonLeft.classList.add('rotating');
            moonRight.classList.add('rotating');
        });
    </script>
</body>
</html> 