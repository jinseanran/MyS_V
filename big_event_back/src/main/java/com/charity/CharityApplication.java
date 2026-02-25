package com.charity;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories(basePackages = "com.charity.repository")
public class CharityApplication {
    public static void main(String[] args) {
        SpringApplication.run(CharityApplication.class, args);
        System.out.println("========================================");
        System.out.println("  公益捐赠管理系统启动成功！");
        System.out.println("  后端地址: http://localhost:8083/api");
        System.out.println("========================================");
    }
}
