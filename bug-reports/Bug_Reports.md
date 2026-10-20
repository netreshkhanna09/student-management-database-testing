# Defect Log & Database Bug Reports: Student Management System

**Document Identifier:** BUG-STUDENT-DB-001  
**Project:** Student Management System — Database & Functional Testing  
**Database System:** MySQL / ANSI SQL Compatible  
**Total Documented Defects:** 4  
**Format:** Jira / Bugzilla Standard  

---

## Defect Summary Overview

| Defect ID | Summary | Category | Severity | Priority | Status |
|:---|:---|:---|:---:|:---:|:---:|
| **DB-BUG-01** | Check constraints silently ignored on MySQL engines older than 8.0.16 | Constraint Enforcement | High (S2) | P2 - High | Documented / Verified |
| **DB-BUG-02** | Trailing whitespace in email allows duplicate registration or pad collision | Data Sanitation / Unique Index | Medium (S3) | P3 - Medium | Documented / Verified |
| **DB-BUG-03** | Lack of custom exception message when deleting parent department with students | Referential Integrity | Medium (S3) | P3 - Medium | Documented / Verified |
| **DB-BUG-04** | Silent rounding/truncation on marks decimal column if strict SQL mode is disabled | Numeric Data Integrity | Low (S4) | P3 - Medium | Documented / Verified |

---

## Detailed Bug Reports

### DB-BUG-01: Check constraints silently ignored on MySQL engines older than 8.0.16
- **Defect ID:** DB-BUG-01
- **Associated Test Cases:** DB11, DB12, DB13, DB14
- **Category:** Constraint Enforcement / Engine Compatibility
- **Severity:** High (S2)
- **Priority:** P2 (High)
- **Environment:** MySQL Server < 8.0.16 (e.g., MySQL 5.7 / MariaDB legacy / MyISAM storage engine)
- **Reporter:** Database QA Engineer
- **Summary:** The database parses the `CHECK (age BETWEEN 16 AND 100)` and `CHECK (marks BETWEEN 0 AND 100)` syntax during table creation but fails to enforce them at runtime, permitting invalid records to be inserted.
- **Steps to Reproduce:**
  1. Connect to a MySQL Server version older than 8.0.16.
  2. Execute the table creation script in `setup_database.sql`.
  3. Run query:
     ```sql
     INSERT INTO students (student_id, student_name, email, age, department_id, marks)
     VALUES (999, 'Invalid Age Student', 'invalid.age@example.com', 10, 1, 150.00);
     ```
  4. Observe whether the insert succeeds.
- **Expected Result:** Database engine must reject the insert with `CHECK constraint violation` error.
- **Actual Result:** Insert succeeds with `Query OK, 1 row affected`. A 10-year-old student with 150 marks is inserted.
- **Root Cause:** Prior to MySQL 8.0.16, `CHECK` clauses were parsed for syntax compatibility with standard SQL but were not implemented or enforced by the storage engine.
- **Remediation / Recommendation:**
  1. Mandate MySQL 8.0.16+ in production environments.
  2. Implement database triggers (e.g., `BEFORE INSERT ON students`) to raise custom SQL exceptions (`SIGNAL SQLSTATE '45000'`) for backward compatibility.

---

### DB-BUG-02: Trailing whitespace in email allows duplicate registration or pad collision
- **Defect ID:** DB-BUG-02
- **Associated Test Case:** DB10
- **Category:** Data Sanitization / Unique Constraints
- **Severity:** Medium (S3)
- **Priority:** P3 (Medium)
- **Environment:** MySQL 8.0+ / utf8mb4_general_ci / pad space collation
- **Reporter:** Database QA Engineer
- **Summary:** Inserting an email with trailing whitespace `'aarav@example.com '` is either stripped or treated inconsistently, leading to unhandled application errors.
- **Steps to Reproduce:**
  1. Student 101 exists with email `'aarav@example.com'`.
  2. Execute insert with trailing space:
     ```sql
     INSERT INTO students (student_id, student_name, email, age, department_id, marks)
     VALUES (120, 'Whitespace Student', 'aarav@example.com ', 20, 1, 80.00);
     ```
  3. Inspect behavior across collations.
- **Expected Result:** Application or database should clean/trim input whitespace, and reject duplicate email cleanly.
- **Actual Result:** Depending on padding collation settings (`PAD SPACE` vs `NO PAD`), the query either throws an unhandled duplicate collision or creates two functionally identical emails.
- **Remediation / Recommendation:** Apply `TRIM()` in data ingestion layer and use a strict `NO PAD` collation.

---

### DB-BUG-03: Lack of custom exception message when deleting parent department with students
- **Defect ID:** DB-BUG-03
- **Associated Test Case:** DB16
- **Category:** Referential Integrity / Exception Handling
- **Severity:** Medium (S3)
- **Priority:** P3 (Medium)
- **Environment:** MySQL 8.0+ / ANSI SQL
- **Reporter:** Database QA Engineer
- **Summary:** Executing `DELETE FROM departments WHERE department_id = 1` raises raw database engine error `Error 1451: Cannot delete or update a parent row: a foreign key constraint fails` rather than a graceful business error for upstream consumers.
- **Steps to Reproduce:**
  1. Ensure department 1 has active enrolled students.
  2. Attempt to delete department 1:
     ```sql
     DELETE FROM departments WHERE department_id = 1;
     ```
- **Expected Result:** Database/API should return user-friendly message: *"Cannot remove department 'Computer Science' because 2 students are currently enrolled"*.
- **Actual Result:** Unhandled raw database exception is returned, which could leak internal schema details to end users if unhandled.
- **Remediation / Recommendation:** Implement pre-delete validation queries in application service layer or stored procedures.

---

### DB-BUG-04: Silent rounding/truncation on marks decimal column if strict SQL mode is disabled
- **Defect ID:** DB-BUG-04
- **Associated Test Case:** DB01, DB03
- **Category:** Numeric Data Integrity
- **Severity:** Low (S4)
- **Priority:** P3 (Medium)
- **Environment:** MySQL Server with `STRICT_TRANS_TABLES` disabled
- **Reporter:** Database QA Engineer
- **Summary:** If strict mode is turned off on legacy server instances, inserting marks with extra decimal places (e.g. `85.556`) silently rounds or truncates without warning.
- **Steps to Reproduce:**
  1. Disable strict mode (`SET sql_mode = '';`).
  2. Insert student with marks `85.556`:
     ```sql
     INSERT INTO students (student_id, student_name, email, age, department_id, marks)
     VALUES (125, 'Precision Student', 'precision@example.com', 20, 1, 85.556);
     ```
  3. Query `SELECT marks FROM students WHERE student_id = 125;`.
- **Expected Result:** Database should enforce strict data types and warn or reject out-of-scale inputs.
- **Actual Result:** Data is silently rounded to `85.56` without an error flag.
- **Remediation / Recommendation:** Ensure `STRICT_TRANS_TABLES` is permanently active in `my.cnf` / `my.ini`.
