import pandas as pd
import mysql.connector

# ==========================================================
# EXCEL FILE
# ==========================================================

excel_file = r"C:\Users\risha\OneDrive\Desktop\Data Analysit Project\Dataset\HR_Employee_Analytics.xlsx"

# ==========================================================
# READ EXCEL
# ==========================================================

df = pd.read_excel(
    excel_file,
    sheet_name="Employee Data"
)

print("Excel data loaded.")
print("Rows:", len(df))

print("\nOriginal Excel columns:")
print(df.columns.tolist())


# ==========================================================
# CREATE AGE GROUP
# ==========================================================

def get_age_group(age):

    if age <= 25:
        return "18-25"

    elif age <= 35:
        return "26-35"

    elif age <= 45:
        return "36-45"

    elif age <= 55:
        return "46-55"

    else:
        return "56+"


df["AgeGroup"] = df["Age"].apply(get_age_group)


# ==========================================================
# CREATE SALARY BAND
# ==========================================================

def get_salary_band(salary):

    if salary < 30000:
        return "< ₹30K"

    elif salary < 50000:
        return "₹30K-₹50K"

    elif salary < 75000:
        return "₹50K-₹75K"

    elif salary < 100000:
        return "₹75K-₹100K"

    else:
        return "> ₹100K"


df["SalaryBand"] = df["MonthlyIncome"].apply(
    get_salary_band
)


# ==========================================================
# CREATE TENURE BAND
# ==========================================================

def get_tenure_band(years):

    if years <= 1:
        return "<1 Year"

    elif years <= 3:
        return "1-3 Years"

    elif years <= 6:
        return "4-6 Years"

    elif years <= 10:
        return "7-10 Years"

    else:
        return "10+ Years"


df["TenureBand"] = df["YearsAtCompany"].apply(
    get_tenure_band
)


# ==========================================================
# VERIFY NEW COLUMNS
# ==========================================================

print("\nNew columns created:")

print("AgeGroup:", "AgeGroup" in df.columns)
print("SalaryBand:", "SalaryBand" in df.columns)
print("TenureBand:", "TenureBand" in df.columns)

print("\nFinal columns:")
print(df.columns.tolist())


# ==========================================================
# CONNECT TO MYSQL
# ==========================================================

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="HR_Analytics"
)

cursor = connection.cursor()

print("\nConnected to MySQL.")


# ==========================================================
# CLEAR STAGING TABLE
# ==========================================================

cursor.execute(
    "TRUNCATE TABLE employees_staging"
)

print("employees_staging table cleared.")


# ==========================================================
# HANDLE NULL VALUES
# ==========================================================

df = df.where(
    pd.notnull(df),
    None
)


# ==========================================================
# CONVERT DATES
# ==========================================================

df["HireDate"] = pd.to_datetime(
    df["HireDate"],
    errors="coerce"
)

df["ExitDate"] = pd.to_datetime(
    df["ExitDate"],
    errors="coerce"
)


# ==========================================================
# SQL INSERT
# ==========================================================

sql = """
INSERT INTO employees_staging (

    EmployeeID,
    EmployeeName,
    Gender,
    Age,
    Department,
    JobRole,
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

VALUES (

    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
    %s, %s, %s, %s, %s, %s, %s, %s, %s

)
"""


# ==========================================================
# INSERT 1,500 RECORDS
# ==========================================================

for _, row in df.iterrows():

    values = (

        row["EmployeeID"],
        row["EmployeeName"],
        row["Gender"],
        row["Age"],
        row["Department"],
        row["JobRole"],
        row["Education"],
        row["JobLevel"],
        row["MonthlyIncome"],
        row["TotalWorkingYears"],
        row["YearsAtCompany"],
        row["YearsInCurrentRole"],
        row["YearsSincePromotion"],
        row["JobSatisfaction"],
        row["EnvironmentSatisfaction"],
        row["WorkLifeBalance"],
        row["PerformanceRating"],
        row["TrainingHours"],
        row["Overtime"],
        row["BusinessTravel"],
        row["MaritalStatus"],
        row["DistanceFromHome"],
        row["NumCompaniesWorked"],

        row["HireDate"].date()
        if pd.notna(row["HireDate"])
        else None,

        row["ExitDate"].date()
        if pd.notna(row["ExitDate"])
        else None,

        row["Attrition"],
        row["AgeGroup"],
        row["SalaryBand"],
        row["TenureBand"]
    )

    cursor.execute(sql, values)


# ==========================================================
# SAVE TO MYSQL
# ==========================================================

connection.commit()


# ==========================================================
# VERIFY
# ==========================================================

cursor.execute(
    "SELECT COUNT(*) FROM employees_staging"
)

count = cursor.fetchone()[0]


print("\n==========================================")
print("IMPORT COMPLETED SUCCESSFULLY")
print("==========================================")

print("Excel records:", len(df))
print("MySQL records:", count)


# ==========================================================
# CLOSE
# ==========================================================

cursor.close()
connection.close()

print("\nMySQL connection closed.")