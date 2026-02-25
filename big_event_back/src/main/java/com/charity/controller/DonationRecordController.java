package com.charity.controller;

import org.springframework.data.domain.Page;
import com.charity.dto.Result;
import com.charity.entity.DonationRecord;
import com.charity.service.DonationRecordService;
import com.charity.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/record")
@CrossOrigin
public class DonationRecordController {

    @Autowired
    private DonationRecordService recordService;

    @Autowired
    private JwtUtil jwtUtil;

    @GetMapping("/list")
    public Result<Page<DonationRecord>> getRecordList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long projectId,
            @RequestHeader(value = "Authorization", required = false) String token) {
        Long userId = null;
        if (token != null) {
            userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        }
        return recordService.getRecordList(pageNum, pageSize, userId, projectId);
    }

    @GetMapping("/detail/{donationNo}")
    public Result<DonationRecord> getRecordByNo(@PathVariable String donationNo) {
        return recordService.getRecordByNo(donationNo);
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalProjects", recordService.count());
        return Result.success(stats);
    }
}
