-- 특별 메뉴 테이블
CREATE TABLE special_menu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,          -- 메뉴 제목
    url VARCHAR(200) NOT NULL,            -- 생성된 JSP 파일 경로
    description TEXT,                     -- 메뉴 설명
    menu_order INT NOT NULL,              -- 메뉴 표시 순서
    is_active BOOLEAN DEFAULT true,       -- 활성화 여부
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 생성일시
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 수정일시
);

-- 인덱스 추가
CREATE INDEX idx_special_menu_order ON special_menu(menu_order);
CREATE INDEX idx_special_menu_active ON special_menu(is_active);