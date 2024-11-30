CREATE TABLE special_pages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    menu_title VARCHAR(100) NOT NULL,
    page_content TEXT NOT NULL,
    menu_order INT NOT NULL DEFAULT 1,
    is_active TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 테이블이 제대로 생성되었는지 확인
DESCRIBE special_pages;

-- 테스트 데이터 삽입
INSERT INTO special_pages (menu_title, page_content, menu_order, is_active) 
VALUES ('테스트 페이지', '테스트 내용입니다.', 1, 1);

-- 데이터가 제대로 들어갔는지 확인
SELECT * FROM special_pages;