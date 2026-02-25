package com.charity.controller;

import com.charity.dto.Result;
import com.charity.entity.Statistics;
import com.charity.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/statistics")
@CrossOrigin
public class StatisticsController {
    
    @Autowired
    private StatisticsService statisticsService;
    
    @GetMapping("/overall")
    public Result<Map<String, Object>> getOverallStatistics() {
        return statisticsService.getOverallStatistics();
    }
    
    @GetMapping("/overview")
    public Result<Map<String, Object>> getOverviewStatistics() {
        return statisticsService.getOverallStatistics();
    }
    
    @GetMapping("/daily")
    public Result<List<Statistics>> getDailyStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return statisticsService.getDailyStatistics(startDate, endDate);
    }
    
    @GetMapping("/trend")
    public Result<List<Map<String, Object>>> getTrendStatistics() {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(30);
        return statisticsService.getDailyTrend(startDate, endDate);
    }
    
    @GetMapping("/category")
    public Result<List<Map<String, Object>>> getCategoryStatistics() {
        return statisticsService.getCategoryStatistics();
    }
    
    @PostMapping("/update")
    public Result<Void> updateDailyStatistics() {
        return statisticsService.updateDailyStatistics();
    }
}
