package com.charity.repository;

import com.charity.entity.Statistics;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface StatisticsRepository extends JpaRepository<Statistics, Long> {
    
    Optional<Statistics> findByStatDate(LocalDate statDate);
    
    List<Statistics> findByStatDateBetweenOrderByStatDateDesc(LocalDate startDate, LocalDate endDate);
}
