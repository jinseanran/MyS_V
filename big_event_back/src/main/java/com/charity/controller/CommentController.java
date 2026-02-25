package com.charity.controller;

import com.charity.dto.CommentWithUserDTO;
import com.charity.dto.Result;
import com.charity.entity.Comment;
import com.charity.service.CommentService;
import com.charity.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/comment")
@CrossOrigin
public class CommentController {
    
    @Autowired
    private CommentService commentService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @GetMapping("/list")
    public Result<Page<CommentWithUserDTO>> getCommentList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long projectId) {
        return commentService.getCommentList(pageNum, pageSize, projectId);
    }
    
    @PostMapping("/add")
    public Result<Void> addComment(
            @RequestHeader("Authorization") String token,
            @RequestBody Comment comment) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        comment.setUserId(userId);
        return commentService.addComment(comment);
    }
    
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteComment(@PathVariable Long id) {
        return commentService.deleteComment(id);
    }
    
    @PostMapping("/like/{id}")
    public Result<Void> likeComment(@PathVariable Long id) {
        return commentService.likeComment(id);
    }
}
