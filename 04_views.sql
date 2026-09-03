-- ============================================================
-- Views cho hệ thống BrightPath Language Center
-- ============================================================

USE brightpath_db;

-- ============================================================
-- 1. View: vw_instructor_workload
-- Thống kê khối lượng công việc của từng giảng viên (lead/assistant)
-- ============================================================
CREATE OR REPLACE VIEW vw_instructor_workload AS
SELECT
    i.student_id AS instructor_id, 
    s.full_name, 
    i.status,
    COUNT(DISTINCT c.class_id) AS classes_as_head,
    COALESCE(SUM(CASE WHEN ms.role = 'lead' THEN 1 ELSE 0 END), 0) AS meetings_as_lead,
    COALESCE(SUM(CASE WHEN ms.role = 'assistant' THEN 1 ELSE 0 END), 0) AS meetings_as_assistant
FROM instructor AS i
JOIN student AS s 
    ON s.student_id = i.student_id
LEFT JOIN class AS c 
    ON c.head_instructor_id = i.student_id
LEFT JOIN meeting_staff AS ms 
    ON ms.instructor_id = i.student_id
GROUP BY i.student_id, s.full_name, i.status;

-- ============================================================
-- 2. View: vw_class_attendance_summary
-- Thống kê sĩ số trung bình mỗi buổi của từng lớp
-- ============================================================
CREATE OR REPLACE VIEW vw_class_attendance_summary AS
SELECT
    c.class_id, 
    c.level, 
    c.day_of_week,
    COUNT(DISTINCT cm.meeting_id) AS total_meetings,
    COUNT(a.student_id) AS total_attendances,
    IF(COUNT(DISTINCT cm.meeting_id) = 0, 0, 
       ROUND(COUNT(a.student_id) / COUNT(DISTINCT cm.meeting_id), 2)) AS avg_attendance_per_meeting
FROM class AS c
LEFT JOIN class_meeting AS cm 
    ON cm.class_id = c.class_id
LEFT JOIN attendance AS a 
    ON a.meeting_id = cm.meeting_id
GROUP BY c.class_id, c.level, c.day_of_week;
