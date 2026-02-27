-- ==========================================
-- 公益捐赠管理系统 - 最终数据库脚本
-- Charity Donation Management System - Final Database Script
-- ==========================================
-- 数据库名称：charity_donation
-- 字符集：utf8mb4
-- 创建时间：2026
-- 说明：包含所有表结构、索引、外键、初始数据
-- ==========================================

-- ==========================================
-- 1. 数据库初始化
-- ==========================================

-- 如果数据库已存在则删除
DROP DATABASE IF EXISTS charity_donation;

-- 创建数据库，使用utf8mb4字符集（支持emoji等特殊字符）
CREATE DATABASE charity_donation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用该数据库
USE charity_donation;

-- ==========================================
-- 2. 用户表 (user)
-- 说明：存储系统用户信息，包括管理员和普通用户
-- ==========================================

CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID，主键，自增',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名，唯一，用于登录',
    `password` VARCHAR(255) NOT NULL COMMENT '密码，BCrypt加密存储',
    `real_name` VARCHAR(50) COMMENT '真实姓名',
    `phone` VARCHAR(20) COMMENT '手机号码',
    `email` VARCHAR(100) COMMENT '电子邮箱',
    `id_card` VARCHAR(20) COMMENT '身份证号（可选）',
    `avatar` VARCHAR(255) DEFAULT '/default-avatar.jpg' COMMENT '用户头像URL，默认头像',
    `role` TINYINT DEFAULT 0 COMMENT '用户角色：0-普通用户，1-管理员',
    `status` TINYINT DEFAULT 1 COMMENT '用户状态：0-禁用，1-正常',
    `total_donation` DECIMAL(15,2) DEFAULT 0.00 COMMENT '累计捐赠金额，单位：元',
    `registration_date` DATETIME COMMENT '注册日期',
    `last_login_date` DATETIME COMMENT '最后登录日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    -- 索引定义
    INDEX idx_username (`username`) COMMENT '用户名索引，加速登录查询',
    INDEX idx_role (`role`) COMMENT '角色索引，加速按角色筛选',
    INDEX idx_status (`status`) COMMENT '状态索引，加速按状态筛选'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表：存储系统用户信息';

-- ==========================================
-- 3. 捐赠项目表 (donation_project)
-- 说明：存储捐赠项目信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `donation_project` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '项目ID，主键，自增',
    `project_name` VARCHAR(200) NOT NULL COMMENT '项目名称',
    `category` VARCHAR(50) COMMENT '项目分类：教育助学/医疗救助/扶贫济困/环保公益',
    `description` TEXT COMMENT '项目详细描述',
    `cover_image` VARCHAR(255) COMMENT '项目封面图片URL',
    `target_amount` DECIMAL(15,2) NOT NULL DEFAULT 0.00 COMMENT '目标金额，单位：元',
    `current_amount` DECIMAL(15,2) DEFAULT 0.00 COMMENT '当前已筹金额，单位：元',
    `donor_count` INT DEFAULT 0 COMMENT '捐赠人次',
    `view_count` INT DEFAULT 0 COMMENT '浏览次数',
    `beneficiary` VARCHAR(200) COMMENT '受益人信息',
    `location` VARCHAR(200) COMMENT '项目地点',
    `start_date` DATETIME COMMENT '项目开始日期',
    `end_date` DATETIME COMMENT '项目结束日期',
    `status` TINYINT DEFAULT 0 COMMENT '项目状态：0-待审核，1-进行中，2-已完成，3-已关闭',
    `thank_message` TEXT COMMENT '感谢留言，管理员发布',
    `create_by` BIGINT COMMENT '创建人ID，关联user表',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    -- 索引定义
    INDEX idx_category (`category`) COMMENT '分类索引，加速按分类筛选',
    INDEX idx_status (`status`) COMMENT '状态索引，加速按状态筛选',
    INDEX idx_create_by (`create_by`) COMMENT '创建人索引，加速查询创建人的项目'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠项目表：存储捐赠项目信息';

-- ==========================================
-- 4. 捐赠记录表 (donation_record)
-- 说明：存储用户的捐赠记录
-- ==========================================

