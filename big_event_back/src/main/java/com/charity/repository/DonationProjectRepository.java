package com.charity.repository;

import com.charity.entity.DonationProject;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DonationProjectRepository extends JpaRepository<DonationProject, Long> {
    Page<DonationProject> findByStatus(Integer status, Pageable pageable);
    Page<DonationProject> findByCategory(String category, Pageable pageable);
    List<DonationProject> findByStatusOrderByCreateTimeDesc(Integer status);
    
    Page<DonationProject> findByCategoryAndStatus(String category, Integer status, Pageable pageable);
    
    @Query("SELECT p.category, COALESCE(SUM(p.currentAmount), 0) FROM DonationProject p GROUP BY p.category")
    List<Object[]> sumAmountByCategory();
}
