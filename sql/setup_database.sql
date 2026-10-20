-- =====================================================================
-- DATABASE SETUP SCRIPT: Student Management System (student_qa)
-- Standard: ANSI SQL / MySQL 8.0+ Compatible
-- Description: Creates schema, tables, constraints, and initial seed data
-- =====================================================================

-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS student_qa;
USE student_qa;

-- 2. Drop existing tables if re-running (respecting foreign key order)
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;

-- 3. Create Departments Table (Parent Table)
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE
);

-- 4. Create Students Table (Child Table with Foreign Key & Check Constraints)
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    age INT,
    department_id INT,
    marks DECIMAL(5,2),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_student_age CHECK (age IS NULL OR (age >= 16 AND age <= 100)),
    CONSTRAINT chk_student_marks CHECK (marks IS NULL OR (marks >= 0.00 AND marks <= 100.00))
);

-- 5. Seed Initial Department Data
INSERT INTO departments (department_id, department_name) VALUES
(1, 'Computer Science'),
(2, 'Electronics'),
(3, 'Mechanical');

-- 6. Seed Initial Student Records
INSERT INTO students (student_id, student_name, email, age, department_id, marks) VALUES
(101, 'Aarav Sharma', 'aarav@example.com', 20, 1, 85.50),
(102, 'Priya Singh',  'priya@example.com', 21, 2, 91.00),
(103, 'Rahul Verma',  'rahul@example.com', 19, 1, 76.00),
(104, 'Ananya Gupta', 'ananya@example.com', 22, 3, 88.00),
(105, 'Kabir Mehta',  'kabir@example.com', 20, 2, 69.50);

-- 7. Verification Queries
SELECT '--- DEPARTMENTS SEEDED ---' AS status;
SELECT * FROM departments;

SELECT '--- STUDENTS SEEDED ---' AS status;
SELECT * FROM students;
