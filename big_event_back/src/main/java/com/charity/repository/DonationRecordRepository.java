package com.charity.repository;

import com.charity.entity.DonationRecord;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface DonationRecordRepository extends JpaRepository<DonationRecord, Long> {
    Page<DonationRecord> findByUserId(Long userId, Pageable pageable);
    Page<DonationRecord> findByProjectId(Long projectId, Pageable pageable);
    List<DonationRecord> findByUserIdOrderByDonationDateDesc(Long userId);
    
    Optional<DonationRecord> findByDonationNo(String donationNo);
    
    long countByStatus(Integer status);
    
    @Query("SELECT COALESCE(SUM(d.amount), 0) FROM DonationRecord d WHERE d.status = ?1")
    BigDecimal sumTotalAmountByStatus(Integer status);
    
    @Query("SELECT COUNT(d) FROM DonationRecord d WHERE d.donationDate BETWEEN ?1 AND ?2")
    long countByDateRange(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT COALESCE(SUM(d.amount), 0) FROM DonationRecord d WHERE d.donationDate BETWEEN ?1 AND ?2")
    BigDecimal sumAmountByDateRange(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT DATE(d.donationDate) as statDate, COALESCE(SUM(d.amount), 0) as totalDonationAmount FROM DonationRecord d WHERE DATE(d.donationDate) BETWEEN ?1 AND ?2 GROUP BY DATE(d.donationDate) ORDER BY DATE(d.donationDate)")
    List<Object[]> getDailyTrend(java.time.LocalDate startDate, java.time.LocalDate endDate);
    
    @Query("SELECT COALESCE(SUM(d.amount), 0) FROM DonationRecord d WHERE d.userId = ?1 AND d.status = 1")
    BigDecimal sumTotalAmountByUserId(Long userId);
}
