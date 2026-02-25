package com.charity.service;

import com.charity.dto.DonationResponse;
import com.charity.dto.Result;
import com.charity.entity.DonationProject;
import com.charity.entity.DonationRecord;
import com.charity.entity.User;
import com.charity.repository.DonationProjectRepository;
import com.charity.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Service
public class DonationProjectService {

    @Autowired
    private DonationProjectRepository donationProjectRepository;

    @Autowired
    private DonationRecordService donationRecordService;
    
    @Autowired
    private UserRepository userRepository;

    public Result<Page<DonationProject>> getProjectList(Integer pageNum, Integer pageSize, String category, Integer status) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize, Sort.by(Sort.Direction.DESC, "createTime"));
        Page<DonationProject> result;
        
        if (category != null && !category.isEmpty() && status != null) {
            result = donationProjectRepository.findByCategoryAndStatus(category, status, pageable);
        } else if (category != null && !category.isEmpty()) {
            result = donationProjectRepository.findByCategory(category, pageable);
        } else if (status != null) {
            result = donationProjectRepository.findByStatus(status, pageable);
        } else {
            result = donationProjectRepository.findAll(pageable);
        }
        
        return Result.success(result);
    }

    public Result<DonationProject> getProjectDetail(Long id) {
        Optional<DonationProject> projectOpt = donationProjectRepository.findById(id);
        if (projectOpt.isEmpty()) {
            return Result.error("项目不存在");
        }
        DonationProject project = projectOpt.get();
        project.setViewCount(project.getViewCount() + 1);
        donationProjectRepository.save(project);
        return Result.success(project);
    }

    @Transactional
    public Result<Void> createProject(DonationProject project) {
        project.setCurrentAmount(BigDecimal.ZERO);
        project.setDonorCount(0);
        project.setViewCount(0);
        project.setStatus(0);
        donationProjectRepository.save(project);
        return Result.success();
    }

    public Result<Void> updateProject(DonationProject project) {
        Optional<DonationProject> existingProjectOpt = donationProjectRepository.findById(project.getId());
        if (existingProjectOpt.isEmpty()) {
            return Result.error("项目不存在");
        }
        
        DonationProject existingProject = existingProjectOpt.get();
        
        if (project.getProjectName() != null) {
            existingProject.setProjectName(project.getProjectName());
        }
        if (project.getCategory() != null) {
            existingProject.setCategory(project.getCategory());
        }
        if (project.getDescription() != null) {
            existingProject.setDescription(project.getDescription());
        }
        if (project.getCoverImage() != null) {
            existingProject.setCoverImage(project.getCoverImage());
        }
        if (project.getTargetAmount() != null) {
            existingProject.setTargetAmount(project.getTargetAmount());
        }
        if (project.getBeneficiary() != null) {
            existingProject.setBeneficiary(project.getBeneficiary());
        }
        if (project.getLocation() != null) {
            existingProject.setLocation(project.getLocation());
        }
        if (project.getStartDate() != null) {
            existingProject.setStartDate(project.getStartDate());
        }
        if (project.getEndDate() != null) {
            existingProject.setEndDate(project.getEndDate());
        }
        if (project.getStatus() != null) {
            existingProject.setStatus(project.getStatus());
        }
        if (project.getThankMessage() != null) {
            existingProject.setThankMessage(project.getThankMessage());
        }
        
        donationProjectRepository.save(existingProject);
        return Result.success();
    }

    public Result<Void> deleteProject(Long id) {
        donationProjectRepository.deleteById(id);
        return Result.success();
    }

    @Transactional
    public Result<DonationResponse> donate(Long userId, Long projectId, BigDecimal amount, String message, Integer isAnonymous) {
        Optional<DonationProject> projectOpt = donationProjectRepository.findById(projectId);
        if (projectOpt.isEmpty()) {
            return Result.error("项目不存在");
        }
        DonationProject project = projectOpt.get();
        if (project.getStatus() != 1) {
            return Result.error("项目未开放捐赠");
        }

        String donationNo = "DON" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + 
                          String.format("%04d", (int)(Math.random() * 10000));

        DonationRecord record = new DonationRecord();
        record.setUserId(userId);
        record.setProjectId(projectId);
        record.setAmount(amount);
        record.setPaymentMethod("支付宝");
        record.setDonationNo(donationNo);
        record.setMessage(message);
        record.setIsAnonymous(isAnonymous);
        record.setStatus(1);
        donationRecordService.save(record);

        project.setCurrentAmount(project.getCurrentAmount().add(amount));
        project.setDonorCount(project.getDonorCount() + 1);
        
        if (project.getCurrentAmount().compareTo(project.getTargetAmount()) >= 0) {
            project.setStatus(2);
        }
        donationProjectRepository.save(project);

        Optional<User> userOpt = userRepository.findById(userId);
        User user = userOpt.orElse(null);
        if (user != null) {
            if (user.getTotalDonation() == null) {
                user.setTotalDonation(BigDecimal.ZERO);
            }
            user.setTotalDonation(user.getTotalDonation().add(amount));
            userRepository.save(user);
        }
        
        DonationResponse response = new DonationResponse();
        response.setDonationRecord(record);
        response.setUser(user);
        response.setProject(project);

        return Result.success(response);
    }
}
