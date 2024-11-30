-- 특별 메뉴 테이블
CREATE TABLE special_menu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,          -- 메뉴 제목
    url VARCHAR(200) NOT NULL,            -- 생성된 JSP 파일 경로
    content TEXT,                         -- 페이지 내용 (기존 코드에서 사용)
    description TEXT,                     -- 메뉴 설명
    menu_order INT NOT NULL,              -- 메뉴 표시 순서
    is_active BOOLEAN DEFAULT true,       -- 활성화 여부
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 생성일시
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정일시
    category_type VARCHAR(50),            -- 'author', 'country', 'genre'
    category_value VARCHAR(100),          -- '톨스토이', '러시아', '시'
    template_type VARCHAR(50) DEFAULT 'default'  -- 페이지 템플릿 타입
);

-- 특집 도서 테이블 (기존 구조 유지하면서 menu_id 추가)
CREATE TABLE featured_books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    menu_id INT NOT NULL,
    feature_category VARCHAR(50),         -- 기존 코드와의 호환성을 위해 유지
    feature_description TEXT,             -- 기존 코드와의 호환성을 위해 유지
    display_order INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (menu_id) REFERENCES special_menu(id)
);

-- 인덱스 추가
CREATE INDEX idx_special_menu_order ON special_menu(menu_order);
CREATE INDEX idx_special_menu_active ON special_menu(is_active);
CREATE INDEX idx_special_menu_category ON special_menu(category_type, category_value);
CREATE INDEX idx_featured_books_menu ON featured_books(menu_id);
CREATE INDEX idx_featured_books_order ON featured_books(display_order);