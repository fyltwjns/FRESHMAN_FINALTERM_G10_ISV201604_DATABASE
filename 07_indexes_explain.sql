-- ============================================================
-- Chỉ mục và Kế hoạch thực thi (Indexes & Explain)
-- ============================================================

USE brightpath_db;

-- ============================================================
-- Tạo các chỉ mục phụ (Secondary Indexes)
-- ============================================================
CREATE INDEX idx_attendance_student 
    ON attendance (student_id);

CREATE INDEX idx_meeting_class_date 
    ON class_meeting (class_id, meeting_date);

CREATE INDEX idx_class_head_instructor 
    ON class (head_instructor_id);

-- ============================================================
-- Xem danh sách chỉ mục hiện có
-- ============================================================
SHOW INDEX FROM attendance;
SHOW INDEX FROM class_meeting;
SHOW INDEX FROM class;

-- ============================================================
-- Xem kế hoạch thực thi (EXPLAIN)
-- ============================================================

-- 1. Xem lịch sử điểm danh của học viên
EXPLAIN SELECT 
    cm.meeting_date, 
    c.level
FROM attendance AS a
JOIN class_meeting AS cm 
    ON cm.meeting_id = a.meeting_id
JOIN class AS c 
    ON c.class_id = cm.class_id
WHERE a.student_id = 3
ORDER BY cm.meeting_date DESC;

-- 2. Tra cứu buổi học theo lớp và ngày
EXPLAIN SELECT * 
FROM class_meeting
WHERE class_id = 1 AND meeting_date = '2026-06-08';

-- 3. Tra cứu lớp học do instructor làm chủ nhiệm
EXPLAIN SELECT * 
FROM class
WHERE head_instructor_id = 1;
