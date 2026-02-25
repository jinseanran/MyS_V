-- ==========================================
-- 公益捐赠管理系统 - 完整数据库脚本
-- Charity Donation Management System - Full Database Script
-- ==========================================
-- 数据库名称：charity_donation
-- 字符集：utf8mb4
-- 创建时间：2024
-- ==========================================

-- ==========================================
-- 1. 数据库初始化
-- ==========================================

DROP DATABASE IF EXISTS charity_donation;
CREATE DATABASE charity_donation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE charity_donation;

-- ==========================================
-- 2. 用户表 (user)
-- 说明：存储系统用户信息，包括管理员和普通用户
-- ==========================================

CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID，主键',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名，唯一',
    `password` VARCHAR(255) NOT NULL COMMENT '密码，BCrypt加密存储',
    `real_name` VARCHAR(50) COMMENT '真实姓名',
    `phone` VARCHAR(20) COMMENT '手机号码',
    `email` VARCHAR(100) COMMENT '电子邮箱',
    `id_card` VARCHAR(20) COMMENT '身份证号',
    `avatar` VARCHAR(255) DEFAULT '/default-avatar.jpg' COMMENT '用户头像URL',
    `role` TINYINT DEFAULT 0 COMMENT '用户角色：0-普通用户，1-管理员',
    `status` TINYINT DEFAULT 1 COMMENT '用户状态：0-禁用，1-正常',
    `total_donation` DECIMAL(15,2) DEFAULT 0.00 COMMENT '累计捐赠金额',
    `registration_date` DATETIME COMMENT '注册日期',
    `last_login_date` DATETIME COMMENT '最后登录日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (`username`) COMMENT '用户名索引',
    INDEX idx_role (`role`) COMMENT '角色索引',
    INDEX idx_status (`status`) COMMENT '状态索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ==========================================
-- 3. 捐赠项目表 (donation_project)
-- 说明：存储捐赠项目信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `donation_project` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '项目ID，主键',
    `project_name` VARCHAR(200) NOT NULL COMMENT '项目名称',
    `category` VARCHAR(50) COMMENT '项目分类：教育助学/医疗救助/扶贫济困/环保公益',
    `description` TEXT COMMENT '项目描述',
    `cover_image` VARCHAR(255) COMMENT '项目封面图片URL',
    `target_amount` DECIMAL(15,2) NOT NULL DEFAULT 0.00 COMMENT '目标金额',
    `current_amount` DECIMAL(15,2) DEFAULT 0.00 COMMENT '当前已筹金额',
    `donor_count` INT DEFAULT 0 COMMENT '捐赠人次',
    `view_count` INT DEFAULT 0 COMMENT '浏览次数',
    `beneficiary` VARCHAR(200) COMMENT '受益人',
    `location` VARCHAR(200) COMMENT '项目地点',
    `start_date` DATETIME COMMENT '开始日期',
    `end_date` DATETIME COMMENT '结束日期',
    `status` TINYINT DEFAULT 0 COMMENT '项目状态：0-待审核，1-进行中，2-已完成，3-已关闭',
    `thank_message` TEXT COMMENT '感谢留言',
    `create_by` BIGINT COMMENT '创建人ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_category (`category`) COMMENT '分类索引',
    INDEX idx_status (`status`) COMMENT '状态索引',
    INDEX idx_create_by (`create_by`) COMMENT '创建人索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠项目表';

-- ==========================================
-- 4. 捐赠记录表 (donation_record)
-- 说明：存储用户的捐赠记录
-- ==========================================

CREATE TABLE IF NOT EXISTS `donation_record` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID，主键',
    `user_id` BIGINT COMMENT '用户ID',
    `project_id` BIGINT NOT NULL COMMENT '项目ID',
    `amount` DECIMAL(15,2) NOT NULL COMMENT '捐赠金额',
    `payment_method` VARCHAR(50) DEFAULT 'alipay' COMMENT '支付方式：alipay-支付宝，wechat-微信，bank-银行卡',
    `transaction_id` VARCHAR(100) COMMENT '交易流水号',
    `donation_no` VARCHAR(100) COMMENT '捐赠编号',
    `message` TEXT COMMENT '捐赠留言',
    `is_anonymous` TINYINT DEFAULT 0 COMMENT '是否匿名：0-否，1-是',
    `status` TINYINT DEFAULT 1 COMMENT '捐赠状态：0-待支付，1-已支付，2-已取消',
    `donation_date` DATETIME COMMENT '捐赠日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (`user_id`) COMMENT '用户ID索引',
    INDEX idx_project_id (`project_id`) COMMENT '项目ID索引',
    INDEX idx_status (`status`) COMMENT '状态索引',
    INDEX idx_donation_date (`donation_date`) COMMENT '捐赠日期索引',
    INDEX idx_donation_no (`donation_no`) COMMENT '捐赠编号索引',
    FOREIGN KEY (`project_id`) REFERENCES `donation_project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠记录表';

-- ==========================================
-- 5. 评论表 (comment)
-- 说明：存储项目评论信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `comment` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论ID，主键',
    `project_id` BIGINT NOT NULL COMMENT '项目ID',
    `user_id` BIGINT COMMENT '用户ID',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `likes_count` INT DEFAULT 0 COMMENT '点赞数',
    `status` TINYINT DEFAULT 1 COMMENT '评论状态：0-隐藏，1-显示',
    `comment_date` DATETIME COMMENT '评论日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_project_id (`project_id`) COMMENT '项目ID索引',
    INDEX idx_user_id (`user_id`) COMMENT '用户ID索引',
    INDEX idx_status (`status`) COMMENT '状态索引',
    FOREIGN KEY (`project_id`) REFERENCES `donation_project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- ==========================================
