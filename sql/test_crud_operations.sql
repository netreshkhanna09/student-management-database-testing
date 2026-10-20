-- =====================================================================
-- DATABASE FUNCTIONAL & CONSTRAINT TEST SUITE
-- Application Under Test: student_qa Database
-- Description: Executes CRUD operations, integrity constraints, and edge tests
-- =====================================================================

USE student_qa;

-- ---------------------------------------------------------------------
-- TEST A: Create Record (Positive Test)
-- Objective: Insert a valid student record and verify persistence.
-- ---------------------------------------------------------------------
INSERT INTO students (student_id, student_name, email, age, department_id, marks)
VALUES (106, 'Riya Jain', 'riya@example.com', 20, 1, 82.50);

-- Verification:
SELECT * FROM students WHERE student_id = 106;
-- Expected Result: Exactly 1 row returned matching inserted attributes.


-- ---------------------------------------------------------------------
-- TEST B: Update Record (Positive Test)
-- Objective: Update marks for student 106 and verify persistence.
-- ---------------------------------------------------------------------
UPDATE students
SET marks = 95.00
WHERE student_id = 106;

-- Verification:
SELECT student_id, student_name, marks
FROM students
WHERE student_id = 106;
-- Expected Result: marks updated to 95.00; name and other fields unchanged.


-- ---------------------------------------------------------------------
-- TEST C: Delete Record (Positive Test)
-- Objective: Delete test student 106 and verify record removal.
-- ---------------------------------------------------------------------
DELETE FROM students
WHERE student_id = 106;

-- Verification:
SELECT * FROM students WHERE student_id = 106;
-- Expected Result: 0 rows returned (Empty result set).


-- ---------------------------------------------------------------------
-- TEST D: Duplicate Primary Key (Negative Test)
-- Objective: Attempt to insert an existing student_id (101).
-- Expected Result: FAILS with PRIMARY KEY violation error.
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (101, 'Duplicate ID Student', 'duplicate.id@example.com', 20, 1, 80.00);


-- ---------------------------------------------------------------------
-- TEST E: NOT NULL Constraint on student_name (Negative Test)
-- Objective: Attempt to insert a student with NULL name.
-- Expected Result: FAILS with NOT NULL constraint violation on student_name.
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (107, NULL, 'noname@example.com', 20, 1, 80.00);


-- ---------------------------------------------------------------------
-- TEST F: UNIQUE Constraint on email (Negative Test)
-- Objective: Attempt to insert student with an already registered email.
-- Expected Result: FAILS with UNIQUE KEY constraint violation on email.
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (107, 'New Student', 'aarav@example.com', 20, 1, 80.00);


-- ---------------------------------------------------------------------
-- TEST G1: Boundary Value Analysis - Age Below Minimum (age < 16)
-- Objective: Attempt to insert student with age 10.
-- Expected Result: FAILS with CHECK constraint violation (chk_student_age).
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (107, 'Underage Student', 'underage@example.com', 10, 1, 80.00);


-- ---------------------------------------------------------------------
-- TEST G2: Boundary Value Analysis - Age Above Maximum (age > 100)
-- Objective: Attempt to insert student with age 105.
-- Expected Result: FAILS with CHECK constraint violation (chk_student_age).
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (108, 'Overage Student', 'overage@example.com', 105, 1, 80.00);


-- ---------------------------------------------------------------------
-- TEST H1: Boundary Value Analysis - Marks Above 100 (marks > 100.00)
-- Objective: Attempt to insert student with marks = 120.00.
-- Expected Result: FAILS with CHECK constraint violation (chk_student_marks).
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (109, 'Excess Marks', 'excess@example.com', 20, 1, 120.00);


-- ---------------------------------------------------------------------
-- TEST H2: Boundary Value Analysis - Marks Negative (marks < 0.00)
-- Objective: Attempt to insert student with marks = -15.00.
-- Expected Result: FAILS with CHECK constraint violation (chk_student_marks).
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (110, 'Negative Marks', 'negative@example.com', 20, 1, -15.00);


-- ---------------------------------------------------------------------
-- TEST I: Foreign Key Referential Integrity (Invalid Parent ID)
-- Objective: Attempt to assign student to non-existent department_id (999).
-- Expected Result: FAILS with FOREIGN KEY constraint failure.
-- ---------------------------------------------------------------------
-- INSERT INTO students (student_id, student_name, email, age, department_id, marks)
-- VALUES (111, 'Invalid Dept Student', 'invalid.dept@example.com', 20, 999, 80.00);


-- ---------------------------------------------------------------------
-- TEST J: Parent Record Deletion Restriction (Referential Integrity)
-- Objective: Attempt to delete department 1 (Computer Science) while students exist.
-- Expected Result: FAILS with Cannot delete or update a parent row: a foreign key constraint fails.
-- ---------------------------------------------------------------------
-- DELETE FROM departments WHERE department_id = 1;


-- ---------------------------------------------------------------------
-- TEST K: Valid Nullable Fields Insertion (Positive Edge Test)
-- Objective: Insert student with valid NULL for optional age and marks.
-- Expected Result: Insertion succeeds; age and marks stored as NULL.
-- ---------------------------------------------------------------------
INSERT INTO students (student_id, student_name, email, age, department_id, marks)
VALUES (112, 'Siddharth Rao', 'siddharth@example.com', NULL, 3, NULL);

-- Verification:
SELECT student_id, student_name, age, marks
FROM students
WHERE student_id = 112;

-- Cleanup temporary edge test record:
DELETE FROM students WHERE student_id = 112;
