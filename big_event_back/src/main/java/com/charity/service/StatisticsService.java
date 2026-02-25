package com.charity.service;

import com.charity.dto.Result;
import com.charity.entity.Statistics;
import com.charity.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class StatisticsService {
    
    @Autowired
    private StatisticsRepository statisticsRepository;
    
    @Autowired
    private DonationRecordRepository donationRecordRepository;
    
    @Autowired
    private DonationProjectRepository donationProjectRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public Result<Map<String, Object>> getOverallStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            stats.put("totalDonationAmount", donationRecordRepository.sumTotalAmountByStatus(1));
        } catch (Exception e) {
            stats.put("totalDonationAmount", BigDecimal.ZERO);
        }
        
        try {
            stats.put("totalDonationCount", donationRecordRepository.countByStatus(1));
        } catch (Exception e) {
            stats.put("totalDonationCount", 0L);
        }
        
        stats.put("totalProjectCount", donationProjectRepository.count());
        stats.put("totalUserCount", userRepository.count());
        
        return Result.success(stats);
    }
    
    public Result<List<Statistics>> getDailyStatistics(LocalDate startDate, LocalDate endDate) {
        List<Statistics> list = statisticsRepository.findByStatDateBetweenOrderByStatDateDesc(startDate, endDate);
        return Result.success(list);
    }
    
    public Result<List<Map<String, Object>>> getDailyTrend(LocalDate startDate, LocalDate endDate) {
        List<Object[]> trendData = donationRecordRepository.getDailyTrend(startDate, endDate);
        List<Map<String, Object>> result = new java.util.ArrayList<>();
        for (Object[] row : trendData) {
            Map<String, Object> item = new HashMap<>();
            item.put("statDate", row[0].toString());
            item.put("totalDonationAmount", row[1]);
            result.add(item);
        }
        return Result.success(result);
    }
    
    public Result<List<Map<String, Object>>> getCategoryStatistics() {
        List<Object[]> categoryData = donationProjectRepository.sumAmountByCategory();
        List<Map<String, Object>> result = new java.util.ArrayList<>();
        for (Object[] row : categoryData) {
            Map<String, Object> item = new HashMap<>();
            String category = (String) row[0];
            BigDecimal amount = (BigDecimal) row[1];
            item.put("category", category != null ? category : "其他");
            item.put("totalAmount", amount != null ? amount : BigDecimal.ZERO);
            result.add(item);
        }
        return Result.success(result);
    }
    
    @Transactional
    public Result<Void> updateDailyStatistics() {
        LocalDate today = LocalDate.now();
        Optional<Statistics> statsOpt = statisticsRepository.findByStatDate(today);
        
        Statistics stats;
        if (statsOpt.isPresent()) {
            stats = statsOpt.get();
        } else {
            stats = new Statistics();
            stats.setStatDate(today);
            stats.setCreateTime(LocalDateTime.now());
        }
        
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.plusDays(1).atStartOfDay();
        
        stats.setTotalDonationAmount(donationRecordRepository.sumAmountByDateRange(startOfDay, endOfDay));
        stats.setTotalDonationCount((int) donationRecordRepository.countByDateRange(startOfDay, endOfDay));
        stats.setTotalProjectCount((int) donationProjectRepository.count());
        stats.setTotalUserCount((int) userRepository.count());
        stats.setUpdateTime(LocalDateTime.now());
        
        statisticsRepository.save(stats);
        return Result.success(null);
    }
}
