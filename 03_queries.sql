-- ============================================================
-- SQL query pack cho hệ thống BrightPath Language Center
-- ============================================================

USE brightpath_db;

-- ============================================================
-- Q01: Lọc và sắp xếp danh sách lớp học (Toán tử LIKE)
-- ============================================================
SELECT 
    class_id, 
    level, 
    day_of_week, 
    time_slot, 
    room 
FROM class
WHERE level LIKE 'Advanced%' 
ORDER BY day_of_week, time_slot;

-- ============================================================
-- Q02: Báo cáo chi tiết điểm danh (INNER JOIN 4 bảng)
-- ============================================================
SELECT 
    s.full_name, 
    c.level, 
    cm.meeting_date
FROM attendance AS a
JOIN student AS s 
    ON s.student_id = a.student_id
JOIN class_meeting AS cm 
    ON cm.meeting_id = a.meeting_id
JOIN class AS c 
    ON c.class_id = cm.class_id
ORDER BY s.full_name, cm.meeting_date;

-- ============================================================
-- Q03: Kiểm tra buổi học bị bỏ sót điểm danh (LEFT JOIN)
-- ============================================================
SELECT 
    cm.meeting_id, 
    cm.meeting_date, 
    c.level
FROM class_meeting AS cm
JOIN class AS c 
    ON c.class_id = cm.class_id
LEFT JOIN attendance AS a 
    ON a.meeting_id = cm.meeting_id
WHERE a.meeting_id IS NULL 
ORDER BY cm.meeting_date;

-- ============================================================
-- Q04: Tìm học viên lười học (GROUP BY & HAVING)
-- ============================================================
SELECT 
    s.student_id, 
    s.full_name, 
    COUNT(a.meeting_id) AS attendance_count
FROM student AS s
LEFT JOIN attendance AS a 
    ON a.student_id = s.student_id
GROUP BY s.student_id, s.full_name
HAVING COUNT(a.meeting_id) < 3 
ORDER BY attendance_count ASC;

-- ============================================================
-- Q05: Học viên chưa có thành tích (Subquery với NOT EXISTS)
-- ============================================================
SELECT 
    s.student_id, 
    s.full_name 
FROM student AS s
WHERE NOT EXISTS (
    SELECT 1 
    FROM student_certificate AS sc
    JOIN certificate AS cert 
        ON cert.cert_id = sc.cert_id
    WHERE sc.student_id = s.student_id 
      AND cert.cert_name <> 'Starter Badge'
) 
ORDER BY s.full_name;

-- ============================================================
-- Q06: Bảng xếp hạng học viên chuyên cần (CTE & Window Function)
-- ============================================================
WITH attendance_count AS (
    SELECT 
        student_id, 
        COUNT(*) AS total_meetings 
    FROM attendance 
    GROUP BY student_id
)
SELECT 
    s.full_name, 
    ac.total_meetings,
    RANK() OVER (ORDER BY ac.total_meetings DESC) AS rank_in_center
FROM attendance_count AS ac
JOIN student AS s 
    ON s.student_id = ac.student_id
ORDER BY ac.total_meetings DESC;

-- ============================================================
-- Q07: Thống kê số lượng đi học theo tuần (Date Function)
-- ============================================================
SELECT 
    YEARWEEK(cm.meeting_date, 3) AS year_week, 
    COUNT(a.student_id) AS total_attendance
FROM class_meeting AS cm
LEFT JOIN attendance AS a 
    ON a.meeting_id = cm.meeting_id
GROUP BY YEARWEEK(cm.meeting_date, 3) 
ORDER BY year_week;

-- ============================================================
-- Q08: Hiệu suất giảng viên (Truy xuất từ View & Function)
-- ============================================================
SELECT 
    v.level, 
    v.total_meetings, 
    v.avg_attendance_per_meeting
FROM vw_class_attendance_summary AS v
ORDER BY v.avg_attendance_per_meeting DESC;
