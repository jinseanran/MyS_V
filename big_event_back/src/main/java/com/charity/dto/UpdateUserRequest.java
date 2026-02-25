package com.charity.dto;

import lombok.Data;

@Data
public class UpdateUserRequest {
    private String realName;
    private String phone;
    private String email;
    private String avatar;
}
