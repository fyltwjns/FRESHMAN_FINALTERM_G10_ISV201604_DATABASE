# BrightPath Language Center - Database Project Final (Freshman)

The final database project for designing, deploying, and operating a system to manage class schedules, attendance, teaching staff assignments, and internal certificate issuance at BrightPath Language Center.

## Features

- Class schedule and attendance management.
- Teaching staff assignment.
- Automated internal certificate issuance (automatically issuing Starter Badges for new students).
- Reporting system and performance statistics.
- Query performance optimization.
- Testing scenarios and environment cleanup.

## Project Structure

```text
BrightPath-Database-Project/
├── 01_schema.sql
├── 02_seed_data.sql
├── 03_queries.sql
├── 04_views.sql
├── 05_routines.sql
├── 06_triggers_events.sql
├── 07_indexes_explain.sql
├── 08_admin_backup.md
├── 09_tests.sql
├── BrightPath_Report_Cuoi_Ki.docx
├── erd.png
└── README.md
```

## Technologies

- **Database Management System**: MySQL 8.0+
- **Storage Engine**: InnoDB
- **Character Set / Collation**: utf8mb4 / utf8mb4_0900_ai_ci
- **Testing Environment**: Localhost

## Run

To ensure entities, foreign key constraints, triggers, views, and sample data are set up correctly without dependency errors, run the SQL files in the strict order below:

```bash
# 1. Initialize the database and structure of 10 tables (including the audit log table).
mysql -u root -p < 01_schema.sql

# 2. Set up business triggers and scheduled events.
# Note: This file must be run before loading sample data for the automatic Starter Badge trigger to work.
mysql -u root -p < 06_triggers_events.sql

# 3. Load the full sample dataset for testing and operation.
mysql -u root -p < 02_seed_data.sql

# 4. Create reporting views and performance statistics.
mysql -u root -p < 04_views.sql

# 5. Install functions and stored procedures.
mysql -u root -p < 05_routines.sql

# 6. Set up indexes for performance optimization and view sample execution plans.
mysql -u root -p < 07_indexes_explain.sql

# 7. Query package for real-world business questions (Q01-Q08).
mysql -u root -p < 03_queries.sql

# 8. Scenarios for positive/negative testing and environment cleanup.
mysql -u root -p < 09_tests.sql
```

## Learning Outcomes

The project demonstrates the practical application of database techniques, including designing a 10-table structure, programming business triggers/events, optimizing via indexes, building views/routines, and deep query scenarios. Included is a complete Crow's Foot ERD, administration/backup guide (08_admin_backup.md), and a detailed 9-chapter report (BrightPath_Report_Cuoi_Ki.docx).

## Author

**Tien Son Nguyen** (aka fyltwjns)

GitHub: [https://github.com/fyltwjns](https://github.com/fyltwjns)

> Final database project for designing, deploying, and operating a system to manage class schedules, attendance, teaching staff assignments, and internal certificate issuance.
