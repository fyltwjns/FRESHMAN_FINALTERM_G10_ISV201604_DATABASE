-- Kịch bản kiểm thử CSDL (09_tests.sql) --

USE brightpath_db;

-- ============================================================
-- 1. KIỂM THỬ TÍCH CỰC (POSITIVE TESTS)
-- ============================================================

-- Thêm học viên mới (Kiểm tra trigger tự động cấp Starter Badge - BR12) --
INSERT INTO student (full_name, date_of_birth, enrollment_date)
VALUES ('Test Student Positive', '2005-05-05', CURDATE());

-- Xác nhận Starter Badge đã được cấp --
SELECT s.full_name, c.cert_name, sc.award_date
FROM student_certificate AS sc
JOIN student AS s ON s.student_id = sc.student_id
JOIN certificate AS c ON c.cert_id = sc.cert_id
WHERE s.full_name = 'Test Student Positive';

-- Ghi nhận điểm danh qua thủ tục sp_record_attendance --
CALL sp_record_attendance(8, 10);

-- Xác nhận điểm danh đã được ghi --
SELECT * FROM attendance WHERE student_id = 8 AND meeting_id = 10;

-- ============================================================
-- 2. KIỂM THỬ TIÊU CỰC (NEGATIVE TESTS)
-- ============================================================

-- A. Vi phạm ràng buộc NOT NULL --
-- Thử thêm lớp học mà không có giảng viên phụ trách chính (head_instructor_id là NULL)
-- Kết quả mong đợi: Lỗi hệ thống chặn (Column 'head_instructor_id' cannot be null)
-- INSERT INTO class (level, day_of_week, time_slot, room, head_instructor_id)
-- VALUES ('Intermediate English', 'MON', '18:00:00', 'A1', NULL);

-- B. Vi phạm ràng buộc UNIQUE của lớp học trùng lịch --
-- Thử thêm một lớp học trùng thứ, giờ và phòng với lớp hiện tại
-- Kết quả mong đợi: Lỗi hệ thống chặn (Duplicate entry for key 'uq_class_schedule')
-- INSERT INTO class (level, day_of_week, time_slot, room, head_instructor_id)
-- VALUES ('Test Schedule Collision', 'MON', '18:00:00', 'A1', 1);

-- C. Vi phạm ràng buộc khóa ngoại (FOREIGN KEY) --
-- Thử thêm buổi học cho mã lớp không tồn tại
-- Kết quả mong đợi: Lỗi hệ thống chặn (Cannot add or update a child row: a foreign key constraint fails)
-- INSERT INTO class_meeting (meeting_date, class_id) VALUES (CURDATE(), 9999);

-- D. Chặn trùng điểm danh qua thủ tục sp_record_attendance --
-- Gọi sp_record_attendance cho học viên đã được điểm danh trước đó trong buổi học
-- Kết quả mong đợi: Lỗi tuỳ chỉnh phát sinh (Học viên đã được điểm danh cho buổi này.)
-- CALL sp_record_attendance(3, 1);

-- E. Kiểm tra điều kiện cấp chứng chỉ qua thủ tục sp_award_certificate --
-- Học viên 4 mới tham dự 1 buổi (dưới 30 buổi), thử cấp chứng chỉ Fluent Speaker
-- Kết quả mong đợi: Lỗi tuỳ chỉnh phát sinh (Học viên chưa đủ số buổi tối thiểu cho Fluent Speaker.)
-- CALL sp_award_certificate(4, 2, CURDATE());

-- F. Chặn hai người giảng dạy chính trong một buổi học qua trigger --
-- Thêm dòng meeting_staff có role = 'lead' thứ hai cho meeting_id = 1 (đã có giảng viên 1 làm lead)
-- Kết quả mong đợi: Lỗi tuỳ chỉnh phát sinh (Mỗi buổi học chỉ được có đúng một lead instructor.)
-- INSERT INTO meeting_staff (meeting_id, instructor_id, role) VALUES (1, 5, 'lead');

-- ============================================================
-- 3. DỌN DẸP DỮ LIỆU KIỂM THỬ (CLEANUP)
-- ============================================================
DELETE FROM student_certificate WHERE student_id IN (SELECT student_id FROM student WHERE full_name = 'Test Student Positive');
DELETE FROM student WHERE full_name = 'Test Student Positive';
DELETE FROM attendance WHERE student_id = 8 AND meeting_id = 10;
