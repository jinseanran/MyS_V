package com.charity.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "statistics")
public class Statistics {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "stat_date")
    private LocalDate statDate;
    
    @Column(name = "total_donation_amount", precision = 15, scale = 2)
    private BigDecimal totalDonationAmount;
    
    @Column(name = "total_donation_count")
    private Integer totalDonationCount;
    
    @Column(name = "total_project_count")
    private Integer totalProjectCount;
    
    @Column(name = "total_user_count")
    private Integer totalUserCount;
    
    @Column(name = "create_time")
    private LocalDateTime createTime;
    
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getStatDate() {
        return statDate;
    }

    public void setStatDate(LocalDate statDate) {
        this.statDate = statDate;
    }

    public BigDecimal getTotalDonationAmount() {
        return totalDonationAmount;
    }

    public void setTotalDonationAmount(BigDecimal totalDonationAmount) {
        this.totalDonationAmount = totalDonationAmount;
    }

    public Integer getTotalDonationCount() {
        return totalDonationCount;
    }

    public void setTotalDonationCount(Integer totalDonationCount) {
        this.totalDonationCount = totalDonationCount;
    }

    public Integer getTotalProjectCount() {
        return totalProjectCount;
    }

    public void setTotalProjectCount(Integer totalProjectCount) {
        this.totalProjectCount = totalProjectCount;
    }

    public Integer getTotalUserCount() {
        return totalUserCount;
    }

    public void setTotalUserCount(Integer totalUserCount) {
        this.totalUserCount = totalUserCount;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }
}
