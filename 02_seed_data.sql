-- ============================================================
-- Dữ liệu mẫu cho hệ thống BrightPath Language Center
-- ============================================================

USE brightpath_db;

-- ============================================================
-- Thêm chứng chỉ
-- ============================================================
INSERT INTO certificate (cert_name, badge_color, description) VALUES
    ('Starter Badge',  'bronze', 'Chứng chỉ khởi đầu, cấp tự động khi đăng ký học.'),
    ('Fluent Speaker', 'gold',   'Chứng nhận khả năng giao tiếp trôi chảy.'),
    ('Grammar Master', 'silver', 'Chứng nhận nắm vững ngữ pháp nâng cao.');

-- ============================================================
-- Thêm yêu cầu của chứng chỉ
-- ============================================================
INSERT INTO requirement (description, cert_id) VALUES
    ('Hoàn thành tối thiểu 30 buổi học có điểm danh', 2),
    ('Đạt bài kiểm tra nói cuối cấp độ Advanced', 2),
    ('Đạt bài kiểm tra ngữ pháp cấp độ Intermediate trở lên', 3);

-- ============================================================
-- Thêm học viên
-- ============================================================
INSERT INTO student (full_name, date_of_birth, enrollment_date) VALUES
    ('Nguyen Thi Lan', '2001-04-12', '2023-01-10'),
    ('Tran Van Minh',  '1999-09-02', '2022-05-20'),
    ('Le Hoang Nam',   '2006-11-30', '2025-02-15'),
    ('Pham Thi Hoa',   '2007-03-08', '2026-06-01'),
    ('Do Anh Tuan',    '2002-07-19', '2023-08-01'),
    ('Vu Thi Mai',     '2005-01-25', '2024-03-11'),
    ('Bui Van Khoa',   '2008-05-05', '2025-09-01'),
    ('Ngo Thi Yen',    '2003-12-14', '2024-11-20');

-- ============================================================
-- Thêm giảng viên/trợ giảng
-- ============================================================
INSERT INTO instructor (student_id, staff_start_date, status) VALUES
    (1, '2023-06-01', 'paid'),
    (2, '2024-01-15', 'volunteer'),
    (5, '2023-09-01', 'paid');

-- ============================================================
-- Thêm lớp học
-- ============================================================
INSERT INTO class (level, day_of_week, time_slot, room, head_instructor_id) VALUES
    ('Intermediate English', 'MON', '18:00:00', 'A1', 1),
    ('Beginner Korean',      'TUE', '17:30:00', 'B2', 1),
    ('Advanced English',     'WED', '19:00:00', 'A2', 5),
    ('Beginner Japanese',    'THU', '18:30:00', 'C1', 5);

-- ============================================================
-- Thêm buổi học
-- ============================================================
INSERT INTO class_meeting (meeting_date, class_id) VALUES
    ('2026-06-08', 1), ('2026-06-15', 1), ('2026-06-22', 1), ('2026-06-29', 1),
    ('2026-06-09', 2), ('2026-06-16', 2),
    ('2026-06-10', 3), ('2026-06-17', 3), ('2026-06-24', 3),
    ('2026-06-11', 4);

-- ============================================================
-- Thêm người phụ trách từng buổi học
-- ============================================================
INSERT INTO meeting_staff (meeting_id, instructor_id, role) VALUES
    (1, 1, 'lead'), (1, 2, 'assistant'),
    (2, 1, 'lead'),
    (3, 1, 'lead'), (3, 2, 'assistant'),
    (4, 1, 'lead'),
    (5, 1, 'lead'),
    (6, 1, 'lead'),
    (7, 5, 'lead'),
    (8, 5, 'lead'),
    (9, 5, 'lead'),
    (10, 5, 'lead');

-- ============================================================
-- Thêm điểm danh
-- ============================================================
INSERT INTO attendance (student_id, meeting_id) VALUES
    (3, 1), (4, 1), (6, 1),
    (3, 2), (4, 2),
    (3, 3), (4, 3), (6, 3),
    (3, 4),
    (7, 5), (8, 5),
    (7, 6),
    (6, 7), (8, 7),
    (6, 8),
    (6, 9);

-- ============================================================
-- Thêm lịch sử chứng chỉ học viên
-- ============================================================
INSERT INTO student_certificate (student_id, cert_id, award_date) VALUES
    (3, 2, '2026-06-30'),
    (6, 3, '2026-06-25');
