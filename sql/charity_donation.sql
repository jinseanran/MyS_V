-- ==========================================
-- Charity Donation Management System Database
-- ==========================================

DROP DATABASE IF EXISTS charity_donation_system;
CREATE DATABASE charity_donation_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE charity_donation_system;

-- User Table (includes admin)
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `real_name` VARCHAR(50),
    `phone` VARCHAR(20),
    `email` VARCHAR(100),
    `id_card` VARCHAR(20),
    `avatar` VARCHAR(255) DEFAULT '/default-avatar.jpg',
    `role` TINYINT DEFAULT 0,
    `status` TINYINT DEFAULT 1,
    `total_donation` DECIMAL(15,2) DEFAULT 0.00,
    `registration_date` DATETIME,
    `last_login_date` DATETIME,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (`username`),
    INDEX idx_role (`role`),
    INDEX idx_status (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Donation Project Table
CREATE TABLE IF NOT EXISTS `donation_project` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `project_name` VARCHAR(200) NOT NULL,
    `category` VARCHAR(50),
    `description` TEXT,
    `cover_image` VARCHAR(255),
    `target_amount` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    `current_amount` DECIMAL(15,2) DEFAULT 0.00,
    `donor_count` INT DEFAULT 0,
    `view_count` INT DEFAULT 0,
    `beneficiary` VARCHAR(200),
    `location` VARCHAR(200),
    `start_date` DATETIME,
    `end_date` DATETIME,
    `status` TINYINT DEFAULT 0,
    `create_by` BIGINT,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (`category`),
    INDEX idx_status (`status`),
    INDEX idx_create_by (`create_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Donation Record Table
CREATE TABLE IF NOT EXISTS `donation_record` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT,
    `project_id` BIGINT NOT NULL,
    `amount` DECIMAL(15,2) NOT NULL,
    `payment_method` VARCHAR(50) DEFAULT 'alipay',
    `transaction_id` VARCHAR(100),
    `message` TEXT,
    `is_anonymous` TINYINT DEFAULT 0,
    `status` TINYINT DEFAULT 1,
    `donation_date` DATETIME,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (`user_id`),
    INDEX idx_project_id (`project_id`),
    INDEX idx_status (`status`),
    INDEX idx_donation_date (`donation_date`),
    FOREIGN KEY (`project_id`) REFERENCES `donation_project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Comment Table
CREATE TABLE IF NOT EXISTS `comment` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `project_id` BIGINT NOT NULL,
    `user_id` BIGINT,
    `content` TEXT NOT NULL,
    `likes_count` INT DEFAULT 0,
    `status` TINYINT DEFAULT 1,
    `comment_date` DATETIME,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_project_id (`project_id`),
    INDEX idx_user_id (`user_id`),
    INDEX idx_status (`status`),
    FOREIGN KEY (`project_id`) REFERENCES `donation_project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Notification Table
CREATE TABLE IF NOT EXISTS `notification` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT,
    `title` VARCHAR(200) NOT NULL,
    `content` TEXT,
    `type` TINYINT DEFAULT 1,
    `is_read` TINYINT DEFAULT 0,
    `send_date` DATETIME,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (`user_id`),
    INDEX idx_is_read (`is_read`),
    INDEX idx_send_date (`send_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Menu Permission Table
CREATE TABLE IF NOT EXISTS `menu` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `parent_id` BIGINT DEFAULT 0,
    `menu_name` VARCHAR(50) NOT NULL,
    `menu_type` TINYINT DEFAULT 1,
    `path` VARCHAR(200),
    `component` VARCHAR(200),
    `icon` VARCHAR(50),
    `permission` VARCHAR(100),
    `sort_order` INT DEFAULT 0,
    `status` TINYINT DEFAULT 1,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_parent_id (`parent_id`),
    INDEX idx_status (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default admin account (password: admin123)
INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`, `registration_date`)
VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 'Administrator', 1, 1, NOW());

-- Insert initial menu data
INSERT INTO `menu` (`menu_name`, `menu_type`, `path`, `component`, `sort_order`, `status`) VALUES
('System Management', 1, '/system', 'Layout', 1, 1),
('User Management', 2, '/system/user', '/system/user/index', 1, 1),
('Project Management', 2, '/project', 'Layout', 2, 1),
('Project List', 2, '/project/list', '/project/list/index', 1, 1),
('Donation Management', 2, '/donation', 'Layout', 3, 1),
('Donation Records', 2, '/donation/record', '/donation/record/index', 1, 1),
('Audit Management', 2, '/audit', 'Layout', 4, 1),
('Comment Audit', 2, '/audit/comment', '/audit/comment/index', 1, 1),
('Notice Management', 2, '/notice', 'Layout', 5, 1),
('Notice List', 2, '/notice/list', '/notice/list/index', 1, 1),
('Statistics', 2, '/statistics', 'Layout', 6, 1),
('Data Statistics', 2, '/statistics/data', '/statistics/data/index', 1, 1);

-- Insert test project data
INSERT INTO `donation_project` (`project_name`, `category`, `description`, `target_amount`, `current_amount`, `donor_count`, `beneficiary`, `location`, `start_date`, `end_date`, `status`, `create_by`) VALUES
('Education Support Program', 'Education', 'Provide educational funding for students in impoverished areas', 100000.00, 35680.00, 128, 'Needy Students', 'Liangshan, Sichuan', '2024-01-01', '2024-12-31', 1, 1),
('Rural Medical Aid', 'Medical', 'Provide basic medical care for villagers in remote areas', 50000.00, 12500.00, 45, 'Rural Villagers', 'Nujiang, Yunnan', '2024-01-15', '2024-06-30', 1, 1),
('Environmental Protection Initiative', 'Environment', 'Promote environmental protection activities', 30000.00, 8900.00, 32, 'Public', 'Nationwide', '2024-02-01', '2024-12-31', 1, 1),
('Disaster Relief Fund', 'Disaster', 'Provide emergency relief and reconstruction support', 200000.00, 45000.00, 156, 'Disaster Victims', 'Nationwide', '2024-01-01', '2024-12-31', 1, 1),
('Warmth for Needy Families', 'Poverty', 'Provide living assistance for impoverished families', 80000.00, 22000.00, 88, 'Needy Families', 'Qiandongnan, Guizhou', '2024-01-10', '2024-11-30', 1, 1);
