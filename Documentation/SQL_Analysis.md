# SQL Analysis -- HR Employee Analytics

**Project:** HR Employee Analytics\
**Prepared By:** Rishab Roy\
**Database:** `HR_Analytics`\
**Database Engine:** MySQL\
**Dataset:** 1,500 employee records\
**Purpose:** Workforce, salary, attrition, performance, satisfaction,
and HR trend analysis

------------------------------------------------------------------------

## 1. Overview

This document explains the SQL analysis layer of the **HR Employee
Analytics** project.

The SQL workflow is designed to:

-   validate the imported employee data
-   analyze workforce size and composition
-   calculate employee attrition
-   compare departments and job roles
-   analyze salary and salary bands
-   analyze age and tenure
-   investigate overtime and business travel
-   examine performance and satisfaction
-   support Power BI reporting
-   provide reusable SQL views for dashboard development

The final SQL folder is intentionally separated into three files:

``` text
SQL/
├── database_setup.sql
├── data_analysis.sql
└── views.sql
```

Temporary verification scripts used during development are not part of
the final SQL structure.

------------------------------------------------------------------------

# 2. Database Architecture

The MySQL database is named:

``` sql
HR_Analytics
```

The main tables are:

  Table                 Purpose
  --------------------- ------------------------------------------
  `employees_staging`   Stores the imported raw employee dataset
  `departments`         Department lookup/dimension table
  `job_roles`           Job-role lookup/dimension table
  `employees`           Final analytical employee table

### Data flow

``` text
Excel / CSV
    ↓
Python preprocessing
    ↓
employees_staging
    ↓
Department + Job Role mapping
    ↓
employees
    ↓
SQL Analysis / Views
    ↓
Power BI
```

------------------------------------------------------------------------

# 3. SQL File Structure

## 3.1 `database_setup.sql`

This file is responsible for creating and preparing the database
structure.

It contains:

1.  Database creation
2.  Department table creation
3.  Job-role table creation
4.  Employee staging table creation
5.  Final employee table creation
6.  Department population
7.  Job-role population
8.  Employee population
9.  Final validation checks

> **Important:** The staging table must contain the imported employee
> data before the dimension and final employee population steps are
> executed.

------------------------------------------------------------------------

## 3.2 `data_analysis.sql`

This file contains business-oriented SQL queries.

It is used for:

-   KPI validation
-   workforce analysis
-   attrition analysis
-   salary analysis
-   demographic analysis
-   tenure analysis
-   overtime analysis
-   performance analysis
-   satisfaction analysis
-   employee-level reporting

------------------------------------------------------------------------

## 3.3 `views.sql`

This file creates reusable SQL views that simplify reporting and Power
BI integration.

Recommended views:

``` text
vw_department_attrition
vw_job_role_attrition
vw_salary_band_analysis
vw_tenure_band_analysis
vw_overtime_attrition
vw_performance_analysis
vw_employee_master
```

------------------------------------------------------------------------

# 4. Database Setup

## 4.1 Create Database

``` sql
CREATE DATABASE IF NOT EXISTS HR_Analytics;
USE HR_Analytics;
```

------------------------------------------------------------------------

# 5. Department Table

The department table stores unique department names.

``` sql
CREATE TABLE IF NOT EXISTS departments (
    DepartmentID VARCHAR(10) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
```

### Department fields

  Field              Type           Description
  ------------------ -------------- ------------------------------
  `DepartmentID`     VARCHAR(10)    Unique department identifier
  `DepartmentName`   VARCHAR(100)   Department name

Example:

``` text
DEPT001 → Customer Service
DEPT002 → Finance
DEPT003 → Human Resources
DEPT004 → IT
DEPT005 → Marketing
DEPT006 → Operations
DEPT007 → Research & Development
DEPT008 → Sales
```

------------------------------------------------------------------------

# 6. Job Role Table

The job-role table stores unique job roles.

``` sql
CREATE TABLE IF NOT EXISTS job_roles (
    JobRoleID VARCHAR(10) PRIMARY KEY,
    JobRole VARCHAR(100) NOT NULL UNIQUE
);
```

### Job-role fields

  Field         Type           Description
  ------------- -------------- ------------------------
  `JobRoleID`   VARCHAR(10)    Unique role identifier
  `JobRole`     VARCHAR(100)   Employee job role

The final project derives the complete job-role list from the staging
dataset rather than relying on a short hardcoded list.

------------------------------------------------------------------------

# 7. Employee Staging Table

The staging table keeps the imported employee-level data before
relational mapping.

