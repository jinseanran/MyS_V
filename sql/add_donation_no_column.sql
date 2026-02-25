-- ==========================================
-- Add donation_no column to donation_record table
-- ==========================================

USE charity_donation;

-- Check if donation_no column exists
SET @dbname = DATABASE();
SET @tablename = 'donation_record';
SET @columnname = 'donation_no';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_schema = @dbname)
      AND (table_name = @tablename)
      AND (column_name = @columnname)
  ) > 0,
  'SELECT 1',
  CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN ', @columnname, ' VARCHAR(100) AFTER transaction_id')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add indexes for better performance
ALTER TABLE donation_record ADD INDEX IF NOT EXISTS idx_donation_no (donation_no);

SELECT 'donation_no column added successfully!' AS message;