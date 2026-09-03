# BrightPath Language Center - Database Project Final (Freshman)

Dự án Cơ sở dữ liệu cuối kỳ thiết kế, triển khai và khai thác hệ thống quản lý lịch học, điểm danh, phân công nhân sự giảng dạy và cấp chứng chỉ nội bộ tại Trung tâm Ngoại ngữ BrightPath Language Center.

---

## 1. Môi trường triển khai (Specs)

- **Hệ quản trị CSDL:** MySQL 8.0+
- **Storage Engine:** InnoDB
- **Character Set / Collation:** `utf8mb4` / `utf8mb4_0900_ai_ci`
- **Địa chỉ máy chủ kiểm thử:** Localhost

---

## 2. Thứ tự thực thi mã nguồn (Execution Order)

Để đảm bảo các thực thể, ràng buộc khóa ngoại, triggers, views và dữ liệu mẫu được thiết lập chính xác mà không gặp lỗi phụ thuộc, vui lòng chạy các file SQL theo thứ tự nghiêm ngặt dưới đây:

1. **`01_schema.sql`**: Khởi tạo database và cấu trúc của 10 bảng (bao gồm bảng audit log).
2. **`06_triggers_events.sql`**: Thiết lập các triggers nghiệp vụ và các sự kiện lập lịch.
   * *Lưu ý:* Cần chạy file này trước khi nạp dữ liệu mẫu để trigger tự động cấp Starter Badge hoạt động chính xác cho học viên mới.
3. **`02_seed_data.sql`**: Nạp bộ dữ liệu mẫu đầy đủ phục vụ kiểm thử và khai thác.
4. **`04_views.sql`**: Tạo các view báo cáo và thống kê hiệu suất.
5. **`05_routines.sql`**: Cài đặt các hàm (functions) và thủ tục lưu trữ (stored procedures).
6. **`07_indexes_explain.sql`**: Thiết lập các chỉ mục tối ưu hiệu năng và xem kế hoạch thực thi mẫu.
7. **`03_queries.sql`**: Gói truy vấn phục vụ các câu hỏi nghiệp vụ thực tế (Q01-Q08).
8. **`09_tests.sql`**: Kịch bản chạy thử nghiệm kiểm thử tích cực/tiêu cực và dọn dẹp môi trường.

---

## 3. Tài liệu kèm theo

- **`README.md`**: Tài liệu hướng dẫn này.
- **`08_admin_backup.md`**: Hướng dẫn quản trị phân quyền cục bộ và quy trình sao lưu/phục hồi.
- **`BrightPath_Report_Cuoi_Ki.docx`**: Báo cáo chi tiết cuối kỳ đầy đủ 9 chương (kế thừa giữa kỳ và bổ sung tất cả các nội dung cuối kỳ).
- **`erd.png`**: Bản vẽ ERD Crow's Foot hoàn chỉnh làm tài liệu thiết kế gốc.
