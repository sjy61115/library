CREATE TABLE book_scores (
    book_id INT PRIMARY KEY,
    philosophy_score INT DEFAULT 0,
    romance_score INT DEFAULT 0,
    adventure_score INT DEFAULT 0,
    social_score INT DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

INSERT INTO book_scores (book_id, philosophy_score, romance_score, adventure_score, social_score) VALUES
(32, 10, 6, 0, 4),  -- 데미안
(33, 4, 10, 0, 6),  -- 안나 카레니나
(34, 6, 4, 0, 8),   -- 가난한 사람들
(35, 2, 4, 0, 6),   -- 호밀밭의 파수꾼
(36, 4, 8, 0, 6),   -- 설국
(37, 8, 2, 0, 10),  -- 1984
(38, 6, 0, 0, 10),  -- 동물농장
(39, 8, 2, 0, 6),   -- 인간 실격
(40, 10, 4, 0, 8),  -- 죄와 벌
(41, 10, 2, 0, 4),  -- 이방인
(42, 4, 10, 0, 6),  -- 오만과 편견
(43, 2, 4, 10, 6),  -- 허클베리 핀의 모험
(44, 2, 2, 10, 4);  -- 야성의 부름
