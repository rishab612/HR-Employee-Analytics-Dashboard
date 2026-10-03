import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# --------------------------------------------------
# SETTINGS
# --------------------------------------------------

NUM_EMPLOYEES = 1500

np.random.seed(42)
random.seed(42)

# --------------------------------------------------
# MASTER DATA
# --------------------------------------------------

first_names = [
    "Aarav", "Vivaan", "Aditya", "Arjun", "Rohan",
    "Rahul", "Karan", "Akash", "Ananya", "Diya",
    "Priya", "Sneha", "Aisha", "Isha", "Meera",
    "Neha", "Kavya", "Pooja", "Riya", "Shreya",
    "Siddharth", "Vikram", "Nikhil", "Varun", "Manish",
    "Raj", "Amit", "Sanjay", "Ravi", "Abhishek"
]

last_names = [
    "Sharma", "Roy", "Patel", "Das", "Mishra",
    "Gupta", "Singh", "Verma", "Kumar", "Chatterjee",
    "Banerjee", "Mukherjee", "Reddy", "Nair", "Iyer",
    "Mehta", "Joshi", "Kapoor", "Malhotra", "Sen"
]

departments = {
    "IT": [
        "Software Engineer",
        "Data Analyst",
        "System Administrator",
        "IT Support Specialist",
        "DevOps Engineer"
    ],
    "Sales": [
        "Sales Executive",
        "Sales Manager",
        "Business Development Executive",
        "Account Manager"
    ],
    "Human Resources": [
        "HR Executive",
        "HR Manager",
        "Recruiter",
        "HR Analyst"
    ],
    "Finance": [
        "Financial Analyst",
        "Accountant",
        "Finance Manager",
        "Senior Accountant"
    ],
    "Marketing": [
        "Marketing Executive",
        "Digital Marketing Specialist",
        "Marketing Analyst",
        "Brand Manager"
    ],
    "Operations": [
        "Operations Executive",
        "Operations Manager",
        "Process Analyst",
        "Operations Coordinator"
    ],
    "Customer Service": [
        "Customer Service Representative",
        "Customer Support Executive",
        "Customer Success Manager",
        "Support Analyst"
    ],
    "Research & Development": [
        "Research Analyst",
        "Research Engineer",
        "Product Researcher",
        "R&D Manager"
    ]
}

education_levels = [
    "High School",
    "Diploma",
    "Bachelor's",
    "Master's",
    "PhD"
]

marital_statuses = [
    "Single",
    "Married",
    "Divorced"
]

business_travel = [
    "Non-Travel",
    "Travel_Rarely",
    "Travel_Frequently"
]

# --------------------------------------------------
# HELPER FUNCTIONS
# --------------------------------------------------

def random_date(start, end):
    delta = end - start
    return start + timedelta(
        days=random.randint(0, delta.days)
    )


def generate_salary(job_level, department):

    base_salary = {
        1: 28000,
        2: 42000,
        3: 60000,
        4: 85000,
        5: 120000
    }

    salary = base_salary[job_level]

    # Department salary adjustments
    department_multiplier = {
        "IT": 1.12,
        "Finance": 1.08,
        "Sales": 1.00,
        "Human Resources": 0.95,
        "Marketing": 1.02,
        "Operations": 0.96,
        "Customer Service": 0.88,
        "Research & Development": 1.10
    }

    salary *= department_multiplier[department]

    # Add realistic variation
    salary *= np.random.uniform(0.85, 1.15)

    return int(round(salary / 1000) * 1000)


# --------------------------------------------------
# GENERATE EMPLOYEES
# --------------------------------------------------

employees = []

