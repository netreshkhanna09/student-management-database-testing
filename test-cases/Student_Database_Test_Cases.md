# Student Management System: Database Test Cases

**Document Identifier:** TC-STUDENT-DB-001  
**Project:** Student Management System — Database & Functional Testing  
**Database Name:** `student_qa`  
**Total Test Cases:** 20  
**Executed:** 20 | **Passed:** 20 | **Failed:** 0 | **Blocked:** 0  
**Pass Rate:** 100.0%  

---

## Summary Matrix by Test Category

| Category ID | Category Name | Total Cases | Passed | Failed | Pass Rate |
|:---|:---|:---:|:---:|:---:|:---:|
| **CAT-01** | CRUD Operations & Data Persistence | 5 | 5 | 0 | 100% |
| **CAT-02** | Primary Key, Not Null & Unique Constraints | 5 | 5 | 0 | 100% |
| **CAT-03** | Check Constraints & Boundary Value Analysis | 4 | 4 | 0 | 100% |
| **CAT-04** | Foreign Key & Referential Integrity | 3 | 3 | 0 | 100% |
| **CAT-05** | Complex SQL Validation & Analytical Queries | 3 | 3 | 0 | 100% |
| **TOTAL** | | **20** | **20** | **0** | **100%** |

---

## Detailed Database Test Cases

### Category 1: CRUD Operations & Data Persistence

#### DB01: Insert a new valid student record (CREATE)
- **Category:** CRUD Operations
- **Test Type:** Functional / Positive
- **Preconditions:** `student_qa` database created and department 1 exists.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (106, 'Riya Jain', 'riya@example.com', 20, 1, 82.50);
  ```
- **Expected Result:** Query executes successfully (1 row affected). Record with `student_id = 106` is stored in `students` table.
- **Actual Result:** 1 row inserted. Query `SELECT * FROM students WHERE student_id = 106` returns the newly created student record.
- **Status:** **PASS**
- **Severity:** Critical (S1)

#### DB02: Retrieve student record by Primary Key (READ)
- **Category:** CRUD Operations
- **Test Type:** Functional / Positive
- **Preconditions:** Student 101 exists in database.
- **SQL Statement:**
  ```sql
  SELECT student_id, student_name, email, age, department_id, marks
  FROM students
  WHERE student_id = 101;
  ```
- **Expected Result:** Returns exactly 1 row with `student_name = 'Aarav Sharma'`, `department_id = 1`, and `marks = 85.50`.
- **Actual Result:** Exactly 1 row returned matching all expected column values.
- **Status:** **PASS**
- **Severity:** Critical (S1)

#### DB03: Update student marks and verify persistence (UPDATE)
- **Category:** CRUD Operations
- **Test Type:** Functional / Positive
- **Preconditions:** Student 106 exists with initial marks 82.50.
- **SQL Statement:**
  ```sql
  UPDATE students SET marks = 95.00 WHERE student_id = 106;
  ```
- **Expected Result:** 1 row affected. Subsequent select confirms `marks` updated to `95.00`, leaving other columns unchanged.
- **Actual Result:** `marks` updated to `95.00`. Query verification confirms persistence.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB04: Delete a student record and verify removal (DELETE)
- **Category:** CRUD Operations
- **Test Type:** Functional / Positive
- **Preconditions:** Dedicated test student 106 exists.
- **SQL Statement:**
  ```sql
  DELETE FROM students WHERE student_id = 106;
  ```
- **Expected Result:** 1 row affected. `SELECT * FROM students WHERE student_id = 106` returns 0 rows (Empty set).
- **Actual Result:** 1 row deleted. SELECT query returned 0 rows.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB05: Verify data persistence across database transactions
- **Category:** CRUD Operations / ACID
- **Test Type:** Data Integrity / ACID Verification
- **Preconditions:** Connection active.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (107, 'Karan Johar', 'karan@example.com', 21, 2, 74.00);
  COMMIT;
  ```
- **Expected Result:** Data persists after COMMIT and remains queryable across new sessions.
- **Actual Result:** Record 107 confirmed stored and accessible across independent queries.
- **Status:** **PASS**
- **Severity:** High (S2)

---

### Category 2: Primary Key, Not Null & Unique Constraints

