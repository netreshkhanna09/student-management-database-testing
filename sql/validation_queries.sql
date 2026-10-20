-- =====================================================================
-- DATABASE VALIDATION & DATA AUDITING QUERIES
-- Application Under Test: student_qa Database
-- Description: Analytical and QA verification queries using JOINs,
--              GROUP BY, HAVING, and aggregate statistical functions.
-- =====================================================================

USE student_qa;

-- ---------------------------------------------------------------------
-- 1. INNER JOIN: Retrieve Student Details Along with Department Name
-- Business Use: Validate that every enrolled student is accurately mapped
--               to their official academic department.
-- ---------------------------------------------------------------------
SELECT 
    s.student_id,
    s.student_name,
    s.email,
    s.age,
    d.department_name,
    s.marks
FROM students s
INNER JOIN departments d
    ON s.department_id = d.department_id
ORDER BY s.student_id ASC;


-- ---------------------------------------------------------------------
-- 2. LEFT OUTER JOIN + COUNT(): Total Students Per Department
-- Business Use: Ensure all departments appear in reporting, even if
--               a department has zero enrolled students.
-- ---------------------------------------------------------------------
SELECT 
    d.department_id,
    d.department_name,
    COUNT(s.student_id) AS total_enrolled_students
FROM departments d
LEFT JOIN students s
    ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_enrolled_students DESC, d.department_id ASC;


-- ---------------------------------------------------------------------
-- 3. FILTERING (WHERE): High-Performing Students (Marks > 80.00)
-- Business Use: Academic scholarship eligibility list verification.
-- ---------------------------------------------------------------------
SELECT 
    s.student_id,
    s.student_name,
    d.department_name,
    s.marks
FROM students s
JOIN departments d
    ON s.department_id = d.department_id
WHERE s.marks > 80.00
ORDER BY s.marks DESC;


-- ---------------------------------------------------------------------
-- 4. DATA INTEGRITY AUDIT: Duplicate Email Detection
-- Business Use: Verify that no duplicate email addresses exist in the table.
-- Expected Outcome: 0 rows returned (Empty result set proves uniqueness).
-- ---------------------------------------------------------------------
SELECT 
    email,
    COUNT(*) AS occurrence_count
FROM students
GROUP BY email
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------------------
-- 5. STATISTICAL AGGREGATION: Average, Min, and Max Marks by Department
-- Business Use: Departmental grading distribution and performance benchmark.
-- ---------------------------------------------------------------------
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count,
    ROUND(AVG(s.marks), 2) AS average_marks,
    MIN(s.marks) AS minimum_marks,
    MAX(s.marks) AS maximum_marks
FROM departments d
LEFT JOIN students s
    ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;


-- ---------------------------------------------------------------------
-- 6. DATA HYGIENE AUDIT: Identify Incomplete / Null Records
-- Business Use: Check for students who have not completed profile data (NULL age/marks).
-- ---------------------------------------------------------------------
SELECT 
    student_id,
    student_name,
    email,
    CASE 
        WHEN age IS NULL AND marks IS NULL THEN 'Missing Age and Marks'
        WHEN age IS NULL THEN 'Missing Age'
        WHEN marks IS NULL THEN 'Missing Marks'
        ELSE 'Complete'
    END AS profile_status
FROM students
WHERE age IS NULL OR marks IS NULL;


-- ---------------------------------------------------------------------
-- 7. ORPHANED RECORD AUDIT: Foreign Key Integrity Check
-- Business Use: Identify any students referencing non-existent departments.
-- Expected Result: 0 rows (proves relational referential integrity).
-- ---------------------------------------------------------------------
SELECT 
    s.student_id,
    s.student_name,
    s.department_id
FROM students s
LEFT JOIN departments d
    ON s.department_id = d.department_id
WHERE d.department_id IS NULL;
