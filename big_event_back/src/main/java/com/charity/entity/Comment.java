package com.charity.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "comment")
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "project_id")
    private Long projectId;
    
    @Column(name = "user_id")
    private Long userId;
    
    private String content;
    
    @Column(name = "likes_count")
    private Integer likesCount;
    
    private Integer status;
    
    @Column(name = "comment_date")
    private LocalDateTime commentDate;
    
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @PrePersist
    protected void onCreate() {
        createTime = LocalDateTime.now();
        updateTime = LocalDateTime.now();
        commentDate = LocalDateTime.now();
        if (status == null) {
            status = 1;
        }
        if (likesCount == null) {
            likesCount = 0;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updateTime = LocalDateTime.now();
    }
}
