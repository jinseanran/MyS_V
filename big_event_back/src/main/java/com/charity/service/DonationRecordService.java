package com.charity.service;

import com.charity.dto.Result;
import com.charity.entity.DonationRecord;
import com.charity.repository.DonationRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class DonationRecordService {

    @Autowired
    private DonationRecordRepository donationRecordRepository;

    public Result<Page<DonationRecord>> getRecordList(Integer pageNum, Integer pageSize, Long userId, Long projectId) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize, Sort.by(Sort.Direction.DESC, "createTime"));
        Page<DonationRecord> result;
        
        if (userId != null) {
            result = donationRecordRepository.findByUserId(userId, pageable);
        } else if (projectId != null) {
            result = donationRecordRepository.findByProjectId(projectId, pageable);
        } else {
            result = donationRecordRepository.findAll(pageable);
        }
        
        return Result.success(result);
    }

    public Result<DonationRecord> getRecordByNo(String donationNo) {
        Optional<DonationRecord> recordOpt = donationRecordRepository.findAll().stream()
                .filter(r -> donationNo.equals(r.getDonationNo()))
                .findFirst();
        if (recordOpt.isEmpty()) {
            return Result.error("捐赠记录不存在");
        }
        return Result.success(recordOpt.get());
    }

    public void save(DonationRecord record) {
        donationRecordRepository.save(record);
    }

    public long count() {
        return donationRecordRepository.count();
    }
}
