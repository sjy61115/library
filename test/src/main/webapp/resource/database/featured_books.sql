CREATE TABLE `featured_books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `special_page_id` int NOT NULL,
  `book_id` int NOT NULL,
  `description` text,
  `display_order` int NOT NULL DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`special_page_id`) REFERENCES `special_pages` (`id`),
  FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;