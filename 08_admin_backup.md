# Quản trị cơ sở dữ liệu và Sao lưu/Phục hồi

Tài liệu hướng dẫn quản trị phân quyền (Role/User) và quy trình sao lưu (Backup/Restore) cho hệ thống `brightpath_db` trong môi trường local-lab.

---

## 1. Quản trị phân quyền (Administration & Least Privilege)

Thiết kế phân quyền tối thiểu (Least Privilege) cho người dùng báo cáo (`course_reporter`):
- **Vai trò (`role_course_reporter`)**: Chỉ có quyền đọc (`SELECT`) trên tất cả các bảng và view của cơ sở dữ liệu `brightpath_db`.
- **Người dùng (`course_reporter`)**: Được gán vai trò trên và cấu hình kích hoạt vai trò mặc định khi đăng nhập.

### Kịch bản SQL cấu hình phân quyền

```sql
-- Tạo vai trò chuyên biệt cho việc báo cáo
CREATE ROLE IF NOT EXISTS 'role_course_reporter';

-- Cấp quyền SELECT trên toàn bộ database brightpath_db cho vai trò này
GRANT SELECT ON brightpath_db.* TO 'role_course_reporter';

-- Tạo người dùng cục bộ cho môi trường phát triển
CREATE USER IF NOT EXISTS 'course_reporter'@'localhost' 
IDENTIFIED BY 'BrightPathLabPass2026!';

-- Gán vai trò cho người dùng
GRANT 'role_course_reporter' TO 'course_reporter'@'localhost';

-- Thiết lập vai trò mặc định cho người dùng khi kết nối
SET DEFAULT ROLE 'role_course_reporter' TO 'course_reporter'@'localhost';

-- Kiểm tra phân quyền của người dùng
SHOW GRANTS FOR 'course_reporter'@'localhost';
```

---

## 2. Quy trình Sao lưu và Phục hồi (Backup & Restore Runbook)

### Quy trình Sao lưu (Backup)
Sử dụng công cụ `mysqldump` từ dòng lệnh để sao lưu toàn bộ cấu trúc bảng, dữ liệu mẫu, stored procedures, functions và triggers. Mật khẩu sẽ được yêu cầu tương tác tại thời điểm thực thi để bảo mật.

**Lệnh sao lưu:**
```bash
mysqldump -u root -p --routines --triggers brightpath_db > brightpath_db_backup.sql
```

### Quy trình Phục hồi (Restore)
Để phục hồi an toàn mà không ảnh hưởng trực tiếp đến database đang chạy, thực hiện phục hồi vào một schema kiểm thử riêng biệt (`brightpath_db_restore_test`).

**Các bước phục hồi:**
1. Tạo cơ sở dữ liệu kiểm thử trống:
   ```sql
   CREATE DATABASE IF NOT EXISTS brightpath_db_restore_test;
   ```
2. Thực thi lệnh phục hồi dữ liệu từ file backup vào database kiểm thử:
   ```bash
   mysql -u root -p brightpath_db_restore_test < brightpath_db_backup.sql
   ```
3. Đối chiếu và kiểm tra tính toàn vẹn của dữ liệu bằng cách đếm số dòng trong các bảng cốt lõi (ví dụ: `student`, `class`, `attendance`).