for i in range(1, NUM_EMPLOYEES + 1):

    employee_id = f"EMP{i:04d}"

    first_name = random.choice(first_names)
    last_name = random.choice(last_names)

    employee_name = f"{first_name} {last_name}"

    gender = random.choices(
        ["Male", "Female"],
        weights=[55, 45]
    )[0]

    # Age distribution
    age = int(np.clip(
        np.random.normal(34, 8),
        21,
        58
    ))

    department = random.choice(
        list(departments.keys())
    )

    job_role = random.choice(
        departments[department]
    )

    # --------------------------------------------------
    # JOB LEVEL
    # --------------------------------------------------

    if age <= 25:
        job_level = random.choices(
            [1, 2],
            weights=[75, 25]
        )[0]

    elif age <= 32:
        job_level = random.choices(
            [1, 2, 3],
            weights=[20, 60, 20]
        )[0]

    elif age <= 40:
        job_level = random.choices(
            [2, 3, 4],
            weights=[20, 60, 20]
        )[0]

    elif age <= 50:
        job_level = random.choices(
            [3, 4, 5],
            weights=[25, 55, 20]
        )[0]

    else:
        job_level = random.choices(
            [4, 5],
            weights=[60, 40]
        )[0]

    # --------------------------------------------------
    # EXPERIENCE
    # --------------------------------------------------

    max_experience = age - 20

    total_working_years = int(
        np.clip(
            np.random.normal(
                max_experience * 0.65,
                4
            ),
            0,
            max_experience
        )
    )

    # --------------------------------------------------
    # COMPANY TENURE
    # --------------------------------------------------

    years_at_company = int(
        np.clip(
            np.random.normal(
                min(total_working_years, 6),
                2.5
            ),
            0,
            min(total_working_years, 15)
        )
    )

    # --------------------------------------------------
    # ROLE TENURE
    # --------------------------------------------------

    years_in_current_role = int(
        np.clip(
            np.random.normal(
                min(years_at_company, 4),
                1.5
            ),
            0,
            years_at_company
        )
    )

    # --------------------------------------------------
    # PROMOTION
    # --------------------------------------------------

    years_since_promotion = int(
        np.clip(
            np.random.normal(2.5, 2),
            0,
            max(years_at_company, 0)
        )
    )

    # --------------------------------------------------
    # EDUCATION
    # --------------------------------------------------

    education = random.choices(
        education_levels,
        weights=[5, 10, 55, 27, 3]
    )[0]

    # --------------------------------------------------
    # SALARY
    # --------------------------------------------------

    monthly_income = generate_salary(
        job_level,
        department
    )

    # --------------------------------------------------
    # JOB SATISFACTION
    # --------------------------------------------------

    job_satisfaction = random.choices(
        [1, 2, 3, 4],
        weights=[8, 17, 45, 30]
    )[0]

    environment_satisfaction = random.choices(
        [1, 2, 3, 4],
        weights=[8, 18, 44, 30]
    )[0]

    work_life_balance = random.choices(
        [1, 2, 3, 4],
        weights=[7, 18, 48, 27]
    )[0]

    # --------------------------------------------------
    # PERFORMANCE
    # --------------------------------------------------

    performance_rating = random.choices(
        [1, 2, 3, 4, 5],
        weights=[2, 12, 55, 27, 4]
    )[0]

    # --------------------------------------------------
    # TRAINING
    # --------------------------------------------------

    training_hours = int(
        np.clip(
            np.random.normal(35, 15),
            5,
            100
        )
    )

    # --------------------------------------------------
    # OVERTIME
    # --------------------------------------------------

    overtime = random.choices(
        ["Yes", "No"],
        weights=[28, 72]
    )[0]

    # --------------------------------------------------
    # BUSINESS TRAVEL
    # --------------------------------------------------

    travel = random.choices(
        business_travel,
        weights=[15, 70, 15]
    )[0]

    # --------------------------------------------------
    # MARITAL STATUS
    # --------------------------------------------------

    marital_status = random.choices(
        marital_statuses,
        weights=[45, 48, 7]
    )[0]

    # --------------------------------------------------
    # DISTANCE FROM HOME
    # --------------------------------------------------

    distance_from_home = int(
        np.clip(
            np.random.gamma(2.2, 5),
            1,
            40
        )
    )

    # --------------------------------------------------
    # COMPANIES WORKED
    # --------------------------------------------------

    num_companies_worked = int(
        np.clip(
            np.random.poisson(2),
            0,
            10
        )
    )

    # --------------------------------------------------
    # HIRE DATE
    # --------------------------------------------------

    today = datetime(2026, 10, 2)

    earliest_hire = today - timedelta(days=15 * 365)
    latest_hire = today - timedelta(days=30)

    hire_date = random_date(
        earliest_hire,
        latest_hire
    )

    # --------------------------------------------------
    # ATTRITION PROBABILITY
    # --------------------------------------------------

    attrition_score = 0.07

    if overtime == "Yes":
        attrition_score += 0.08

    if job_satisfaction <= 2:
        attrition_score += 0.07

    if work_life_balance <= 2:
        attrition_score += 0.05

    if years_at_company <= 2:
        attrition_score += 0.07

    if monthly_income < 35000:
        attrition_score += 0.05

    if distance_from_home > 20:
        attrition_score += 0.04

    if performance_rating >= 4:
        attrition_score -= 0.02

    if age > 45:
        attrition_score -= 0.02

    attrition_score = np.clip(
        attrition_score,
        0.02,
        0.45
    )

    attrition = (
        "Yes"
        if random.random() < attrition_score
        else "No"
    )

    # --------------------------------------------------
    # EXIT DATE
    # --------------------------------------------------

    exit_date = None

    if attrition == "Yes":

        max_exit_date = today

        min_exit_date = hire_date + timedelta(days=180)

        if min_exit_date < max_exit_date:
            exit_date = random_date(
                min_exit_date,
                max_exit_date
            )

    # --------------------------------------------------
    # APPEND
    # --------------------------------------------------

    employees.append({

        "EmployeeID": employee_id,
        "EmployeeName": employee_name,
        "Gender": gender,
        "Age": age,
        "Department": department,
        "JobRole": job_role,
        "Education": education,
        "JobLevel": job_level,
        "MonthlyIncome": monthly_income,
        "TotalWorkingYears": total_working_years,
        "YearsAtCompany": years_at_company,
        "YearsInCurrentRole": years_in_current_role,
        "YearsSincePromotion": years_since_promotion,
        "JobSatisfaction": job_satisfaction,
        "EnvironmentSatisfaction": environment_satisfaction,
        "WorkLifeBalance": work_life_balance,
        "PerformanceRating": performance_rating,
        "TrainingHours": training_hours,
        "Overtime": overtime,
        "BusinessTravel": travel,
        "MaritalStatus": marital_status,
        "DistanceFromHome": distance_from_home,
        "NumCompaniesWorked": num_companies_worked,
        "HireDate": hire_date.date(),
        "ExitDate": exit_date.date() if exit_date else None,
        "Attrition": attrition
    })