CREATE TABLE IF NOT EXISTS `donation_record` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID，主键，自增',
    `user_id` BIGINT COMMENT '用户ID，关联user表，为空表示匿名捐赠',
    `project_id` BIGINT NOT NULL COMMENT '项目ID，关联donation_project表',
    `amount` DECIMAL(15,2) NOT NULL COMMENT '捐赠金额，单位：元',
    `payment_method` VARCHAR(50) DEFAULT 'alipay' COMMENT '支付方式：alipay-支付宝，wechat-微信，bank-银行卡',
    `transaction_id` VARCHAR(100) COMMENT '交易流水号（模拟）',
    `donation_no` VARCHAR(100) UNIQUE NOT NULL COMMENT '捐赠编号，唯一标识，格式：DON+yyyyMMdd+6位序号',
    `message` TEXT COMMENT '捐赠留言',
    `is_anonymous` TINYINT DEFAULT 0 COMMENT '是否匿名：0-否，1-是',
    `status` TINYINT DEFAULT 1 COMMENT '捐赠状态：0-待支付，1-已支付，2-已取消，3-已退款',
    `donation_date` DATETIME COMMENT '捐赠日期时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    -- 索引定义
    INDEX idx_user_id (`user_id`) COMMENT '用户ID索引，加速查询用户的捐赠记录',
    INDEX idx_project_id (`project_id`) COMMENT '项目ID索引，加速查询项目的捐赠记录',
    INDEX idx_status (`status`) COMMENT '状态索引，加速按状态筛选',
    INDEX idx_donation_date (`donation_date`) COMMENT '捐赠日期索引，加速按日期查询',
    INDEX idx_donation_no (`donation_no`) COMMENT '捐赠编号索引，加速按编号查询',
    -- 外键约束
    FOREIGN KEY (`project_id`) REFERENCES `donation_project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠记录表：存储用户的捐赠记录';

-- ==========================================
-- 5. 评论表 (comment)
-- 说明：存储项目评论信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `comment` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论ID，主键，自增',
    `project_id` BIGINT NOT NULL COMMENT '项目ID，关联donation_project表',
    `user_id` BIGINT COMMENT '用户ID，关联user表',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `likes_count` INT DEFAULT 0 COMMENT '点赞数',
    `status` TINYINT DEFAULT 1 COMMENT '评论状态：0-隐藏，1-显示，2-已删除',
    `comment_date` DATETIME COMMENT '评论日期时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    -- 索引定义
    INDEX idx_project_id (`project_id`) COMMENT '项目ID索引，加速查询项目的评论',
    INDEX idx_user_id (`user_id`) COMMENT '用户ID索引，加速查询用户的评论',
    INDEX idx_status (`status`) COMMENT '状态索引，加速按状态筛选',
    -- 外键约束
    FOREIGN KEY (`project_id`) REFERENCES `donation_project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表：存储项目评论信息';

-- ==========================================
-- 6. 通知表 (notification)
-- 说明：存储系统通知信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `notification` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '通知ID，主键，自增',
    `user_id` BIGINT COMMENT '用户ID，为空表示系统通知（所有用户可见）',
    `title` VARCHAR(200) NOT NULL COMMENT '通知标题',
    `content` TEXT COMMENT '通知内容',
    `type` TINYINT DEFAULT 1 COMMENT '通知类型：1-系统通知，2-捐赠通知，3-活动通知',
    `is_read` TINYINT DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    `send_date` DATETIME COMMENT '发送日期时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    -- 索引定义
    INDEX idx_user_id (`user_id`) COMMENT '用户ID索引，加速查询用户的通知',
    INDEX idx_is_read (`is_read`) COMMENT '已读状态索引，加速统计未读数量',
    INDEX idx_send_date (`send_date`) COMMENT '发送日期索引，加速按日期排序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表：存储系统通知信息';

-- ==========================================
-- 7. 数据统计表 (statistics)
-- 说明：存储每日统计数据，用于数据可视化展示
-- ==========================================

CREATE TABLE IF NOT EXISTS `statistics` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '统计ID，主键，自增',
    `stat_date` DATE NOT NULL UNIQUE COMMENT '统计日期，唯一',
    `total_donation_amount` DECIMAL(15,2) DEFAULT 0.00 COMMENT '当日捐赠总额，单位：元',
    `total_donation_count` INT DEFAULT 0 COMMENT '当日捐赠次数',
    `total_project_count` INT DEFAULT 0 COMMENT '项目总数',
    `total_user_count` INT DEFAULT 0 COMMENT '用户总数',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    -- 索引定义
    INDEX idx_stat_date (`stat_date`) COMMENT '统计日期索引，加速按日期查询'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据统计表：存储每日统计数据';

-- ==========================================
-- 8. 用户偏好表 (user_preference)
-- 说明：存储用户的捐赠偏好数据，用于AI智能推荐
-- ==========================================

CREATE TABLE IF NOT EXISTS `user_preference` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '偏好ID，主键，自增',
    `user_id` BIGINT NOT NULL COMMENT '用户ID，关联user表',
    `category` VARCHAR(50) NOT NULL COMMENT '项目分类：教育助学/医疗救助/扶贫济困/环保公益',
    `score` DECIMAL(10,2) DEFAULT 0.0 COMMENT '偏好得分，用于推荐排序',
    `view_count` INT DEFAULT 0 COMMENT '该分类浏览次数',
    `donation_count` INT DEFAULT 0 COMMENT '该分类捐赠次数',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    -- 索引定义
    UNIQUE KEY uk_user_category (`user_id`, `category`) COMMENT '用户分类唯一索引，防止重复',
    INDEX idx_user_id (`user_id`) COMMENT '用户ID索引，加速查询用户的偏好'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户偏好表：存储用户的捐赠偏好数据，用于AI推荐';

