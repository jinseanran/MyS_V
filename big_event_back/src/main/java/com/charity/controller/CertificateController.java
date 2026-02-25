package com.charity.controller;

import com.charity.dto.DonationResponse;
import com.charity.dto.Result;
import com.charity.entity.DonationProject;
import com.charity.entity.DonationRecord;
import com.charity.entity.User;
import com.charity.repository.DonationProjectRepository;
import com.charity.repository.DonationRecordRepository;
import com.charity.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/certificate")
@CrossOrigin
public class CertificateController {

    @Autowired
    private DonationRecordRepository donationRecordRepository;

    @Autowired
    private DonationProjectRepository donationProjectRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/generate")
    public Result<DonationResponse> generateCertificate(@RequestParam Long recordId) {
        Optional<DonationRecord> recordOpt = donationRecordRepository.findById(recordId);
        if (recordOpt.isEmpty()) {
            return Result.error("捐赠记录不存在");
        }

        DonationRecord record = recordOpt.get();
        Optional<User> userOpt = userRepository.findById(record.getUserId());
        User user = userOpt.orElse(null);
        
        Optional<DonationProject> projectOpt = donationProjectRepository.findById(record.getProjectId());
        DonationProject project = projectOpt.orElse(null);

        DonationResponse response = new DonationResponse();
        response.setDonationRecord(record);
        response.setUser(user);
        response.setProject(project);

        return Result.success(response);
    }
}