#### DB06: Insert duplicate student_id (Primary Key Violation)
- **Category:** Primary Key Constraints
- **Test Type:** Negative / Integrity
- **Preconditions:** Student 101 already exists in the table.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (101, 'Duplicate Aarav', 'duplicate.aarav@example.com', 22, 1, 80.00);
  ```
- **Expected Result:** Database engine rejects the statement with `PRIMARY KEY constraint violation` error.
- **Actual Result:** Rejected: Error Code indicates Primary Key duplicate key `101` violation.
- **Status:** **PASS**
- **Severity:** Critical (S1)

#### DB07: Insert NULL into Primary Key column (student_id)
- **Category:** Primary Key Constraints
- **Test Type:** Negative / Integrity
- **Preconditions:** Database schema loaded.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (NULL, 'Null ID Student', 'nullid@example.com', 20, 1, 80.00);
  ```
- **Expected Result:** Database engine rejects insert: `Column 'student_id' cannot be null`.
- **Actual Result:** Rejected: NOT NULL constraint failed on `students.student_id`.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB08: Insert NULL into NOT NULL column (student_name)
- **Category:** NOT NULL Constraints
- **Test Type:** Negative / Form Validation
- **Preconditions:** Database schema loaded.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (108, NULL, 'noname@example.com', 20, 1, 80.00);
  ```
- **Expected Result:** Database engine rejects insert: `Column 'student_name' cannot be null`.
- **Actual Result:** Rejected: NOT NULL constraint failed on `students.student_name`.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB09: Insert NULL into NOT NULL column (email)
- **Category:** NOT NULL Constraints
- **Test Type:** Negative / Form Validation
- **Preconditions:** Database schema loaded.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (109, 'No Email Student', NULL, 20, 1, 80.00);
  ```
- **Expected Result:** Database engine rejects insert: `Column 'email' cannot be null`.
- **Actual Result:** Rejected: NOT NULL constraint failed on `students.email`.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB10: Insert duplicate email (UNIQUE Constraint Violation)
- **Category:** UNIQUE Constraints
- **Test Type:** Negative / Data Integrity
- **Preconditions:** Email `'aarav@example.com'` already registered for student 101.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (110, 'Imposter Student', 'aarav@example.com', 22, 2, 75.00);
  ```
- **Expected Result:** Database engine rejects insert: `Duplicate entry 'aarav@example.com' for key 'students.email'`.
- **Actual Result:** Rejected: UNIQUE constraint failed on `students.email`.
- **Status:** **PASS**
- **Severity:** Critical (S1)

---

### Category 3: Check Constraints & Boundary Value Analysis (BVA)

#### DB11: Boundary Value Test - Underage Student (age < 16)
- **Category:** CHECK Constraints / BVA
- **Test Type:** Negative / Boundary Value Analysis
- **Preconditions:** Table has `CHECK (age IS NULL OR age BETWEEN 16 AND 100)`.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (111, 'Underage Kid', 'underage@example.com', 10, 1, 80.00);
  ```
- **Expected Result:** Database engine rejects insert: `CHECK constraint 'chk_student_age' is violated`.
- **Actual Result:** Rejected: Check constraint failed on `age >= 16`.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB12: Boundary Value Test - Overage Student (age > 100)
- **Category:** CHECK Constraints / BVA
- **Test Type:** Negative / Boundary Value Analysis
- **Preconditions:** Check constraint on age active.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (112, 'Overage Student', 'overage@example.com', 105, 1, 80.00);
  ```
- **Expected Result:** Database engine rejects insert: `CHECK constraint 'chk_student_age' is violated`.
- **Actual Result:** Rejected: Check constraint failed on `age <= 100`.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB13: Boundary Value Test - Negative Marks (marks < 0.00)
- **Category:** CHECK Constraints / BVA
- **Test Type:** Negative / Boundary Value Analysis
- **Preconditions:** Table has `CHECK (marks IS NULL OR marks BETWEEN 0 AND 100)`.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (113, 'Negative Marks Student', 'negative@example.com', 20, 1, -10.00);
  ```
- **Expected Result:** Database engine rejects insert: `CHECK constraint 'chk_student_marks' is violated`.
- **Actual Result:** Rejected: Check constraint failed on `marks >= 0.00`.
- **Status:** **PASS**
- **Severity:** High (S2)

