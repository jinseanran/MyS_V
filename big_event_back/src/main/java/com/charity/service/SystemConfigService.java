package com.charity.service;

import com.charity.entity.SystemConfig;
import com.charity.repository.SystemConfigRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class SystemConfigService {

    @Autowired
    private SystemConfigRepository systemConfigRepository;

    public Optional<SystemConfig> getConfigByKey(String configKey) {
        return systemConfigRepository.findByConfigKey(configKey);
    }

    public SystemConfig saveOrUpdateConfig(String configKey, String configValue, String description) {
        Optional<SystemConfig> existingConfig = systemConfigRepository.findByConfigKey(configKey);
        SystemConfig config;
        if (existingConfig.isPresent()) {
            config = existingConfig.get();
            config.setConfigValue(configValue);
        } else {
            config = new SystemConfig();
            config.setConfigKey(configKey);
            config.setConfigValue(configValue);
            config.setDescription(description);
        }
        return systemConfigRepository.save(config);
    }

    public String getHomeBackgroundImage() {
        Optional<SystemConfig> config = getConfigByKey("home_background_image");
        return config.map(SystemConfig::getConfigValue).orElse(null);
    }

    public SystemConfig setHomeBackgroundImage(String imageUrl) {
        return saveOrUpdateConfig("home_background_image", imageUrl, "首页背景图片");
    }
}