Important source columns include:

``` text
EmployeeID
EmployeeName
Gender
Age
Department
JobRole
Education
JobLevel
MonthlyIncome
TotalWorkingYears
YearsAtCompany
YearsInCurrentRole
YearsSincePromotion
JobSatisfaction
EnvironmentSatisfaction
WorkLifeBalance
PerformanceRating
TrainingHours
Overtime
BusinessTravel
MaritalStatus
DistanceFromHome
NumCompaniesWorked
HireDate
ExitDate
Attrition
AgeGroup
SalaryBand
TenureBand
```

The staging layer is useful because it separates **raw imported data**
from the normalized final database structure.

------------------------------------------------------------------------

# 8. Final Employee Table

The final `employees` table uses foreign keys for department and job
role.

Important fields include:

``` text
EmployeeID
EmployeeName
Gender
Age
DepartmentID
JobRoleID
Education
JobLevel
MonthlyIncome
TotalWorkingYears
YearsAtCompany
YearsInCurrentRole
YearsSincePromotion
JobSatisfaction
EnvironmentSatisfaction
WorkLifeBalance
PerformanceRating
TrainingHours
Overtime
BusinessTravel
MaritalStatus
DistanceFromHome
NumCompaniesWorked
HireDate
ExitDate
Attrition
AgeGroup
SalaryBand
TenureBand
```

Relationships:

``` text
employees.DepartmentID
        ↓
departments.DepartmentID

employees.JobRoleID
        ↓
job_roles.JobRoleID
```

------------------------------------------------------------------------

# 9. Data Validation Queries

## 9.1 Total Staging Records

``` sql
SELECT COUNT(*) AS TotalEmployees
FROM employees_staging;
```

Expected project result:

``` text
1500
```

------------------------------------------------------------------------

## 9.2 Total Final Records

``` sql
SELECT COUNT(*) AS TotalEmployees
FROM employees;
```

Expected project result:

``` text
1500
```

------------------------------------------------------------------------

## 9.3 Compare Staging and Final Counts

``` sql
SELECT
    (SELECT COUNT(*) FROM employees_staging) AS StagingRecords,
    (SELECT COUNT(*) FROM employees) AS FinalRecords;
```

Expected:

``` text
StagingRecords = 1500
FinalRecords   = 1500
```

------------------------------------------------------------------------

## 9.4 Department Mapping Validation

``` sql
SELECT COUNT(*) AS UnmatchedDepartments
FROM employees_staging s
LEFT JOIN departments d
    ON TRIM(LOWER(s.Department)) =
       TRIM(LOWER(d.DepartmentName))
WHERE d.DepartmentID IS NULL;
```

Expected:

``` text
0
```

------------------------------------------------------------------------

## 9.5 Job Role Mapping Validation

``` sql
SELECT COUNT(*) AS UnmatchedJobRoles
FROM employees_staging s
LEFT JOIN job_roles j
    ON TRIM(LOWER(s.JobRole)) =
       TRIM(LOWER(j.JobRole))
WHERE j.JobRoleID IS NULL;
```

Expected:

``` text
0
```

------------------------------------------------------------------------

# 10. Workforce Analysis

## 10.1 Total Employees

``` sql
SELECT COUNT(*) AS TotalEmployees
FROM employees;
```

Expected:

``` text
1500
```

------------------------------------------------------------------------

## 10.2 Active Employees

``` sql
SELECT COUNT(*) AS ActiveEmployees
FROM employees
WHERE Attrition = 'No';
```

Expected:

``` text
1284
```

------------------------------------------------------------------------

## 10.3 Attrition Count

``` sql
SELECT COUNT(*) AS AttritionCount
FROM employees
WHERE Attrition = 'Yes';
```

Expected:

``` text
216
```

------------------------------------------------------------------------

## 10.4 Attrition Rate

``` sql
SELECT
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees;
```

Expected:

``` text
14.40%
```

------------------------------------------------------------------------

## 10.5 Attrition Distribution

``` sql
SELECT
    Attrition,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY Attrition
ORDER BY EmployeeCount DESC;
```

This provides the count of employees who remained and employees who
left.

------------------------------------------------------------------------

# 11. Department Analysis

## 11.1 Employees by Department

``` sql
SELECT
    d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

## 11.2 Attrition by Department

``` sql
SELECT
    d.DepartmentName,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AttritionRate DESC;
