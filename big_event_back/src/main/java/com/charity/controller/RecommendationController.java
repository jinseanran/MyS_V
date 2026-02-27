package com.charity.controller;

import com.charity.dto.Result;
import com.charity.entity.DonationProject;
import com.charity.entity.UserPreference;
import com.charity.service.RecommendationService;
import com.charity.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/recommendations")
public class RecommendationController {

    @Autowired
    private RecommendationService recommendationService;

    @Autowired
    private JwtUtil jwtUtil;

    @GetMapping("/projects")
    public Result<List<DonationProject>> getRecommendations(
            @RequestHeader("Authorization") String authHeader,
            @RequestParam(defaultValue = "6") int limit
    ) {
        try {
            String token = authHeader.substring(7);
            Long userId = jwtUtil.getUserId(token);

            List<DonationProject> recommendations = recommendationService.getRecommendations(userId, limit);
            return Result.success(recommendations);
        } catch (Exception e) {
            return Result.error("获取推荐失败：" + e.getMessage());
        }
    }

    @PostMapping("/record-view")
    public Result<Void> recordView(
            @RequestHeader("Authorization") String authHeader,
            @RequestBody Map<String, String> request
    ) {
        try {
            String token = authHeader.substring(7);
            Long userId = jwtUtil.getUserId(token);
            String category = request.get("category");

            recommendationService.recordView(userId, category);
            return Result.success(null);
        } catch (Exception e) {
            return Result.error("记录浏览失败：" + e.getMessage());
        }
    }

    @PostMapping("/record-donation")
    public Result<Void> recordDonation(
            @RequestHeader("Authorization") String authHeader,
            @RequestBody Map<String, String> request
    ) {
        try {
            String token = authHeader.substring(7);
            Long userId = jwtUtil.getUserId(token);
            String category = request.get("category");

            recommendationService.recordDonation(userId, category);
            return Result.success(null);
        } catch (Exception e) {
            return Result.error("记录捐赠失败：" + e.getMessage());
        }
    }

    @GetMapping("/preferences")
    public Result<List<UserPreference>> getUserPreferences(
            @RequestHeader("Authorization") String authHeader
    ) {
        try {
            String token = authHeader.substring(7);
            Long userId = jwtUtil.getUserId(token);

            List<UserPreference> preferences = recommendationService.getUserPreferences(userId);
            return Result.success(preferences);
        } catch (Exception e) {
            return Result.error("获取用户偏好失败：" + e.getMessage());
        }
    }
}
