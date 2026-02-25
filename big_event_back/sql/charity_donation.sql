-- ==========================================
-- 公益捐赠管理系统 - 数据库脚本
-- 毕业设计专用
-- ==========================================

DROP DATABASE IF EXISTS charity_donation;
CREATE DATABASE charity_donation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE charity_donation;

-- ==========================================
-- 1. 用户表
-- ==========================================
CREATE TABLE user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码（BCrypt加密）',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    avatar VARCHAR(255) DEFAULT '/default-avatar.jpg' COMMENT '头像',
    role TINYINT DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    total_donation DECIMAL(15,2) DEFAULT 0.00 COMMENT '累计捐赠金额',
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    last_login_date DATETIME COMMENT '最后登录时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    INDEX idx_username (username),
    INDEX idx_role (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ==========================================
-- 2. 捐赠项目表
-- ==========================================
CREATE TABLE donation_project (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '项目ID',
    project_name VARCHAR(200) NOT NULL COMMENT '项目名称',
    category VARCHAR(50) COMMENT '项目分类',
    description TEXT COMMENT '项目描述',
    cover_image VARCHAR(255) COMMENT '封面图片',
    target_amount DECIMAL(15,2) NOT NULL DEFAULT 0.00 COMMENT '目标金额',
    current_amount DECIMAL(15,2) DEFAULT 0.00 COMMENT '当前已筹金额',
    donor_count INT DEFAULT 0 COMMENT '捐赠人次',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    beneficiary VARCHAR(200) COMMENT '受益人',
    location VARCHAR(200) COMMENT '项目地点',
    start_date DATE COMMENT '开始时间',
    end_date DATE COMMENT '结束时间',
    status TINYINT DEFAULT 0 COMMENT '状态：0-待审核，1-进行中，2-已完成，3-已关闭',
    create_by BIGINT COMMENT '创建人ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    INDEX idx_category (category),
    INDEX idx_status (status),
    INDEX idx_create_by (create_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠项目表';

-- ==========================================
-- 3. 捐赠记录表
-- ==========================================
CREATE TABLE donation_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    user_id BIGINT COMMENT '捐赠用户ID',
    project_id BIGINT NOT NULL COMMENT '项目ID',
    amount DECIMAL(15,2) NOT NULL COMMENT '捐赠金额',
    payment_method VARCHAR(50) DEFAULT '支付宝' COMMENT '支付方式',
    transaction_id VARCHAR(100) COMMENT '交易流水号',
    donation_no VARCHAR(50) NOT NULL UNIQUE COMMENT '捐赠编号',
    message TEXT COMMENT '捐赠留言',
    is_anonymous TINYINT DEFAULT 0 COMMENT '是否匿名：0-否，1-是',
    status TINYINT DEFAULT 1 COMMENT '状态：0-待支付，1-已完成，2-已取消，3-已退款',
    donation_date DATETIME COMMENT '捐赠时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    INDEX idx_user_id (user_id),
    INDEX idx_project_id (project_id),
    INDEX idx_status (status),
    INDEX idx_donation_date (donation_date),
    INDEX idx_donation_no (donation_no),
    FOREIGN KEY (project_id) REFERENCES donation_project(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='捐赠记录表';

-- ==========================================
-- 4. 评论表
-- ==========================================
CREATE TABLE comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论ID',
    project_id BIGINT NOT NULL COMMENT '项目ID',
    user_id BIGINT COMMENT '用户ID',
    content TEXT NOT NULL COMMENT '评论内容',
    likes_count INT DEFAULT 0 COMMENT '点赞数',
    status TINYINT DEFAULT 1 COMMENT '状态：0-待审核，1-已发布，2-已删除',
    comment_date DATETIME COMMENT '评论时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    INDEX idx_project_id (project_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    FOREIGN KEY (project_id) REFERENCES donation_project(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- ==========================================
-- 5. 通知表
-- ==========================================
CREATE TABLE notification (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '通知ID',
    user_id BIGINT COMMENT '接收用户ID',
    title VARCHAR(200) NOT NULL COMMENT '通知标题',
    content TEXT COMMENT '通知内容',
    type TINYINT DEFAULT 1 COMMENT '类型：1-系统通知，2-捐赠通知，3-活动通知',
    is_read TINYINT DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    send_date DATETIME COMMENT '发送时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_send_date (send_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表';

-- ==========================================
-- 6. 数据统计表
-- ==========================================
CREATE TABLE statistics (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '统计ID',
    stat_date DATE NOT NULL COMMENT '统计日期',
    total_donation_amount DECIMAL(15,2) DEFAULT 0.00 COMMENT '当日捐赠总额',
    total_donation_count INT DEFAULT 0 COMMENT '当日捐赠次数',
    total_project_count INT DEFAULT 0 COMMENT '项目总数',
    total_user_count INT DEFAULT 0 COMMENT '用户总数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_stat_date (stat_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据统计表';

-- ==========================================
-- 插入初始数据
-- ==========================================

-- 插入默认管理员（密码：123456，明文）
INSERT INTO user (username, password, real_name, phone, email, role, status, registration_date)
VALUES ('admin', '123456', '系统管理员', '13800138000', 'admin@charity.com', 1, 1, NOW());

-- 插入测试用户
INSERT INTO user (username, password, real_name, phone, email, role, status, registration_date)
VALUES 
('user1', '123456', '张三', '13900139001', 'user1@charity.com', 0, 1, NOW()),
('user2', '123456', '李四', '13900139002', 'user2@charity.com', 0, 1, NOW());

-- 插入测试项目
INSERT INTO donation_project (project_name, category, description, target_amount, beneficiary, location, start_date, end_date, status, create_by)
VALUES 
('山区小学图书室建设', '教育助学', '为偏远山区小学建设图书室，提供课外读物和学习资料，丰富孩子们的课余生活。', 100000.00, '山区小学生', '四川省凉山州', '2024-01-01', '2024-12-31', 1, 1),
('白血病儿童医疗救助', '医疗救助', '为患有白血病的贫困家庭儿童提供医疗费用救助。', 200000.00, '白血病儿童', '全国范围', '2024-01-15', '2024-06-30', 1, 1),
('贫困地区饮用水安全工程', '扶贫济困', '为贫困地区建设饮用水安全工程，解决饮水困难。', 150000.00, '当地居民', '贵州省毕节市', '2024-02-01', '2024-11-30', 1, 1);

-- 插入测试捐赠记录
INSERT INTO donation_record (user_id, project_id, amount, donation_no, message, status, donation_date)
VALUES 
(2, 1, 500.00, 'DON202402220001', '希望孩子们能多读书', 1, NOW()),
(3, 2, 1000.00, 'DON202402220002', '尽绵薄之力', 1, NOW());

-- 更新项目当前金额和捐赠人数
UPDATE donation_project p
SET p.current_amount = (
    SELECT COALESCE(SUM(d.amount), 0) 
    FROM donation_record d 
    WHERE d.project_id = p.id AND d.status = 1
),
p.donor_count = (
    SELECT COALESCE(COUNT(DISTINCT d.user_id), 0) 
    FROM donation_record d 
    WHERE d.project_id = p.id AND d.status = 1
);

-- 更新用户累计捐赠金额
UPDATE user u
SET u.total_donation = (
    SELECT COALESCE(SUM(d.amount), 0) 
    FROM donation_record d 
    WHERE d.user_id = u.id AND d.status = 1
);