```

### Business use

This query supports:

-   department comparison
-   attrition-rate visualization
-   HR department-level investigation

------------------------------------------------------------------------

# 12. Job Role Analysis

## 12.1 Employees by Job Role

``` sql
SELECT
    j.JobRole,
    COUNT(*) AS EmployeeCount
FROM employees e
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID
GROUP BY j.JobRole
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

## 12.2 Attrition by Job Role

``` sql
SELECT
    j.JobRole,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees e
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID
GROUP BY j.JobRole
ORDER BY AttritionRate DESC;
```

------------------------------------------------------------------------

# 13. Salary Analysis

## 13.1 Average Salary

``` sql
SELECT
    ROUND(AVG(MonthlyIncome), 2) AS AverageMonthlyIncome
FROM employees;
```

------------------------------------------------------------------------

## 13.2 Salary by Department

``` sql
SELECT
    d.DepartmentName,
    ROUND(AVG(e.MonthlyIncome), 2) AS AverageSalary
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;
```

------------------------------------------------------------------------

## 13.3 Salary by Job Role

``` sql
SELECT
    j.JobRole,
    ROUND(AVG(e.MonthlyIncome), 2) AS AverageSalary
FROM employees e
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID
GROUP BY j.JobRole
ORDER BY AverageSalary DESC;
```

------------------------------------------------------------------------

# 14. Salary Band Analysis

SalaryBand is a derived field created during Python preprocessing.

``` sql
SELECT
    SalaryBand,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY SalaryBand
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

## 14.1 Attrition by Salary Band

``` sql
SELECT
    SalaryBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY SalaryBand
ORDER BY AttritionRate DESC;
```

------------------------------------------------------------------------

# 15. Age Analysis

## 15.1 Age Group Distribution

``` sql
SELECT
    AgeGroup,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY AgeGroup
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

## 15.2 Attrition by Age Group

``` sql
SELECT
    AgeGroup,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY AgeGroup
ORDER BY AttritionRate DESC;
```

------------------------------------------------------------------------

## 15.3 Average Age

``` sql
SELECT
    ROUND(AVG(Age), 2) AS AverageAge
FROM employees;
```

Expected project result:

``` text
33.77
```

------------------------------------------------------------------------

# 16. Tenure Analysis

## 16.1 Average Tenure

``` sql
SELECT
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure
FROM employees;
```

Expected project result:

``` text
4.11 years
```

------------------------------------------------------------------------

## 16.2 Tenure Band Distribution

``` sql
SELECT
    TenureBand,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY TenureBand
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

## 16.3 Attrition by Tenure Band

``` sql
SELECT
    TenureBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY TenureBand
ORDER BY AttritionRate DESC;
```

------------------------------------------------------------------------

# 17. Overtime Analysis

## 17.1 Overtime Distribution

``` sql
SELECT
    Overtime,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY Overtime
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

## 17.2 Attrition by Overtime

``` sql
SELECT
    Overtime,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY Overtime
ORDER BY AttritionRate DESC;
```

This query can be visualized in Power BI using a column or bar chart.

------------------------------------------------------------------------

# 18. Gender Analysis

## 18.1 Gender Distribution

``` sql
SELECT
    Gender,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY Gender
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

## 18.2 Attrition by Gender

``` sql
SELECT
    Gender,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY Gender
ORDER BY AttritionRate DESC;
```

------------------------------------------------------------------------

# 19. Performance Analysis

## 19.1 Performance Rating Distribution

``` sql
SELECT
    PerformanceRating,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY PerformanceRating
ORDER BY PerformanceRating;
```

------------------------------------------------------------------------

## 19.2 Attrition by Performance Rating

``` sql
SELECT
    PerformanceRating,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY PerformanceRating
ORDER BY PerformanceRating;
```

------------------------------------------------------------------------

## 19.3 High Performers

``` sql
SELECT
    COUNT(*) AS HighPerformers
FROM employees
WHERE PerformanceRating >= 4;
```

The threshold can be adjusted if a different business definition is
required.

------------------------------------------------------------------------

# 20. Job Satisfaction Analysis

## 20.1 Satisfaction Distribution

``` sql
SELECT
    JobSatisfaction,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
```

------------------------------------------------------------------------

## 20.2 Attrition by Job Satisfaction

``` sql
SELECT
    JobSatisfaction,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
```

------------------------------------------------------------------------

# 21. Work-Life Balance Analysis

``` sql
SELECT
    WorkLifeBalance,
    COUNT(*) AS EmployeeCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;
