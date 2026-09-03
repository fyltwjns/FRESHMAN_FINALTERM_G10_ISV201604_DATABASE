-- ============================================================
-- Triggers và Events cho hệ thống BrightPath Language Center
-- ============================================================

USE brightpath_db;

-- ============================================================
-- Trigger: Cấp Starter Badge khi thêm học viên mới
-- ============================================================
DROP TRIGGER IF EXISTS trg_student_after_insert;
DELIMITER $$
CREATE TRIGGER trg_student_after_insert
AFTER INSERT ON student
FOR EACH ROW
BEGIN
    DECLARE starter_cert_id INT;
    
    SELECT cert_id INTO starter_cert_id 
    FROM certificate 
    WHERE cert_name = 'Starter Badge' 
    LIMIT 1;
    
    IF starter_cert_id IS NOT NULL THEN
        INSERT INTO student_certificate (student_id, cert_id, award_date)
        VALUES (NEW.student_id, starter_cert_id, CURDATE());
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- Trigger: Đảm bảo mỗi buổi chỉ có 1 lead instructor
-- ============================================================
DROP TRIGGER IF EXISTS trg_meeting_staff_before_insert;
DELIMITER $$
CREATE TRIGGER trg_meeting_staff_before_insert
BEFORE INSERT ON meeting_staff
FOR EACH ROW
BEGIN
    DECLARE lead_count INT;
    
    IF NEW.role = 'lead' THEN
        SELECT COUNT(*) INTO lead_count 
        FROM meeting_staff 
        WHERE meeting_id = NEW.meeting_id AND role = 'lead';
        
        IF lead_count >= 1 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Mỗi buổi học chỉ được có đúng một lead instructor.';
        END IF;
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- Trigger: Ghi log (audit) khi xóa điểm danh
-- ============================================================
DROP TRIGGER IF EXISTS trg_attendance_after_delete;
DELIMITER $$
CREATE TRIGGER trg_attendance_after_delete
AFTER DELETE ON attendance
FOR EACH ROW
BEGIN
    INSERT INTO attendance_audit (student_id, meeting_id, action, changed_by)
    VALUES (OLD.student_id, OLD.meeting_id, 'DELETE', CURRENT_USER());
END$$
DELIMITER ;

-- ============================================================
-- Event: Dọn dẹp log audit cũ hơn 180 ngày
-- ============================================================
DROP EVENT IF EXISTS ev_cleanup_old_attendance_audit;
CREATE EVENT ev_cleanup_old_attendance_audit
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
ON COMPLETION PRESERVE
DISABLE
DO 
    DELETE FROM attendance_audit 
    WHERE changed_at < CURRENT_TIMESTAMP - INTERVAL 180 DAY;
