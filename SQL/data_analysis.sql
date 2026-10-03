-- ============================================================
-- HR EMPLOYEE ANALYTICS
-- DATA ANALYSIS QUERIES
-- ============================================================

USE HR_Analytics;


-- ============================================================
-- 1. TOTAL EMPLOYEES
-- ============================================================

SELECT
    COUNT(*) AS TotalEmployees
FROM employees;


-- ============================================================
-- 2. ACTIVE EMPLOYEES
-- ============================================================

SELECT
    COUNT(*) AS ActiveEmployees
FROM employees
WHERE Attrition = 'No';


-- ============================================================
-- 3. ATTRITION COUNT
-- ============================================================

SELECT
    COUNT(*) AS AttritionCount
FROM employees
WHERE Attrition = 'Yes';


-- ============================================================
-- 4. ATTRITION RATE
-- ============================================================

SELECT
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Attrition = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS AttritionRate
FROM employees;


-- ============================================================
-- 5. ATTRITION DISTRIBUTION
-- ============================================================

SELECT
    Attrition,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY Attrition
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 6. EMPLOYEES BY DEPARTMENT
-- ============================================================

SELECT
    d.DepartmentName,
    COUNT(*) AS EmployeeCount
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 7. ATTRITION BY DEPARTMENT
-- ============================================================

SELECT
    d.DepartmentName,

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
    ) AS AttritionRate

FROM employees e

JOIN departments d
    ON e.DepartmentID = d.DepartmentID

GROUP BY d.DepartmentName

ORDER BY AttritionRate DESC;


-- ============================================================
-- 8. EMPLOYEES BY JOB ROLE
-- ============================================================

SELECT
    j.JobRole,
    COUNT(*) AS EmployeeCount
FROM employees e
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID
GROUP BY j.JobRole
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 9. ATTRITION BY JOB ROLE
-- ============================================================

SELECT
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
    ) AS AttritionRate

FROM employees e

JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID

GROUP BY j.JobRole

ORDER BY AttritionRate DESC;


-- ============================================================
-- 10. AVERAGE SALARY
-- ============================================================

SELECT
    ROUND(AVG(MonthlyIncome), 2) AS AverageSalary
FROM employees;


-- ============================================================
-- 11. SALARY BY DEPARTMENT
-- ============================================================

SELECT
    d.DepartmentName,
    ROUND(AVG(e.MonthlyIncome), 2) AS AverageSalary,
    MIN(e.MonthlyIncome) AS MinimumSalary,
    MAX(e.MonthlyIncome) AS MaximumSalary
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;


-- ============================================================
-- 12. SALARY BY JOB ROLE
-- ============================================================

SELECT
    j.JobRole,
    ROUND(AVG(e.MonthlyIncome), 2) AS AverageSalary
FROM employees e
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID
GROUP BY j.JobRole
ORDER BY AverageSalary DESC;


-- ============================================================
-- 13. SALARY BAND DISTRIBUTION
-- ============================================================

SELECT
    SalaryBand,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY SalaryBand
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 14. ATTRITION BY SALARY BAND
-- ============================================================

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
    ) AS AttritionRate

FROM employees

GROUP BY SalaryBand

ORDER BY AttritionRate DESC;


-- ============================================================
-- 15. AGE GROUP ANALYSIS
-- ============================================================

SELECT
    AgeGroup,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY AgeGroup
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 16. ATTRITION BY AGE GROUP
-- ============================================================

SELECT
    AgeGroup,

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

GROUP BY AgeGroup

ORDER BY AttritionRate DESC;


-- ============================================================
-- 17. TENURE ANALYSIS
-- ============================================================

SELECT
    TenureBand,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY TenureBand
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 18. ATTRITION BY TENURE
-- ============================================================

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

GROUP BY TenureBand

ORDER BY AttritionRate DESC;


-- ============================================================
-- 19. OVERTIME ANALYSIS
-- ============================================================

SELECT
    Overtime,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY Overtime
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 20. OVERTIME VS ATTRITION
-- ============================================================

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
    ) AS AttritionRate

FROM employees

GROUP BY Overtime

ORDER BY AttritionRate DESC;


-- ============================================================
-- 21. GENDER ANALYSIS
-- ============================================================

SELECT
    Gender,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY Gender
ORDER BY EmployeeCount DESC;


-- ============================================================
-- 22. ATTRITION BY GENDER
-- ============================================================

SELECT
    Gender,

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

GROUP BY Gender

ORDER BY AttritionRate DESC;


-- ============================================================
-- 23. PERFORMANCE ANALYSIS
-- ============================================================

SELECT
    PerformanceRating,
    COUNT(*) AS EmployeeCount
FROM employees
GROUP BY PerformanceRating
ORDER BY PerformanceRating;


-- ============================================================
-- 24. PERFORMANCE VS ATTRITION
-- ============================================================

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
    ) AS AttritionRate

FROM employees

GROUP BY PerformanceRating

ORDER BY PerformanceRating;


-- ============================================================
-- 25. JOB SATISFACTION ANALYSIS
-- ============================================================

SELECT
    JobSatisfaction,

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

GROUP BY JobSatisfaction

ORDER BY JobSatisfaction;


-- ============================================================
-- 26. WORK-LIFE BALANCE ANALYSIS
-- ============================================================

SELECT
    WorkLifeBalance,

    COUNT(*) AS TotalEmployees,

    ROUND(
        AVG(MonthlyIncome),
        2
    ) AS AverageSalary

FROM employees

GROUP BY WorkLifeBalance

ORDER BY WorkLifeBalance;


-- ============================================================
-- 27. TRAINING HOURS ANALYSIS
-- ============================================================

SELECT
    ROUND(AVG(TrainingHours), 2) AS AverageTrainingHours
FROM employees;


-- ============================================================
-- 28. AVERAGE AGE
-- ============================================================

SELECT
    ROUND(AVG(Age), 2) AS AverageAge
FROM employees;


-- ============================================================
-- 29. AVERAGE TENURE
-- ============================================================

SELECT
    ROUND(AVG(YearsAtCompany), 2) AS AverageTenure
FROM employees;


-- ============================================================
-- 30. HIGH PERFORMERS
-- ============================================================

SELECT
    COUNT(*) AS HighPerformers
FROM employees
WHERE PerformanceRating = 4;


-- ============================================================
-- 31. EMPLOYEE DETAILS WITH DIMENSIONS
-- ============================================================

SELECT
    e.EmployeeID,
    e.EmployeeName,
    e.Gender,
    e.Age,
    d.DepartmentName,
    j.JobRole,
    e.JobLevel,
    e.MonthlyIncome,
    e.YearsAtCompany,
    e.PerformanceRating,
    e.JobSatisfaction,
    e.Overtime,
    e.Attrition
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
JOIN job_roles j
    ON e.JobRoleID = j.JobRoleID
ORDER BY e.EmployeeID;