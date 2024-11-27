<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>세계 고전문학 추천</title>
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <link href="https://webfontworld.github.io/gmarket/GmarketSans.css" rel="stylesheet">
    <style>
        :root {
            --header-bg: #2C2622;
            --main-bg: #f9f1dd;
            --text-light: #fbf1e1;
            --text-dark: #292420;
            --accent: #D4AF37;
            --primary-color: #8B4513;
            --secondary-color: #DEB887;
            --nav-bg: rgba(246, 243, 238, 0.97);
            --quote-bg: #2C2622;
            --quote-text: #faefdd;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'GmarketSans', sans-serif;
        }

        body {
            background-color: var(--main-bg);
            color: var(--text-dark);
            line-height: 1.6;
        }

        /* 네비게이션 */
        .main-nav {
            background: var(--header-bg);
            padding: 20px 40px;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(130, 111, 102, 0.1);
            backdrop-filter: blur(10px);
        }

        .nav-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
        }

        .logo {
            font-size: 2.5em;
            color: var(--text-light);
            text-decoration: none;
            font-weight: 600;
            letter-spacing: -1px;
        }

        .nav-links {
            display: flex;
            gap: 40px;
        }

        .nav-links a {
            color: var(--text-light);
            text-decoration: none;
            font-size: 1.1em;
            position: relative;
            padding: 5px 0;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 1px;
            background: var(--text-dark);
            transition: width 0.3s ease;
        }

        .nav-links a:hover::after {
            width: 100%;
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
            border: 1px solid var(--secondary-color);
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(5px);
        }

        .category-tag:hover {
            background: var(--primary-color);
            color: #fff;
        }

        /* 명언 섹션 */
        .quote-section {
            background-color: var(--quote-bg);
            background-image: url('./images/vintage-constellation.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            padding: 120px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
            margin: 60px 0;
            min-height: 500px;
        }

        .quote-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(44, 38, 34, 0.7);
            z-index: 1;
        }

        .quote-slider {
            position: relative;
            z-index: 2;
            max-width: 800px;
            margin: 0 auto;
            color: var(--quote-text);
        }

        .quote-content {
            font-size: 2.5em;
            line-height: 1.4;
            margin-bottom: 30px;
            font-style: italic;
            font-weight: 300;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.7);
            color: var(--quote-text);
        }

        .quote-author {
            font-size: 1.2em;
            margin-bottom: 8px;
            font-weight: 500;
            letter-spacing: 1px;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
            color: var(--quote-text);
        }

        .quote-work {
            font-size: 1em;
            opacity: 0.8;
            font-style: italic;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
            color: var(--quote-text);
        }

        /* 별똥별 애니메이션 효과 */
        .shooting-star {
            position: absolute;
            width: 100px;
            height: 1px;
            background: linear-gradient(90deg, #faefdd, transparent);
            animation: shooting 3s infinite;
            opacity: 0;
        }

        .shooting-star:nth-child(1) {
            top: 20%;
            left: -100px;
            animation-delay: 0s;
        }

        .shooting-star:nth-child(2) {
            top: 40%;
            left: -100px;
            animation-delay: 1.5s;
        }

        @keyframes shooting {
            0% {
                transform: translateX(0) rotate(-45deg);
                opacity: 1;
            }
            100% {
                transform: translateX(1000px) rotate(-45deg);
                opacity: 0;
            }
        }

        /* 책 그리드 */
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            padding: 40px;
        }

        .book-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s ease;
            border: 1px solid rgba(222, 184, 135, 0.3);
        }

        .book-card:hover {
            transform: translateY(-10px);
        }

        .book-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .book-info {
            padding: 30px;
        }

        .book-title {
            font-size: 1.8em;
            margin-bottom: 15px;
            color: var(--text-dark);
        }

        .book-author {
            font-size: 1.2em;
            color: var(--text-dark);
            margin-bottom: 20px;
        }

        /* 입문 가이��� */
        .reading-path {
            padding: 100px 40px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            margin: 80px 0;
            border-radius: 20px;
        }

        .path-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin-top: 50px;
            gap: 40px;
        }

        .path-step {
            flex: 1;
            text-align: center;
            position: relative;
            padding: 30px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 15px;
            transition: transform 0.3s ease;
        }

        .path-step:hover {
            transform: translateY(-10px);
        }

        .step-number {
            width: 50px;
            height: 50px;
            background: var(--primary-color);
            color: #fff;
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
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
        }

        .passage-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 50px;
        }

        .passage-card {
            background: rgba(255, 255, 255, 0.9);
            padding: 40px;
            border-radius: 15px;
            transition: transform 0.3s ease;
            border: 1px solid rgba(139, 69, 19, 0.1);
        }

        .passage-card:hover {
            transform: translateY(-10px);
        }

        .difficulty-level {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.9em;
            margin-bottom: 20px;
        }

        .level-easy {
            background: rgba(139, 69, 19, 0.1);
            color: var(--primary-color);
        }

        .level-medium {
            background: rgba(139, 69, 19, 0.2);
            color: var(--primary-color);
        }

        .level-hard {
            background: rgba(139, 69, 19, 0.3);
            color: var(--primary-color);
        }

        /* 섹션 타이틀 */
        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 3em;
            margin-bottom: 20px;
            color: var(--text-dark);
            font-weight: 600;
        }

        .section-title p {
            font-size: 1.4em;
            color: var(--text-dark);
        }

        /* 버튼 스타일 */
        .btn-primary {
            display: inline-block;
            padding: 15px 40px;
            border: 2px solid var(--text-dark);
            color: var(--text-dark);
            text-decoration: none;
            font-size: 1.2em;
            transition: all 0.3s ease;
            border-radius: 30px;
            background: transparent;
        }

        .btn-primary:hover {
            background: var(--text-dark);
            color: var(--bg-color);
        }

        /* 푸터 */
        footer {
            background: var(--text-dark);
            padding: 100px 40px;
            margin-top: 100px;
            color: #fff;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 60px;
        }

        .footer-section h3 {
            font-size: 1.4em;
            margin-bottom: 30px;
            color: var(--text-light);
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section li {
            margin-bottom: 15px;
        }

        .footer-section a {
            color: var(--secondary-color);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section a:hover {
            color: var(--accent);
        }
    </style>
</head>
<body>
    <nav class="main-nav">
        <div class="nav-container">
            <a href="#" class="logo">Classics</a>
            <div class="nav-links">
                <a href="#">Home</a>
                <a href="#">Books</a>
                <a href="#">Quotes</a>
                <a href="#">About</a>
                <a href="#">Contact</a>
            </div>
        </div>
    </nav>

    <section class="hero">
        <h1>시대를 초월한<br>지혜의 빛을 찾아서</h1>
        <p>고전문학의 깊이 있는 세계로 당신을 초대합니다</p>
        <a href="#" class="btn-primary">Begin the Journey</a>
    </section>

    <!-- 오늘의 명언 섹션 -->
    <section class="quote-section">
        <!-- 별똥별 효과 -->
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

    <!-- 입문자를 위한 추천 독서 경로 -->
    <section class="reading-path container">
        <div class="section-title">
            <h2>고전문학 입문 가이드</h2>
            <p>단계별로 쉽게 시작하는 고전문학 여행</p>
        </div>
        <div class="path-steps">
            <div class="path-step">
                <div class="step-number">1</div>
                <h3>걸음</h3>
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

    <!-- 인상적인 구절 모음 -->
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
                    <p>"인생에서 가장 큰 영광은 넘어지지 않는 것이 아니라, 매번 일어선다는  있다."</p>
                    <div class="quote-author">공자</div>
                    <div class="quote-work">논어</div>
                </div>
            </div>
        </div>
    </section>
</body>
</html>