#### DB14: Boundary Value Test - Excess Marks (marks > 100.00)
- **Category:** CHECK Constraints / BVA
- **Test Type:** Negative / Boundary Value Analysis
- **Preconditions:** Check constraint on marks active.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (114, 'Excess Marks Student', 'excess@example.com', 20, 1, 125.00);
  ```
- **Expected Result:** Database engine rejects insert: `CHECK constraint 'chk_student_marks' is violated`.
- **Actual Result:** Rejected: Check constraint failed on `marks <= 100.00`.
- **Status:** **PASS**
- **Severity:** High (S2)

---

### Category 4: Foreign Key & Referential Integrity

#### DB15: Insert student with non-existent department_id (Invalid Foreign Key)
- **Category:** Foreign Key Integrity
- **Test Type:** Negative / Referential Integrity
- **Preconditions:** Valid departments are 1, 2, and 3. Department 999 does not exist.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (115, 'Invalid Dept Student', 'invalid.dept@example.com', 20, 999, 80.00);
  ```
- **Expected Result:** Database engine rejects insert: `Cannot add or update a child row: a foreign key constraint fails`.
- **Actual Result:** Rejected: FOREIGN KEY constraint failed.
- **Status:** **PASS**
- **Severity:** Critical (S1)

#### DB16: Attempt deletion of parent department with enrolled students (RESTRICT)
- **Category:** Foreign Key Integrity
- **Test Type:** Negative / Referential Integrity
- **Preconditions:** Department 1 (Computer Science) has active students (101, 103).
- **SQL Statement:**
  ```sql
  DELETE FROM departments WHERE department_id = 1;
  ```
- **Expected Result:** Database engine prevents deletion: `Cannot delete or update a parent row: a foreign key constraint fails`.
- **Actual Result:** Rejected: FOREIGN KEY restriction prevented deletion of referenced parent row.
- **Status:** **PASS**
- **Severity:** Critical (S1)

#### DB17: Insert valid student with optional NULL values for age and marks
- **Category:** Nullable Column Handling
- **Test Type:** Positive / Edge Case
- **Preconditions:** Database schema loaded.
- **SQL Statement:**
  ```sql
  INSERT INTO students (student_id, student_name, email, age, department_id, marks)
  VALUES (116, 'Siddharth Rao', 'siddharth@example.com', NULL, 3, NULL);
  ```
- **Expected Result:** Record inserted successfully. Age and marks stored as SQL NULL without error.
- **Actual Result:** 1 row inserted. Verification query confirms `age IS NULL` and `marks IS NULL`.
- **Status:** **PASS**
- **Severity:** Medium (S3)

---

### Category 5: Complex SQL Validation & Analytical Queries

#### DB18: Validate Student-Department relationship via INNER JOIN
- **Category:** Analytical SQL Validation
- **Test Type:** Functional / Data Integrity
- **Preconditions:** Seed students and departments exist.
- **SQL Statement:**
  ```sql
  SELECT s.student_name, d.department_name
  FROM students s
  JOIN departments d ON s.department_id = d.department_id
  WHERE d.department_name = 'Computer Science';
  ```
- **Expected Result:** Returns all students enrolled in Computer Science (Aarav Sharma, Rahul Verma).
- **Actual Result:** Returned exactly 2 rows matching Computer Science students.
- **Status:** **PASS**
- **Severity:** Medium (S3)

#### DB19: Verify departmental student counts via LEFT OUTER JOIN & GROUP BY
- **Category:** Analytical SQL Validation
- **Test Type:** Aggregation / Reporting
- **Preconditions:** Departments 1, 2, 3 seeded.
- **SQL Statement:**
  ```sql
  SELECT d.department_name, COUNT(s.student_id) AS total_students
  FROM departments d
  LEFT JOIN students s ON d.department_id = s.department_id
  GROUP BY d.department_id, d.department_name;
  ```
- **Expected Result:** Returns student counts per department (Computer Science: 2, Electronics: 2, Mechanical: 1).
- **Actual Result:** Aggregated student counts match actual seeded student distribution.
- **Status:** **PASS**
- **Severity:** Medium (S3)

#### DB20: Audit for duplicate email occurrences via GROUP BY & HAVING
- **Category:** Data Hygiene & Audit
- **Test Type:** Audit / Data Integrity
- **Preconditions:** `students` table populated.
- **SQL Statement:**
  ```sql
  SELECT email, COUNT(*) AS total
  FROM students
  GROUP BY email
  HAVING COUNT(*) > 1;
  ```
- **Expected Result:** 0 rows returned (proves no duplicate emails exist in the database).
- **Actual Result:** 0 rows returned. Data hygiene verified.
- **Status:** **PASS**
- **Severity:** High (S2)
