package com.charity.controller;

import com.charity.dto.Result;
import com.charity.entity.SystemConfig;
import com.charity.service.SystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/system-config")
public class SystemConfigController {

    @Autowired
    private SystemConfigService systemConfigService;

    @GetMapping("/home-background")
    public Result<String> getHomeBackground() {
        String imageUrl = systemConfigService.getHomeBackgroundImage();
        return Result.success(imageUrl);
    }

    @PutMapping("/home-background")
    public Result<SystemConfig> setHomeBackground(@RequestBody String imageUrl) {
        SystemConfig config = systemConfigService.setHomeBackgroundImage(imageUrl);
        return Result.success(config);
    }
}
