-- ==========================================
-- Add Environmental Protection Project
-- ==========================================

USE charity_donation;

-- Insert a new environmental protection project
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
    `create_by`,
    `create_time`,
    `update_time`
) VALUES (
    'Green Earth Protection Program',
    '环保公益',
    'Join us to protect our planet. Participate in tree planting, waste sorting, ocean cleaning and other environmental actions.',
    150000.00,
    45200.00,
    186,
    3250,
    'Earth Environment',
    'Nationwide',
    '2024-03-01 00:00:00',
    '2024-12-31 23:59:59',
    1,
    1,
    NOW(),
    NOW()
);

SELECT 'Environmental protection project added successfully!' AS message;
SELECT * FROM donation_project WHERE category = '环保公益';