package com.charity.controller;

import com.charity.dto.Result;
import com.charity.entity.Notification;
import com.charity.service.NotificationService;
import com.charity.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/notification")
@CrossOrigin
public class NotificationController {
    
    @Autowired
    private NotificationService notificationService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @GetMapping("/list")
    public Result<Page<Notification>> getNotificationList(
            @RequestHeader("Authorization") String token,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        return notificationService.getNotificationList(pageNum, pageSize, userId);
    }
    
    @GetMapping("/unread/count")
    public Result<Long> getUnreadCount(@RequestHeader("Authorization") String token) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        return notificationService.getUnreadCount(userId);
    }
    
    @PostMapping("/read/{id}")
    public Result<Void> markAsRead(@PathVariable Long id) {
        return notificationService.markAsRead(id);
    }
    
    @PostMapping("/read/all")
    public Result<Void> markAllAsRead(@RequestHeader("Authorization") String token) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        return notificationService.markAllAsRead(userId);
    }
}
