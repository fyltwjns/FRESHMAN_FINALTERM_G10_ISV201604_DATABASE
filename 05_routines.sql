-- ============================================================
-- Functions & Procedures cho hệ thống BrightPath Language Center
-- ============================================================

USE brightpath_db;
DELIMITER $$

-- ============================================================
-- Function đếm tổng số buổi học có điểm danh của một học viên
-- ============================================================
DROP FUNCTION IF EXISTS fn_student_attendance_count$$
CREATE FUNCTION fn_student_attendance_count(p_student_id BIGINT) 
RETURNS INT
READS SQL DATA DETERMINISTIC
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count 
    FROM attendance 
    WHERE student_id = p_student_id;
    
    RETURN v_count;
END$$

-- ============================================================
-- Procedure cấp chứng chỉ (Áp dụng TRANSACTION và Validation)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_award_certificate$$
CREATE PROCEDURE sp_award_certificate(
    IN p_student_id BIGINT, 
    IN p_cert_id INT, 
    IN p_award_date DATE
)
BEGIN
    DECLARE v_student_exists INT DEFAULT 0;
    DECLARE v_cert_exists INT DEFAULT 0;
    DECLARE v_already_awarded INT DEFAULT 0;
    DECLARE v_attendance_count INT DEFAULT 0;
    
    -- 1. Validate học viên tồn tại
    SELECT COUNT(*) INTO v_student_exists 
    FROM student 
    WHERE student_id = p_student_id;
    IF v_student_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Học viên không tồn tại.';
    END IF;

    -- 2. Validate chứng chỉ tồn tại
    SELECT COUNT(*) INTO v_cert_exists 
    FROM certificate 
    WHERE cert_id = p_cert_id;
    IF v_cert_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Chứng chỉ không tồn tại.';
    END IF;

    -- 3. Validate chống cấp trùng
    SELECT COUNT(*) INTO v_already_awarded 
    FROM student_certificate 
    WHERE student_id = p_student_id AND cert_id = p_cert_id;
    IF v_already_awarded > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Học viên đã có chứng chỉ này.';
    END IF;

    -- 4. Business rule: Fluent Speaker (cert_id = 2) cần >= 30 buổi
    IF p_cert_id = 2 THEN 
        SET v_attendance_count = fn_student_attendance_count(p_student_id);
        IF v_attendance_count < 30 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Học viên chưa đủ số buổi tối thiểu cho Fluent Speaker.';
        END IF;
    END IF;

    -- 5. Thực thi cấp chứng chỉ trong Transaction
    START TRANSACTION;
        INSERT INTO student_certificate (student_id, cert_id, award_date) 
        VALUES (p_student_id, p_cert_id, p_award_date);
    COMMIT;
END$$

DELIMITER ;