```

------------------------------------------------------------------------

# 22. Training Analysis

## 22.1 Average Training Hours

``` sql
SELECT
    ROUND(AVG(TrainingHours), 2) AS AverageTrainingHours
FROM employees;
```

------------------------------------------------------------------------

## 22.2 Training Hours by Attrition

``` sql
SELECT
    Attrition,
    COUNT(*) AS EmployeeCount,
    ROUND(AVG(TrainingHours), 2) AS AverageTrainingHours
FROM employees
GROUP BY Attrition;
```

------------------------------------------------------------------------

# 23. Business Travel Analysis

``` sql
SELECT
    BusinessTravel,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY BusinessTravel
ORDER BY AttritionRate DESC;
```

------------------------------------------------------------------------

# 24. Education Analysis

``` sql
SELECT
    Education,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY Education
ORDER BY EmployeeCount DESC;
```

------------------------------------------------------------------------

# 25. Job Level Analysis

``` sql
SELECT
    JobLevel,
    COUNT(*) AS EmployeeCount,
    ROUND(AVG(MonthlyIncome), 2) AS AverageSalary,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY JobLevel
ORDER BY JobLevel;
```

------------------------------------------------------------------------

# 26. Employee Experience Analysis

## 26.1 Total Working Years

``` sql
SELECT
    ROUND(AVG(TotalWorkingYears), 2) AS AverageTotalWorkingYears
FROM employees;
```

## 26.2 Previous Companies

``` sql
SELECT
    NumCompaniesWorked,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY NumCompaniesWorked
ORDER BY NumCompaniesWorked;
```

------------------------------------------------------------------------

# 27. Career Progression Analysis

``` sql
SELECT
    ROUND(AVG(YearsInCurrentRole), 2) AS AvgYearsInCurrentRole,
    ROUND(AVG(YearsSincePromotion), 2) AS AvgYearsSincePromotion
FROM employees;
```

------------------------------------------------------------------------

# 28. Employee Master Query

This query combines employee information with department and job-role
names.

``` sql
SELECT
    e.EmployeeID,
    e.EmployeeName,
    e.Gender,
    e.Age,
    d.DepartmentName,
    j.JobRole,
    e.Education,
    e.JobLevel,
    e.MonthlyIncome,
    e.TotalWorkingYears,
    e.YearsAtCompany,
    e.YearsInCurrentRole,
    e.YearsSincePromotion,
    e.JobSatisfaction,
    e.EnvironmentSatisfaction,
    e.WorkLifeBalance,
    e.PerformanceRating,
    e.TrainingHours,
    e.Overtime,
    e.BusinessTravel,
    e.MaritalStatus,
    e.DistanceFromHome,
    e.NumCompaniesWorked,
    e.HireDate,
    e.ExitDate,
    e.Attrition,
    e.AgeGroup,
    e.SalaryBand,
    e.TenureBand
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID;
```

This is useful for:

-   Power BI imports
-   employee detail reports
-   exportable HR analysis
-   validation of relational mappings

------------------------------------------------------------------------

# 29. Reusable SQL Views

## 29.1 Department Attrition View

``` sql
CREATE OR REPLACE VIEW vw_department_attrition AS
SELECT
    d.DepartmentName,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
```

------------------------------------------------------------------------

## 29.2 Job Role Attrition View

``` sql
CREATE OR REPLACE VIEW vw_job_role_attrition AS
SELECT
    j.JobRole,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees e
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID
GROUP BY j.JobRole;
```

------------------------------------------------------------------------

## 29.3 Salary Band View

``` sql
CREATE OR REPLACE VIEW vw_salary_band_analysis AS
SELECT
    SalaryBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageSalary
FROM employees
GROUP BY SalaryBand;
```

------------------------------------------------------------------------

## 29.4 Tenure Band View

``` sql
CREATE OR REPLACE VIEW vw_tenure_band_analysis AS
SELECT
    TenureBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY TenureBand;
```

------------------------------------------------------------------------

## 29.5 Overtime Attrition View

``` sql
CREATE OR REPLACE VIEW vw_overtime_attrition AS
SELECT
    Overtime,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employees
GROUP BY Overtime;
```

------------------------------------------------------------------------

## 29.6 Performance View

``` sql
CREATE OR REPLACE VIEW vw_performance_analysis AS
SELECT
    PerformanceRating,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS AttritionRate,
    ROUND(AVG(MonthlyIncome), 2) AS AverageSalary
