package com.charity.service;

import com.charity.dto.Result;
import com.charity.entity.Notification;
import com.charity.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class NotificationService {
    
    @Autowired
    private NotificationRepository notificationRepository;
    
    public Result<Page<Notification>> getNotificationList(Integer pageNum, Integer pageSize, Long userId) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<Notification> page = notificationRepository.findByUserIdOrderBySendDateDesc(userId, pageable);
        return Result.success(page);
    }
    
    public Result<Long> getUnreadCount(Long userId) {
        long count = notificationRepository.countByUserIdAndIsRead(userId, 0);
        return Result.success(count);
    }
    
    @Transactional
    public Result<Void> markAsRead(Long id) {
        Notification notification = notificationRepository.findById(id).orElse(null);
        if (notification != null) {
            notification.setIsRead(1);
            notification.setUpdateTime(LocalDateTime.now());
            notificationRepository.save(notification);
        }
        return Result.success(null);
    }
    
    @Transactional
    public Result<Void> markAllAsRead(Long userId) {
        Pageable pageable = PageRequest.of(0, 1000);
        Page<Notification> page = notificationRepository.findByUserIdOrderBySendDateDesc(userId, pageable);
        for (Notification notification : page.getContent()) {
            if (notification.getIsRead() == 0) {
                notification.setIsRead(1);
                notification.setUpdateTime(LocalDateTime.now());
                notificationRepository.save(notification);
            }
        }
        return Result.success(null);
    }
    
    @Transactional
    public Result<Void> sendNotification(Notification notification) {
        notification.setIsRead(0);
        notification.setSendDate(LocalDateTime.now());
        notification.setCreateTime(LocalDateTime.now());
        notification.setUpdateTime(LocalDateTime.now());
        notificationRepository.save(notification);
        return Result.success(null);
    }
}