-- 6. 通知表 (notification)
-- 说明：存储系统通知信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `notification` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '通知ID，主键',
    `user_id` BIGINT COMMENT '用户ID，为空表示系统通知',
    `title` VARCHAR(200) NOT NULL COMMENT '通知标题',
    `content` TEXT COMMENT '通知内容',
    `type` TINYINT DEFAULT 1 COMMENT '通知类型：1-系统通知，2-捐赠提醒，3-项目更新',
    `is_read` TINYINT DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    `send_date` DATETIME COMMENT '发送日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (`user_id`) COMMENT '用户ID索引',
    INDEX idx_is_read (`is_read`) COMMENT '已读状态索引',
    INDEX idx_send_date (`send_date`) COMMENT '发送日期索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表';

-- ==========================================
-- 7. 菜单权限表 (menu)
-- 说明：存储系统菜单和权限信息
-- ==========================================

CREATE TABLE IF NOT EXISTS `menu` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '菜单ID，主键',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父菜单ID，0表示顶级菜单',
    `menu_name` VARCHAR(50) NOT NULL COMMENT '菜单名称',
    `menu_type` TINYINT DEFAULT 1 COMMENT '菜单类型：1-目录，2-菜单，3-按钮',
    `path` VARCHAR(200) COMMENT '路由路径',
    `component` VARCHAR(200) COMMENT '组件路径',
    `icon` VARCHAR(50) COMMENT '菜单图标',
    `permission` VARCHAR(100) COMMENT '权限标识',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    `status` TINYINT DEFAULT 1 COMMENT '菜单状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_parent_id (`parent_id`) COMMENT '父菜单索引',
    INDEX idx_status (`status`) COMMENT '状态索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

-- ==========================================
-- 8. 插入初始数据
-- ==========================================

-- ==========================================
-- 8.1 插入默认管理员账号
-- 说明：用户名 admin，密码 123456（BCrypt加密）
-- ==========================================

INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`, `registration_date`)
VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 1, 1, NOW());

-- ==========================================
-- 8.2 插入测试用户账号
-- 说明：用户名 user1/user2，密码 123456
-- ==========================================

INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`, `registration_date`) VALUES
('user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '张三', 0, 1, NOW()),
('user2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '李四', 0, 1, NOW());

-- ==========================================
-- 8.3 插入测试捐赠项目数据
-- ==========================================

INSERT INTO `donation_project` (
    `project_name`,
    `category`,
    `description`,
    `target_amount`,
    `current_amount`,
    `donor_count`,
    `view_count`,
    `beneficiary`,
    `location`,
    `start_date`,
    `end_date`,
    `status`,
    `create_by`
) VALUES
('教育助学计划', '教育助学', '为贫困地区的学生提供教育资助，帮助他们完成学业，改变命运。', 100000.00, 35680.00, 128, 2560, '贫困学生', '四川凉山', '2024-01-01 00:00:00', '2024-12-31 23:59:59', 1, 1),
('乡村医疗救助', '医疗救助', '为偏远地区的村民提供基础医疗保障，改善医疗条件。', 50000.00, 12500.00, 45, 1230, '乡村村民', '云南怒江', '2024-01-15 00:00:00', '2024-06-30 23:59:59', 1, 1),
('绿色地球守护计划', '环保公益', '共同守护我们的地球家园，参与植树造林、垃圾分类、海洋清洁等环保行动。', 150000.00, 45200.00, 186, 3250, '地球环境', '全国范围', '2024-03-01 00:00:00', '2024-12-31 23:59:59', 1, 1),
('灾害救援基金', '扶贫济困', '为受灾地区提供紧急救援和重建支持，帮助灾区人民渡过难关。', 200000.00, 45000.00, 156, 4120, '灾区群众', '全国范围', '2024-01-01 00:00:00', '2024-12-31 23:59:59', 1, 1),
('温暖困难家庭', '扶贫济困', '为贫困家庭提供生活救助，改善他们的生活条件。', 80000.00, 22000.00, 88, 1890, '困难家庭', '贵州黔东南', '2024-01-10 00:00:00', '2024-11-30 23:59:59', 1, 1);

-- ==========================================
-- 8.4 插入测试捐赠记录数据
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
-- 8.5 插入测试评论数据
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
-- 8.6 插入测试通知数据
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
-- 8.7 插入初始菜单数据
-- ==========================================

INSERT INTO `menu` (`menu_name`, `menu_type`, `path`, `component`, `sort_order`, `status`) VALUES
('系统管理', 1, '/system', 'Layout', 1, 1),
('用户管理', 2, '/system/user', '/system/user/index', 1, 1),
('项目管理', 2, '/project', 'Layout', 2, 1),
('项目列表', 2, '/project/list', '/project/list/index', 1, 1),
('捐赠管理', 2, '/donation', 'Layout', 3, 1),
('捐赠记录', 2, '/donation/record', '/donation/record/index', 1, 1),
('审核管理', 2, '/audit', 'Layout', 4, 1),
('评论审核', 2, '/audit/comment', '/audit/comment/index', 1, 1),
('通知管理', 2, '/notice', 'Layout', 5, 1),
('通知列表', 2, '/notice/list', '/notice/list/index', 1, 1),
('数据统计', 2, '/statistics', 'Layout', 6, 1),
('数据统计', 2, '/statistics/data', '/statistics/data/index', 1, 1);

-- ==========================================
-- 9. 数据库初始化完成
-- ==========================================

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