-- ==========================================
-- 9. 系统配置表 (system_config)
-- 说明：存储系统配置信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `system_config` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '配置ID，主键，自增',
    `config_key` VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键，唯一标识',
    `config_value` TEXT COMMENT '配置值',
    `description` VARCHAR(255) COMMENT '配置描述',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间，自动更新',
    -- 索引定义
    INDEX idx_config_key (`config_key`) COMMENT '配置键索引，加速按键查询'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表：存储系统配置信息';

-- ==========================================
-- 10. 插入初始数据
-- ==========================================

-- ==========================================
-- 10.1 插入默认管理员账号
-- 说明：用户名 admin，密码 123456（BCrypt加密）
-- ==========================================

INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`, `registration_date`)
VALUES (
    'admin', 
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 
    '系统管理员', 
    1, 
    1, 
    NOW()
);

-- ==========================================
-- 10.2 插入测试用户账号
-- 说明：用户名 user1/user2，密码 123456
-- ==========================================

INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`, `registration_date`) VALUES
('user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '张三', 0, 1, NOW()),
('user2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '李四', 0, 1, NOW());

-- ==========================================
-- 10.3 插入测试捐赠项目数据
-- 分类：教育助学、医疗救助、扶贫济困、环保公益
-- ==========================================

INSERT INTO `donation_project` (
    `project_name`,
    `category`,
    `description`,
    `cover_image`,
    `target_amount`,
    `current_amount`,
    `donor_count`,
    `view_count`,
    `beneficiary`,
    `location`,
    `start_date`,
    `end_date`,
    `status`,
    `create_by`,
    `thank_message`
) VALUES
(
    '教育助学计划', 
    '教育助学', 
    '为贫困地区的学生提供教育资助，帮助他们完成学业，改变命运。我们相信教育是改变未来的钥匙，每一份捐赠都能为孩子们带来希望。',
    '/教育助学.png',
    100000.00, 
    35680.00, 
    128, 
    2560, 
    '贫困学生', 
    '四川凉山', 
    '2024-01-01 00:00:00', 
    '2024-12-31 23:59:59', 
    1, 
    1,
    '感谢所有爱心人士的支持，孩子们的未来因您而改变！'
),
(
    '乡村医疗救助', 
    '医疗救助', 
    '为偏远地区的村民提供基础医疗保障，改善医疗条件。让每一个人都能享受到基本的医疗服务，不再因病致贫。',
    '/医疗救助.png',
    50000.00, 
    12500.00, 
    45, 
    1230, 
    '乡村村民', 
    '云南怒江', 
    '2024-01-15 00:00:00', 
    '2024-06-30 23:59:59', 
    1, 
    1,
    '您的每一分捐赠都能为需要帮助的人带来健康和希望！'
),
(
    '绿色地球守护计划', 
    '环保公益', 
    '共同守护我们的地球家园，参与植树造林、垃圾分类、海洋清洁等环保行动。让我们的子孙后代也能看到蓝天碧水。',
    '/环保公益.png',
    150000.00, 
    45200.00, 
    186, 
    3250, 
    '地球环境', 
    '全国范围', 
    '2024-03-01 00:00:00', 
    '2024-12-31 23:59:59', 
    1, 
    1,
    '保护环境，从我做起。感谢您为地球做出的贡献！'
),
(
    '灾害救援基金', 
    '扶贫济困', 
    '为受灾地区提供紧急救援和重建支持，帮助灾区人民渡过难关。当灾难来临时，我们与灾区人民同在。',
    '/扶贫救济.png',
    200000.00, 
    45000.00, 
    156, 
    4120, 
    '灾区群众', 
    '全国范围', 
    '2024-01-01 00:00:00', 
    '2024-12-31 23:59:59', 
    1, 
    1,
    '感谢您在灾难面前伸出援手，灾区人民会记住您的爱心！'
),
(
    '温暖困难家庭', 
    '扶贫济困', 
    '为贫困家庭提供生活救助，改善他们的生活条件。让每个家庭都能感受到社会的温暖，过上有尊严的生活。',
    '/扶贫救济.png',
    80000.00, 
    22000.00, 
    88, 
    1890, 
    '困难家庭', 
    '贵州黔东南', 
    '2024-01-10 00:00:00', 
    '2024-11-30 23:59:59', 
    1, 
    1,
    '您的善举将温暖一个家庭，改变他们的生活！'
);

-- ==========================================
-- 10.4 插入测试捐赠记录数据
-- ==========================================

INSERT INTO `donation_record` (
    `user_id`,
    `project_id`,
    `amount`,
    `payment_method`,
    `donation_no`,
    `message`,
    `is_anonymous`,
    `status`,
    `donation_date`
) VALUES
(2, 1, 500.00, 'alipay', 'DON20240220001', '希望孩子们能好好学习！', 0, 1, '2024-02-20 10:30:00'),
(2, 2, 300.00, 'wechat', 'DON20240221001', '一点心意，希望能帮到他们', 0, 1, '2024-02-21 14:20:00'),
(3, 1, 1000.00, 'alipay', 'DON20240222001', '支持教育事业！', 1, 1, '2024-02-22 09:15:00'),
(3, 3, 200.00, 'wechat', 'DON20240223001', '保护环境，人人有责', 0, 1, '2024-02-23 16:45:00'),
(2, 4, 800.00, 'bank', 'DON20240224001', '希望灾区早日恢复', 0, 1, '2024-02-24 11:00:00');

-- ==========================================
-- 10.5 插入测试评论数据
-- ==========================================

INSERT INTO `comment` (
    `project_id`,
    `user_id`,
    `content`,
    `likes_count`,
    `status`,
    `comment_date`
) VALUES
(1, 2, '这个项目很有意义，支持！', 15, 1, '2024-02-20 11:00:00'),
(1, 3, '希望能看到更多这样的项目', 8, 1, '2024-02-21 15:30:00'),
(2, 2, '医疗救助很重要，加油！', 12, 1, '2024-02-22 10:15:00'),
(3, 3, '环保公益，从我做起', 20, 1, '2024-02-23 17:00:00');

-- ==========================================
-- 10.6 插入测试通知数据
-- ==========================================

INSERT INTO `notification` (
    `user_id`,
    `title`,
    `content`,
    `type`,
    `is_read`,
    `send_date`
) VALUES
(2, '捐赠成功通知', '您的捐赠已成功，感谢您的爱心！', 2, 0, '2024-02-20 10:35:00'),
(3, '项目更新通知', '您关注的项目有新进展，请查看详情。', 3, 0, '2024-02-21 09:00:00'),
(NULL, '系统公告', '欢迎使用公益捐赠管理系统！', 1, 0, '2024-01-01 00:00:00');

-- ==========================================
-- 10.7 插入测试统计数据
-- ==========================================

INSERT INTO `statistics` (
    `stat_date`,
    `total_donation_amount`,
    `total_donation_count`,
    `total_project_count`,
    `total_user_count`
) VALUES
('2024-02-20', 500.00, 1, 5, 3),
('2024-02-21', 300.00, 1, 5, 3),
('2024-02-22', 1000.00, 1, 5, 3),
('2024-02-23', 200.00, 1, 5, 3),
('2024-02-24', 800.00, 1, 5, 3);

-- ==========================================
-- 10.8 插入测试用户偏好数据
-- ==========================================

INSERT INTO `user_preference` (
    `user_id`,
    `category`,
    `score`,
    `view_count`,
    `donation_count`
) VALUES
(2, '教育助学', 7.0, 2, 1),
(2, '医疗救助', 6.0, 1, 1),
(2, '扶贫济困', 5.0, 1, 1),
(3, '教育助学', 6.0, 1, 1),
(3, '环保公益', 6.0, 1, 1);

-- ==========================================
-- 10.9 插入系统配置数据
-- ==========================================

INSERT INTO `system_config` (
    `config_key`,
    `config_value`,
    `description`
) VALUES
('system_name', '公益捐赠管理系统', '系统名称'),
('system_version', '1.0.0', '系统版本号'),
('backend_url', 'http://localhost:8083/api', '后端服务地址'),
('max_upload_size', '5242880', '最大上传文件大小（字节），默认5MB'),
('allowed_image_types', 'jpg,jpeg,png', '允许上传的图片类型');

-- ==========================================
-- 11. 数据库初始化完成
-- ==========================================

-- 显示完成信息
SELECT '=========================================' AS message;
SELECT '公益捐赠管理系统数据库初始化完成！' AS message;
SELECT '=========================================' AS message;
SELECT '' AS '';
SELECT '测试账号信息：' AS message;
SELECT '用户名：admin，密码：123456（管理员）' AS admin_account;
SELECT '用户名：user1，密码：123456（普通用户）' AS user1_account;
SELECT '用户名：user2，密码：123456（普通用户）' AS user2_account;
SELECT '' AS '';
SELECT '项目分类：教育助学、医疗救助、扶贫济困、环保公益' AS categories;
SELECT '=========================================' AS message;
