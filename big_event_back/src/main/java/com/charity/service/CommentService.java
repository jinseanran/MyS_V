package com.charity.service;

import com.charity.dto.CommentWithUserDTO;
import com.charity.dto.Result;
import com.charity.entity.Comment;
import com.charity.entity.User;
import com.charity.repository.CommentRepository;
import com.charity.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommentService {
    
    @Autowired
    private CommentRepository commentRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public Result<Page<CommentWithUserDTO>> getCommentList(Integer pageNum, Integer pageSize, Long projectId) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<Comment> commentPage;
        if (projectId != null) {
            commentPage = commentRepository.findByProjectIdOrderByCommentDateDesc(projectId, pageable);
        } else {
            commentPage = commentRepository.findAllByOrderByCommentDateDesc(pageable);
        }
        
        List<Long> userIds = commentPage.getContent().stream()
                .map(Comment::getUserId)
                .collect(Collectors.toList());
        
        Map<Long, User> userMap = userRepository.findAllById(userIds).stream()
                .collect(Collectors.toMap(User::getId, user -> user));
        
        List<CommentWithUserDTO> dtoList = commentPage.getContent().stream()
                .map(comment -> CommentWithUserDTO.from(comment, userMap.get(comment.getUserId())))
                .collect(Collectors.toList());
        
        Page<CommentWithUserDTO> dtoPage = new PageImpl<>(dtoList, pageable, commentPage.getTotalElements());
        return Result.success(dtoPage);
    }
    
    @Transactional
    public Result<Void> addComment(Comment comment) {
        comment.setLikesCount(0);
        comment.setStatus(1);
        comment.setCommentDate(LocalDateTime.now());
        comment.setCreateTime(LocalDateTime.now());
        comment.setUpdateTime(LocalDateTime.now());
        commentRepository.save(comment);
        return Result.success(null);
    }
    
    @Transactional
    public Result<Void> deleteComment(Long id) {
        commentRepository.deleteById(id);
        return Result.success(null);
    }
    
    @Transactional
    public Result<Void> likeComment(Long id) {
        Comment comment = commentRepository.findById(id).orElse(null);
        if (comment != null) {
            comment.setLikesCount(comment.getLikesCount() + 1);
            comment.setUpdateTime(LocalDateTime.now());
            commentRepository.save(comment);
        }
        return Result.success(null);
    }
}
