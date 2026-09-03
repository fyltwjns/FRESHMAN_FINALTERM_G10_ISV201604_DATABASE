-- ============================================================
-- Schema cho hệ thống BrightPath Language Center
-- ============================================================

DROP DATABASE IF EXISTS brightpath_db;
CREATE DATABASE brightpath_db 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_0900_ai_ci;
USE brightpath_db;

-- ============================================================
-- 1) STUDENT — bảng gốc, mọi học viên khi đăng ký
-- ============================================================
CREATE TABLE student (
    student_id      BIGINT NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(120) NOT NULL,
    date_of_birth   DATE NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (student_id)
) ENGINE = InnoDB;

-- ============================================================
-- 2) INSTRUCTOR — subtype (partial) của STUDENT
-- ============================================================
CREATE TABLE instructor (
    student_id          BIGINT NOT NULL,
    staff_start_date    DATE NOT NULL,
    status              ENUM('paid', 'volunteer') NOT NULL,
    PRIMARY KEY (student_id),
    CONSTRAINT fk_instructor_student 
        FOREIGN KEY (student_id) 
        REFERENCES student(student_id) 
        ON UPDATE RESTRICT 
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ============================================================
-- 3) CERTIFICATE — danh mục chứng chỉ nội bộ
-- ============================================================
CREATE TABLE certificate (
    cert_id         INT NOT NULL AUTO_INCREMENT,
    cert_name       VARCHAR(100) NOT NULL,
    badge_color     VARCHAR(30) NOT NULL,
    description     VARCHAR(500) NULL,
    PRIMARY KEY (cert_id),
    CONSTRAINT uq_certificate_name 
        UNIQUE (cert_name)
) ENGINE = InnoDB;

-- ============================================================
-- 4) CLASS — lớp học theo lịch cố định
-- ============================================================
CREATE TABLE class (
    class_id            INT NOT NULL AUTO_INCREMENT,
    level               VARCHAR(60) NOT NULL,
    day_of_week         ENUM('MON','TUE','WED','THU','FRI','SAT','SUN') NOT NULL,
    time_slot           TIME NOT NULL,
    room                VARCHAR(20) NOT NULL,
    head_instructor_id  BIGINT NOT NULL,
    PRIMARY KEY (class_id),
    CONSTRAINT uq_class_schedule 
        UNIQUE (day_of_week, time_slot, room),
    CONSTRAINT fk_class_head_instructor 
        FOREIGN KEY (head_instructor_id) 
        REFERENCES instructor(student_id) 
        ON UPDATE RESTRICT 
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ============================================================
-- 5) CLASS_MEETING — buổi học cụ thể của một CLASS
-- ============================================================
CREATE TABLE class_meeting (
    meeting_id      BIGINT NOT NULL AUTO_INCREMENT,
    meeting_date    DATE NOT NULL,
    class_id        INT NOT NULL,
    PRIMARY KEY (meeting_id),
    CONSTRAINT uq_meeting_natural_key 
        UNIQUE (class_id, meeting_date),
    CONSTRAINT fk_meeting_class 
        FOREIGN KEY (class_id) 
        REFERENCES class(class_id) 
        ON UPDATE RESTRICT 
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ============================================================
-- 6) REQUIREMENT — yêu cầu của một CERTIFICATE
-- ============================================================
CREATE TABLE requirement (
    req_id          INT NOT NULL AUTO_INCREMENT,
    description     VARCHAR(300) NOT NULL,
    cert_id         INT NOT NULL,
    PRIMARY KEY (req_id),
    CONSTRAINT fk_requirement_certificate 
        FOREIGN KEY (cert_id) 
        REFERENCES certificate(cert_id) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE
) ENGINE = InnoDB;

-- ============================================================
-- 7) ATTENDANCE — bảng kết hợp STUDENT – CLASS_MEETING
-- ============================================================
CREATE TABLE attendance (
    student_id      BIGINT NOT NULL,
    meeting_id      BIGINT NOT NULL,
    PRIMARY KEY (student_id, meeting_id),
    CONSTRAINT fk_attendance_student 
        FOREIGN KEY (student_id) 
        REFERENCES student(student_id) 
        ON UPDATE RESTRICT 
        ON DELETE RESTRICT,
    CONSTRAINT fk_attendance_meeting 
        FOREIGN KEY (meeting_id) 
        REFERENCES class_meeting(meeting_id) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE
) ENGINE = InnoDB;

-- ============================================================
-- 8) MEETING_STAFF — bảng kết hợp CLASS_MEETING – INSTRUCTOR
-- ============================================================
CREATE TABLE meeting_staff (
    meeting_id      BIGINT NOT NULL,
    instructor_id   BIGINT NOT NULL,
    role            ENUM('lead', 'assistant') NOT NULL,
    PRIMARY KEY (meeting_id, instructor_id),
    CONSTRAINT fk_staff_meeting 
        FOREIGN KEY (meeting_id) 
        REFERENCES class_meeting(meeting_id) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE,
    CONSTRAINT fk_staff_instructor 
        FOREIGN KEY (instructor_id) 
        REFERENCES instructor(student_id) 
        ON UPDATE RESTRICT 
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ============================================================
-- 9) STUDENT_CERTIFICATE — bảng kết hợp STUDENT – CERTIFICATE
-- ============================================================
CREATE TABLE student_certificate (
    student_id      BIGINT NOT NULL,
    cert_id         INT NOT NULL,
    award_date      DATE NOT NULL,
    PRIMARY KEY (student_id, cert_id),
    CONSTRAINT fk_studentcert_student 
        FOREIGN KEY (student_id) 
        REFERENCES student(student_id) 
        ON UPDATE RESTRICT 
        ON DELETE RESTRICT,
    CONSTRAINT fk_studentcert_certificate 
        FOREIGN KEY (cert_id) 
        REFERENCES certificate(cert_id) 
        ON UPDATE RESTRICT 
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ============================================================
-- 10) ATTENDANCE_AUDIT — bảng lưu vết thao tác xóa điểm danh
-- ============================================================
CREATE TABLE attendance_audit (
    audit_id        BIGINT NOT NULL AUTO_INCREMENT,
    student_id      BIGINT NOT NULL,
    meeting_id      BIGINT NOT NULL,
    action          ENUM('DELETE') NOT NULL,
    changed_by      VARCHAR(100) NOT NULL,
    changed_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (audit_id)
) ENGINE = InnoDB;
