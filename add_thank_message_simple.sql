USE charity_donation;
ALTER TABLE donation_project ADD COLUMN thank_message TEXT COMMENT '感谢留言' AFTER update_time;