# --------------------------------------------------
# CREATE DATAFRAME
# --------------------------------------------------

df = pd.DataFrame(employees)

# --------------------------------------------------
# SAVE FILES
# --------------------------------------------------

df.to_csv(
    "HR_Employee_Data.csv",
    index=False
)

df.to_excel(
    "HR_Employee_Data.xlsx",
    index=False,
    sheet_name="Employee Data"
)

# --------------------------------------------------
# SUMMARY
# --------------------------------------------------

print("\n======================================")
print("HR DATASET CREATED")
print("======================================")

print(f"Total Employees: {len(df):,}")

print(
    f"Attrition Employees: "
    f"{(df['Attrition'] == 'Yes').sum():,}"
)

print(
    f"Attrition Rate: "
    f"{(df['Attrition'] == 'Yes').mean() * 100:.2f}%"
)

print(
    f"Average Salary: "
    f"₹{df['MonthlyIncome'].mean():,.0f}"
)

print(
    f"Average Age: "
    f"{df['Age'].mean():.1f}"
)

print("\nDepartment Distribution:")
print(
    df["Department"].value_counts()
)

print("\nAttrition by Department:")
print(
    pd.crosstab(
        df["Department"],
        df["Attrition"],
        normalize="index"
    )["Yes"].mul(100).round(2)
)

print("\nFiles created:")
print("HR_Employee_Data.csv")
print("HR_Employee_Data.xlsx")