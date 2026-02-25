package com.charity.service;

import com.charity.dto.Result;
import com.charity.entity.DonationProject;
import com.charity.entity.DonationRecord;
import com.charity.entity.User;
import com.charity.repository.DonationProjectRepository;
import com.charity.repository.DonationRecordRepository;
import com.charity.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class CertificateService {
    
    @Autowired
    private DonationRecordRepository donationRecordRepository;
    
    @Autowired
    private DonationProjectRepository donationProjectRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public Result<Map<String, Object>> generateCertificate(String donationNo) {
        Optional<DonationRecord> recordOpt = donationRecordRepository.findByDonationNo(donationNo);
        if (recordOpt.isEmpty()) {
            return Result.error("捐赠记录不存在");
        }
        
        DonationRecord record = recordOpt.get();
        Optional<DonationProject> projectOpt = donationProjectRepository.findById(record.getProjectId());
        Optional<User> userOpt = userRepository.findById(record.getUserId());
        
        Map<String, Object> certificate = new HashMap<>();
        certificate.put("donationNo", record.getDonationNo());
        certificate.put("amount", record.getAmount());
        certificate.put("projectName", projectOpt.isPresent() ? projectOpt.get().getProjectName() : "未知项目");
        certificate.put("donorName", record.getIsAnonymous() == 1 ? "爱心人士" : 
                            (userOpt.isPresent() ? userOpt.get().getRealName() : "爱心人士"));
        certificate.put("donationDate", record.getDonationDate().format(DateTimeFormatter.ofPattern("yyyy年MM月dd日")));
        certificate.put("message", record.getMessage());
        
        return Result.success(certificate);
    }
}
