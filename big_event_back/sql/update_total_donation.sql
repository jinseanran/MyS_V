-- ==========================================
-- 更新用户累计捐赠金额
-- ==========================================

USE charity_donation;

-- 更新所有用户的累计捐赠金额
UPDATE user u
SET u.total_donation = (
    SELECT COALESCE(SUM(d.amount), 0) 
    FROM donation_record d 
    WHERE d.user_id = u.id AND d.status = 1
);

-- 查看更新结果
SELECT id, username, real_name, total_donation 
FROM user 
ORDER BY id;
