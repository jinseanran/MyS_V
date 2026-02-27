CREATE TABLE IF NOT EXISTS `user_preference` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `category` VARCHAR(50) NOT NULL COMMENT '捐赠类别',
  `score` DOUBLE NOT NULL DEFAULT 0.0 COMMENT '偏好分数',
  `view_count` INT NOT NULL DEFAULT 0 COMMENT '浏览次数',
  `donation_count` INT NOT NULL DEFAULT 0 COMMENT '捐赠次数',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_category` (`category`),
  UNIQUE KEY `uk_user_category` (`user_id`, `category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户偏好表';
