-- ============================================================
-- HR EMPLOYEE ANALYTICS
-- SQL VIEWS
-- ============================================================

USE HR_Analytics;


-- ============================================================
-- 1. DEPARTMENT ATTRITION VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_department_attrition AS

SELECT
    d.DepartmentID,
    d.DepartmentName,

    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN e.Attrition = 'Yes'
            THEN 1
            ELSE 0
        END
    ) AS AttritionCount,

    SUM(
        CASE
            WHEN e.Attrition = 'No'
            THEN 1
            ELSE 0
        END
    ) AS ActiveEmployees,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN e.Attrition = 'Yes'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS AttritionRate,

    ROUND(
        AVG(e.MonthlyIncome),
        2
    ) AS AverageSalary,

    ROUND(
        AVG(e.YearsAtCompany),
        2
    ) AS AverageTenure

FROM employees e

JOIN departments d
    ON e.DepartmentID = d.DepartmentID

GROUP BY
    d.DepartmentID,
    d.DepartmentName;


-- ============================================================
-- 2. JOB ROLE ATTRITION VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_job_role_attrition AS

SELECT
    j.JobRoleID,
    j.JobRole,

    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN e.Attrition = 'Yes'
            THEN 1
            ELSE 0
        END
    ) AS AttritionCount,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN e.Attrition = 'Yes'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS AttritionRate,

    ROUND(
        AVG(e.MonthlyIncome),
        2
    ) AS AverageSalary,

    ROUND(
        AVG(e.YearsAtCompany),
        2
    ) AS AverageTenure

FROM employees e

JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID

GROUP BY
    j.JobRoleID,
    j.JobRole;


-- ============================================================
-- 3. SALARY BAND ANALYSIS VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_salary_band_analysis AS

SELECT
    SalaryBand,

    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN Attrition = 'Yes'
            THEN 1
            ELSE 0
        END
    ) AS AttritionCount,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Attrition = 'Yes'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS AttritionRate,

    ROUND(
        AVG(MonthlyIncome),
        2
    ) AS AverageSalary

FROM employees

GROUP BY SalaryBand;


-- ============================================================
-- 4. TENURE BAND ANALYSIS VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_tenure_band_analysis AS

SELECT
    TenureBand,

    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN Attrition = 'Yes'
            THEN 1
            ELSE 0
        END
    ) AS AttritionCount,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Attrition = 'Yes'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS AttritionRate

FROM employees

GROUP BY TenureBand;


-- ============================================================
-- 5. OVERTIME ATTRITION VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_overtime_attrition AS

SELECT
    Overtime,

    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN Attrition = 'Yes'
            THEN 1
            ELSE 0
        END
    ) AS AttritionCount,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Attrition = 'Yes'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS AttritionRate,

    ROUND(
        AVG(MonthlyIncome),
        2
    ) AS AverageSalary

FROM employees

GROUP BY Overtime;


-- ============================================================
-- 6. PERFORMANCE ANALYSIS VIEW
-- ============================================================

CREATE OR REPLACE VIEW vw_performance_analysis AS

SELECT
    PerformanceRating,

    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN Attrition = 'Yes'
            THEN 1
            ELSE 0
        END
    ) AS AttritionCount,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Attrition = 'Yes'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS AttritionRate,

    ROUND(
        AVG(MonthlyIncome),
        2
    ) AS AverageSalary,

    ROUND(
        AVG(TrainingHours),
        2
    ) AS AverageTrainingHours

FROM employees

GROUP BY PerformanceRating;


-- ============================================================
-- 7. EMPLOYEE MASTER VIEW
-- Useful for Power BI / reporting
-- ============================================================

CREATE OR REPLACE VIEW vw_employee_master AS

SELECT
    e.EmployeeID,
    e.EmployeeName,
    e.Gender,
    e.Age,

    d.DepartmentID,
    d.DepartmentName,

    j.JobRoleID,
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