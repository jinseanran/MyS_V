package com.charity.controller;

import com.charity.dto.LoginRequest;
import com.charity.dto.RegisterRequest;
import com.charity.dto.Result;
import com.charity.dto.UpdateUserRequest;
import com.charity.entity.User;
import com.charity.repository.DonationRecordRepository;
import com.charity.service.UserService;
import com.charity.utils.JwtUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/user")
@CrossOrigin
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private DonationRecordRepository donationRecordRepository;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody LoginRequest request) {
        return userService.login(request);
    }

    @PostMapping("/register")
    public Result<Void> register(@RequestBody RegisterRequest request) {
        User user = new User();
        BeanUtils.copyProperties(request, user);
        return userService.register(user);
    }

    @GetMapping("/info")
    public Result<User> getUserInfo(@RequestHeader("Authorization") String token) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        Result<User> result = userService.getUserById(userId);
        if (result.getData() != null) {
            try {
                BigDecimal total = donationRecordRepository.sumTotalAmountByUserId(userId);
                if (total == null) {
                    total = BigDecimal.ZERO;
                }
                result.getData().setTotalDonation(total);
            } catch (Exception e) {
                System.err.println("计算累计捐赠失败: " + e.getMessage());
                result.getData().setTotalDonation(BigDecimal.ZERO);
            }
        }
        return result;
    }

    @PutMapping("/update")
    public Result<Void> updateUser(@RequestHeader("Authorization") String token, @RequestBody UpdateUserRequest request) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        return userService.updateUser(userId, request);
    }
    
    @GetMapping("/list")
    public Result<Page<User>> getUserList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Integer role,
            @RequestParam(required = false) Integer status) {
        return userService.getUserList(pageNum, pageSize, role, status);
    }
    
    @PutMapping("/status/{id}")
    public Result<Void> updateUserStatus(
            @PathVariable Long id,
            @RequestParam Integer status) {
        return userService.updateUserStatus(id, status);
    }
    
    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteUser(@PathVariable Long id) {
        return userService.deleteUser(id);
    }

    @PostMapping("/update-all-total-donation")
    @Transactional
    public Result<Void> updateAllTotalDonation() {
        List<User> users = userService.getAllUsers();
        for (User user : users) {
            BigDecimal total = donationRecordRepository.sumTotalAmountByUserId(user.getId());
            user.setTotalDonation(total);
            userService.saveUser(user);
        }
        return Result.success();
    }
    
    @PutMapping("/change-password")
    public Result<Void> changePassword(
            @RequestHeader("Authorization") String token,
            @RequestBody Map<String, String> request) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        String oldPassword = request.get("oldPassword");
        String newPassword = request.get("newPassword");
        return userService.changePassword(userId, oldPassword, newPassword);
    }
}
