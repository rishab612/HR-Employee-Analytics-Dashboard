-- ============================================================
-- HR EMPLOYEE ANALYTICS
-- DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS HR_Analytics;

USE HR_Analytics;


-- ============================================================
-- 1. DEPARTMENT DIMENSION
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    DepartmentID VARCHAR(10) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);


-- ============================================================
-- 2. JOB ROLE DIMENSION
-- ============================================================

CREATE TABLE IF NOT EXISTS job_roles (
    JobRoleID VARCHAR(10) PRIMARY KEY,
    JobRole VARCHAR(100) NOT NULL UNIQUE
);


-- ============================================================
-- 3. EMPLOYEE STAGING TABLE
-- Raw employee data imported from Excel
-- ============================================================

CREATE TABLE IF NOT EXISTS employees_staging (

    EmployeeID VARCHAR(10),
    EmployeeName VARCHAR(100),
    Gender VARCHAR(20),
    Age INT,
    Department VARCHAR(100),
    JobRole VARCHAR(100),
    Education VARCHAR(50),
    JobLevel INT,
    MonthlyIncome DECIMAL(12,2),
    TotalWorkingYears INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSincePromotion INT,
    JobSatisfaction INT,
    EnvironmentSatisfaction INT,
    WorkLifeBalance INT,
    PerformanceRating INT,
    TrainingHours INT,
    Overtime VARCHAR(10),
    BusinessTravel VARCHAR(30),
    MaritalStatus VARCHAR(20),
    DistanceFromHome INT,
    NumCompaniesWorked INT,
    HireDate DATE,
    ExitDate DATE,
    Attrition VARCHAR(10),
    AgeGroup VARCHAR(20),
    SalaryBand VARCHAR(30),
    TenureBand VARCHAR(30)
);


-- ============================================================
-- 4. FINAL EMPLOYEE FACT TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (

    EmployeeID VARCHAR(10) PRIMARY KEY,

    EmployeeName VARCHAR(100) NOT NULL,

    Gender VARCHAR(20),

    Age INT,

    DepartmentID VARCHAR(10),

    JobRoleID VARCHAR(10),

    Education VARCHAR(50),

    JobLevel INT,

    MonthlyIncome DECIMAL(12,2),

    TotalWorkingYears INT,

    YearsAtCompany INT,

    YearsInCurrentRole INT,

    YearsSincePromotion INT,

    JobSatisfaction INT,

    EnvironmentSatisfaction INT,

    WorkLifeBalance INT,

    PerformanceRating INT,

    TrainingHours INT,

    Overtime VARCHAR(10),

    BusinessTravel VARCHAR(30),

    MaritalStatus VARCHAR(20),

    DistanceFromHome INT,

    NumCompaniesWorked INT,

    HireDate DATE,

    ExitDate DATE,

    Attrition VARCHAR(10),

    AgeGroup VARCHAR(20),

    SalaryBand VARCHAR(30),

    TenureBand VARCHAR(30),

    FOREIGN KEY (DepartmentID)
        REFERENCES departments(DepartmentID),

    FOREIGN KEY (JobRoleID)
        REFERENCES job_roles(JobRoleID)
);


-- ============================================================
-- 5. POPULATE DEPARTMENTS
-- ============================================================

INSERT IGNORE INTO departments
(
    DepartmentID,
    DepartmentName
)
SELECT
    CONCAT(
        'DEPT',
        LPAD(
            ROW_NUMBER() OVER (
                ORDER BY Department
            ),
            3,
            '0'
        )
    ),
    Department
FROM
(
    SELECT DISTINCT
        TRIM(Department) AS Department
    FROM employees_staging
    WHERE Department IS NOT NULL
      AND TRIM(Department) <> ''
) AS dept;


-- ============================================================
-- 6. POPULATE JOB ROLES
-- Handles all unique roles from staging
-- ============================================================

INSERT IGNORE INTO job_roles
(
    JobRoleID,
    JobRole
)
SELECT
    CONCAT(
        'ROLE',
        LPAD(
            ROW_NUMBER() OVER (
                ORDER BY JobRole
            ),
            3,
            '0'
        )
    ),
    JobRole
FROM
(
    SELECT DISTINCT
        TRIM(JobRole) AS JobRole
    FROM employees_staging
    WHERE JobRole IS NOT NULL
      AND TRIM(JobRole) <> ''
) AS roles;


-- ============================================================
-- 7. POPULATE FINAL EMPLOYEE TABLE
-- Converts department/job role names into IDs
-- ============================================================

INSERT IGNORE INTO employees
(
    EmployeeID,
    EmployeeName,
    Gender,
    Age,
    DepartmentID,
    JobRoleID,
    Education,
    JobLevel,
    MonthlyIncome,
    TotalWorkingYears,
    YearsAtCompany,
    YearsInCurrentRole,
    YearsSincePromotion,
    JobSatisfaction,
    EnvironmentSatisfaction,
    WorkLifeBalance,
    PerformanceRating,
    TrainingHours,
    Overtime,
    BusinessTravel,
    MaritalStatus,
    DistanceFromHome,
    NumCompaniesWorked,
    HireDate,
    ExitDate,
    Attrition,
    AgeGroup,
    SalaryBand,
    TenureBand
)
SELECT
    s.EmployeeID,
    s.EmployeeName,
    s.Gender,
    s.Age,
    d.DepartmentID,
    j.JobRoleID,
    s.Education,
    s.JobLevel,
    s.MonthlyIncome,
    s.TotalWorkingYears,
    s.YearsAtCompany,
    s.YearsInCurrentRole,
    s.YearsSincePromotion,
    s.JobSatisfaction,
    s.EnvironmentSatisfaction,
    s.WorkLifeBalance,
    s.PerformanceRating,
    s.TrainingHours,
    s.Overtime,
    s.BusinessTravel,
    s.MaritalStatus,
    s.DistanceFromHome,
    s.NumCompaniesWorked,
    s.HireDate,
    s.ExitDate,
    s.Attrition,
    s.AgeGroup,
    s.SalaryBand,
    s.TenureBand
FROM employees_staging s

INNER JOIN departments d
    ON TRIM(LOWER(s.Department))
       = TRIM(LOWER(d.DepartmentName))

INNER JOIN job_roles j
    ON TRIM(LOWER(s.JobRole))
       = TRIM(LOWER(j.JobRole));


-- ============================================================
-- 8. FINAL DATABASE VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS TotalEmployees
FROM employees;

SELECT
    COUNT(*) AS TotalDepartments
FROM departments;

SELECT
    COUNT(*) AS TotalJobRoles
FROM job_roles;