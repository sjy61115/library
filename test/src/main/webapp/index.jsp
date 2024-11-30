<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세계 고전문학 추천</title>
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nav.css">
    <style>
        :root {
            --main-bg: #fbf0df !important;
            --text-dark: #292420;
            --accent: #D4AF37;
            --quote-bg: #2C2622;
            --quote-text: #fbf0df;
            --book-title-color: #8B4513;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'GmarketSans', sans-serif;
        }

        body {
            background-color: var(--main-bg) !important;
            color: var(--text-dark);
            line-height: 1.6;
        }

        /* 히어로 섹션 */
        .hero {
            background: transparent;
            padding: 200px 40px 150px;
            margin-top: 100px;
            text-align: center;
        }

        .hero h1 {
            color: var(--text-dark);
            font-size: 5em;
            line-height: 1.2;
            margin-bottom: 30px;
            font-weight: 600;
            letter-spacing: -1px;
        }

        .hero p {
            color: var(--text-dark);
            font-size: 1.8em;
            margin-bottom: 50px;
            font-weight: 300;
        }

        /* 검색바 */
        .search-bar {
            text-align: center;
            margin: 40px 0;
        }

        .search-bar input {
            width: 60%;
            padding: 15px 25px;
            border: 2px solid var(--secondary-color);
            border-radius: 30px;
            font-size: 1.1em;
            outline: none;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(5px);
        }

        /* 카테고리 */
        .categories {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 40px 0;
            flex-wrap: wrap;
        }

        .category-tag {
            padding: 10px 25px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 25px;
            text-decoration: none;
            color: var(--text-dark);
            font-size: 1.1em;
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }

        .category-tag:hover {
            background: var(--accent);
            color: white;
        }

        /* 명언 섹션 */
        .quote-section {
            background: linear-gradient(
                rgba(44, 38, 34, 0.9),  /* var(--quote-bg)와 동일한 색상에 투명도 추가 */
                rgba(44, 38, 34, 0.9)
            ), url('${pageContext.request.contextPath}/images/vintage-constellation.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: var(--quote-text);
            padding: 100px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .quote-content {
            font-size: 2em;
            font-style: italic;
            margin-bottom: 20px;
            font-family: 'Crimson Text', serif;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .quote-author, .quote-work {
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
        }

        /* 독서 경로 섹션 */
        .reading-path {
            padding: 100px 40px;
            text-align: center;
        }

        .section-title {
            margin-bottom: 50px;
        }

        .section-title h2 {
            font-size: 2.5em;
            margin-bottom: 15px;
        }

        .section-title p {
            font-size: 1.2em;
            opacity: 0.8;
        }

        .path-steps {
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
        }

        .path-step {
            flex: 1;
            min-width: 250px;
            max-width: 350px;
            padding: 30px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            backdrop-filter: blur(5px);
        }

        .step-number {
            width: 40px;
            height: 40px;
            background: var(--accent);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 1.2em;
        }

        /* 인상적인 구절 섹션 */
        .featured-passages {
            padding: 100px 40px;
            background: var(--quote-bg);
            color: var(--quote-text);
        }

        .passage-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .passage-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(5px);
            position: relative;
        }

        .difficulty-level {
            position: absolute;
            top: -10px;
            right: 20px;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 0.9em;
        }

        .level-easy { background: #28a745; }
        .level-medium { background: #ffc107; }
        .level-hard { background: #dc3545; }

        /* 배경 이미지 스타일 */
        .moon-diagram {
            position: fixed;
            width: 800px;
            height: 800px;
            opacity: 0.1;
            pointer-events: none;
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

        /* 반응형 스타일 */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 3em;
            }

            .hero p {
                font-size: 1.4em;
            }

            .search-bar input {
                width: 90%;
            }

            .quote-content {
                font-size: 1.5em;
            }

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

        /* 전체 컨테이너 스타일 */
        .page-container {
            position: relative;
            width: 100%;
            overflow-x: hidden;
        }

        /* 버튼 스타일 */
        .btn-primary {
            display: inline-block;
            padding: 15px 40px;
            background: var(--accent);
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-size: 1.2em;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
    <div class="page-container">
        <img src="${pageContext.request.contextPath}/images/bg-orbit.webp" alt="Moon Phases" class="moon-diagram moon-left">
        <img src="${pageContext.request.contextPath}/images/bg-orbit.webp" alt="Moon Phases" class="moon-diagram moon-right">
        
        <jsp:include page="includes/nav.jsp" />

        <section class="hero">
            <h1>시대를 초월한<br>지혜의 빛을 찾아서</h1>
            <p>고전문학의 깊이 있는 세계로 당신을 초대합니다</p>
            <a href="recommendTest.jsp" class="btn-primary">Begin the Journey</a>
        </section>

        <section class="quote-section">
            <div class="shooting-star"></div>
            <div class="shooting-star"></div>
            
            <div class="quote-slider">
                <div class="quote-content">
                    "책은 인생의 거울이다. 우리는 책을 통해 자신을 발견하고, 세상을 이해하게 된다."
                </div>
                <div class="quote-author">빅토르 위고</div>
                <div class="quote-work">레 미제라블</div>
            </div>
        </section>

        <section class="reading-path container">
            <div class="section-title">
                <h2>고전문학 입문 가이드</h2>
                <p>단계별로 쉽게 시하는 고전문학 여행</p>
            </div>
            <div class="path-steps">
                <div class="path-step">
                    <div class="step-number">1</div>
                    <h3>입문</h3>
                    <p>짧은 명언과 인상적인 구절로 시작하기</p>
                </div>
                <div class="path-step">
                    <div class="step-number">2</div>
                    <h3>이해하기</h3>
                    <p>현대적 해석과 함께 읽기</p>
                </div>
                <div class="path-step">
                    <div class="step-number">3</div>
                    <h3>깊이 읽기</h3>
                    <p>원문으로 작품의 진수 느끼기</p>
                </div>
            </div>
        </section>

        <section class="featured-passages">
            <div class="container">
                <div class="section-title">
                    <h2>인상적인 명문장</h2>
                    <p>고전문학의 아름다움을 한 문장으로 만나보세요</p>
                </div>
                <div class="passage-grid">
                    <div class="passage-card">
                        <span class="difficulty-level level-easy">입문자 추천</span>
                        <p>"진정한 사랑은 이성적인 판단이 아닌 마음의 선택이다."</p>
                        <div class="quote-author">제인 오스틴</div>
                        <div class="quote-work">오만과 편견</div>
                    </div>
                    <div class="passage-card">
                        <span class="difficulty-level level-medium">중급</span>
                        <p>"모든 행복한 가정은 서로 비슷하지만, 불행한 가정은 저마다 그 이유가 다르다."</p>
                        <div class="quote-author">레프 톨스토이</div>
                        <div class="quote-work">안나 카레니나</div>
                    </div>
                    <div class="passage-card">
                        <span class="difficulty-level level-hard">심화</span>
                        <p>"인생에서 가장 큰 영광은 넘어지지 않는 것이 아니라, 매번 일어선다는 데 있다."</p>
                        <div class="quote-author">공자</div>
                        <div class="quote-work">논어</div>
                    </div>
                </div>
            </div>
        </section>
    </div>

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
