package com.charity.dto;

import com.charity.entity.Comment;
import com.charity.entity.User;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CommentWithUserDTO {
    private Long id;
    private Long projectId;
    private Long userId;
    private String content;
    private Integer likesCount;
    private Integer status;
    private LocalDateTime commentDate;
    
    private String username;
    private String realName;
    private String avatar;

    public static CommentWithUserDTO from(Comment comment, User user) {
        CommentWithUserDTO dto = new CommentWithUserDTO();
        dto.setId(comment.getId());
        dto.setProjectId(comment.getProjectId());
        dto.setUserId(comment.getUserId());
        dto.setContent(comment.getContent());
        dto.setLikesCount(comment.getLikesCount());
        dto.setStatus(comment.getStatus());
        dto.setCommentDate(comment.getCommentDate());
        
        if (user != null) {
            dto.setUsername(user.getUsername());
            dto.setRealName(user.getRealName());
            dto.setAvatar(user.getAvatar());
        }
        return dto;
    }
}