FROM employees
GROUP BY PerformanceRating;
```

------------------------------------------------------------------------

## 29.7 Employee Master View

``` sql
CREATE OR REPLACE VIEW vw_employee_master AS
SELECT
    e.EmployeeID,
    e.EmployeeName,
    e.Gender,
    e.Age,
    d.DepartmentName,
    j.JobRole,
    e.Education,
    e.JobLevel,
    e.MonthlyIncome,
    e.TotalWorkingYears,
    e.YearsAtCompany,
    e.YearsInCurrentRole,
    e.YearsSincePromotion,
    e.JobSatisfaction,
    e.EnvironmentSatisfaction,
    e.WorkLifeBalance,
    e.PerformanceRating,
    e.TrainingHours,
    e.Overtime,
    e.BusinessTravel,
    e.MaritalStatus,
    e.DistanceFromHome,
    e.NumCompaniesWorked,
    e.HireDate,
    e.ExitDate,
    e.Attrition,
    e.AgeGroup,
    e.SalaryBand,
    e.TenureBand
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID;
```

------------------------------------------------------------------------

# 30. Power BI Usage

The SQL results are designed to support the following Power BI report
pages:

  -----------------------------------------------------------------------
  Power BI Page                       SQL Analysis Used
  ----------------------------------- -----------------------------------
  Executive Overview                  Total employees, active employees,
                                      attrition, salary, age, tenure

  Attrition Analysis                  Department, job role, salary band,
                                      tenure band, overtime

  Workforce & Salary                  Department, job role, salary and
                                      workforce distribution

  Performance & Satisfaction          Performance, satisfaction,
                                      work-life balance, training

  Employee Details                    Employee master query/view

  HR Insights                         Department, job role, salary,
                                      tenure, overtime and satisfaction
                                      comparisons
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 31. Expected Project KPI Results

Based on the completed project dataset:

  KPI                            Result
  ------------------------ ------------
  Total Employees                 1,500
  Active Employees                1,284
  Attrition Count                   216
  Attrition Rate                 14.40%
  Average Age                     33.77
  Average Tenure             4.11 years
  Average Monthly Salary       ≈ 56.59K

These values should be validated against the current MySQL database and
Power BI model after any data refresh.

------------------------------------------------------------------------

# 32. Recommended SQL Execution Order

For a fresh database:

``` text
1. Create HR_Analytics database
2. Create tables
3. Import Excel/CSV into employees_staging
4. Populate departments
5. Populate job_roles
6. Populate employees
7. Validate record counts
8. Run data_analysis.sql
9. Create views using views.sql
10. Connect Power BI
```

For the **already completed project database**, avoid blindly rerunning
the entire setup script because the final `employees` table already
contains the 1,500 records.

Use:

``` text
data_analysis.sql
views.sql
```

for analysis and reporting.

------------------------------------------------------------------------

# 33. Data Quality Checklist

Before publishing the project, verify:

-   [x] Database name is `HR_Analytics`
-   [x] Staging table contains 1,500 records
-   [x] Final employee table contains 1,500 records
-   [x] Department mappings have no unmatched values
-   [x] Job-role mappings have no unmatched values
-   [x] EmployeeID values are unique
-   [x] Attrition values are valid
-   [x] MonthlyIncome contains numeric values
-   [x] Date fields are stored as dates
-   [x] Derived fields are populated
-   [x] Foreign keys point to valid lookup records
-   [x] SQL KPI values match Power BI KPI values

------------------------------------------------------------------------

# 34. Portfolio Value

This SQL analysis demonstrates practical skills in:

-   MySQL database design
-   Relational data modeling
-   Primary and foreign keys
-   Data normalization
-   SQL joins
-   Aggregation
-   `GROUP BY`
-   `CASE`
-   conditional aggregation
-   percentage calculations
-   analytical views
-   data validation
-   business KPI development
-   Power BI data preparation

------------------------------------------------------------------------

# 35. Final SQL Folder

The final GitHub project should contain only the cleaned SQL files:

``` text
SQL/
├── database_setup.sql
├── data_analysis.sql
└── views.sql
```

Temporary development and verification files such as:

``` text
gptverify.sql
queryverification.sql
SqlQuery.sql
verificationandpopulate.sql
```

do not need to be included in the final SQL folder.

------------------------------------------------------------------------

# 36. Conclusion

The SQL layer forms the foundation of the HR Employee Analytics project.
It converts the imported employee data into a structured relational
model and provides reusable analytical queries for HR reporting.

The separation of **database setup**, **data analysis**, and **reusable
views** keeps the project organized, maintainable and suitable for
GitHub portfolio presentation.

**Prepared by: Rishab Roy**
