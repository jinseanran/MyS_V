package com.charity.service;

import com.charity.dto.LoginRequest;
import com.charity.dto.Result;
import com.charity.dto.UpdateUserRequest;
import com.charity.entity.User;
import com.charity.repository.UserRepository;
import com.charity.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    public Result<Map<String, Object>> login(LoginRequest request) {
        Optional<User> userOpt = userRepository.findByUsername(request.getUsername());
        
        if (userOpt.isEmpty()) {
            return Result.error("用户不存在");
        }
        User user = userOpt.get();
        if (user.getStatus() == 0) {
            return Result.error("用户已被禁用");
        }
        if (!request.getPassword().equals(user.getPassword())) {
            return Result.error("密码错误");
        }

        user.setLastLoginDate(LocalDateTime.now());
        userRepository.save(user);

        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());

        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("user", getUserInfo(user));

        return Result.success(data);
    }

    public Result<Void> register(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            return Result.error("用户名已存在");
        }

        user.setRole(0);
        user.setStatus(1);
        user.setTotalDonation(BigDecimal.ZERO);
        user.setRegistrationDate(LocalDateTime.now());
        userRepository.save(user);

        return Result.success();
    }

    public Map<String, Object> getUserInfo(User user) {
        Map<String, Object> info = new HashMap<>();
        info.put("id", user.getId());
        info.put("username", user.getUsername());
        info.put("realName", user.getRealName());
        info.put("phone", user.getPhone());
        info.put("email", user.getEmail());
        info.put("avatar", user.getAvatar());
        info.put("role", user.getRole());
        info.put("totalDonation", user.getTotalDonation());
        return info;
    }

    public Result<User> getUserById(Long id) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) {
            return Result.error("用户不存在");
        }
        User user = userOpt.get();
        user.setPassword(null);
        return Result.success(user);
    }

    public Result<Void> updateUser(User user) {
        try {
            Optional<User> existingUserOpt = userRepository.findById(user.getId());
            if (existingUserOpt.isEmpty()) {
                return Result.error("用户不存在");
            }
            User existingUser = existingUserOpt.get();
            if (user.getRealName() != null) existingUser.setRealName(user.getRealName());
            if (user.getPhone() != null) existingUser.setPhone(user.getPhone());
            if (user.getEmail() != null) existingUser.setEmail(user.getEmail());
            if (user.getAvatar() != null) existingUser.setAvatar(user.getAvatar());
            existingUser.setUpdateTime(LocalDateTime.now());
            userRepository.save(existingUser);
            return Result.success();
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新失败: " + e.getMessage());
        }
    }
    
    public Result<Void> updateUser(Long userId, UpdateUserRequest request) {
        try {
            Optional<User> existingUserOpt = userRepository.findById(userId);
            if (existingUserOpt.isEmpty()) {
                return Result.error("用户不存在");
            }
            User existingUser = existingUserOpt.get();
            if (request.getRealName() != null) existingUser.setRealName(request.getRealName());
            if (request.getPhone() != null) existingUser.setPhone(request.getPhone());
            if (request.getEmail() != null) existingUser.setEmail(request.getEmail());
            if (request.getAvatar() != null) existingUser.setAvatar(request.getAvatar());
            existingUser.setUpdateTime(LocalDateTime.now());
            userRepository.save(existingUser);
            return Result.success();
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新失败: " + e.getMessage());
        }
    }
    
    public Result<Page<User>> getUserList(Integer pageNum, Integer pageSize, Integer role, Integer status) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<User> page;
        
        if (role != null && status != null) {
            page = userRepository.findByRoleAndStatus(role, status, pageable);
        } else if (role != null) {
            page = userRepository.findByRole(role, pageable);
        } else if (status != null) {
            page = userRepository.findByStatus(status, pageable);
        } else {
            page = userRepository.findAll(pageable);
        }
        
        return Result.success(page);
    }
    
    @Transactional
    public Result<Void> updateUserStatus(Long id, Integer status) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setStatus(status);
            user.setUpdateTime(LocalDateTime.now());
            userRepository.save(user);
        }
        return Result.success();
    }
    
    @Transactional
    public Result<Void> deleteUser(Long id) {
        userRepository.deleteById(id);
        return Result.success();
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public void saveUser(User user) {
        userRepository.save(user);
    }
    
    public Result<Void> changePassword(Long userId, String oldPassword, String newPassword) {
        try {
            Optional<User> existingUserOpt = userRepository.findById(userId);
            if (existingUserOpt.isEmpty()) {
                return Result.error("用户不存在");
            }
            User existingUser = existingUserOpt.get();
            if (!oldPassword.equals(existingUser.getPassword())) {
                return Result.error("原密码错误");
            }
            existingUser.setPassword(newPassword);
            existingUser.setUpdateTime(LocalDateTime.now());
            userRepository.save(existingUser);
            return Result.success();
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("修改密码失败: " + e.getMessage());
        }
    }
}
