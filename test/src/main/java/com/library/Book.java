package com.library;

public class Book {
    private String title;
    private String author;
    private String isbn;
    private String publisher;
    private String publishDate;
    private String category;
    private String description;
    private String contents;
    private String coverImage;

    // 생성자
    public Book(String title, String author, String isbn, String publisher, 
                String publishDate, String category, String description, 
                String contents, String coverImage) {
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.publisher = publisher;
        this.publishDate = publishDate;
        this.category = category;
        this.description = description;
        this.contents = contents;
        this.coverImage = coverImage;
    }

    // Getter와 Setter 메서드들
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    
    public String getPublishDate() { return publishDate; }
    public void setPublishDate(String publishDate) { this.publishDate = publishDate; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getContents() { return contents; }
    public void setContents(String contents) { this.contents = contents; }
    
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
}
