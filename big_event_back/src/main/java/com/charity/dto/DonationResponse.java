package com.charity.dto;

import com.charity.entity.DonationProject;
import com.charity.entity.DonationRecord;
import com.charity.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DonationResponse {
    private DonationRecord donationRecord;
    private User user;
    private DonationProject project;
}
