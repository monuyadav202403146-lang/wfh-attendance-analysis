# WFH & Employee Attendance Analysis (Excel + SQL)

This project analyzes attendance data for **30 employees from January to June 2026**. The data was cleaned and analyzed to compare **Work From Home (WFH) vs Work From Office (WFO)** across attendance, productivity, punctuality, and monthly trends.

## Files

| File | Description |
|---|---|
| `WFH_Attendance_Analysis.xlsx` | Main project workbook containing Dashboard, README, Employees, Raw_Attendance, Clean_Attendance, Q1–Q11 analysis sheets, and SQL_Queries. |
| `online_schema.sql` | MySQL 8.0 script containing table creation, raw data (30 employees + 3,798 attendance rows), data cleaning, and the analysis view `vw_attendance`. |
| `online_queries.sql` | Contains 11 SQL analysis queries (Q1–Q11). |

## Excel Workbook Sheets

1. **Dashboard** – Includes 6 KPI tiles, key insights (automatically updated using formulas), and 7 charts.
2. **README** – Contains the sheet descriptions, data cleaning rules, and metric definitions.
3. **Employees** – Employee master table containing 30 employees across 5 departments.
4. **Raw_Attendance** – Original messy attendance data, matching the data inserted into SQL.
5. **Clean_Attendance** – Cleaned attendance data with derived columns such as `ym`, `weekday`, `hours_worked`, `attended`, `productivity`, and `is_late`, calculated using formulas.
6. **Q1–Q11** – Individual analysis results corresponding to each SQL query, using Excel functions such as COUNTIFS, SUMIFS, AVERAGEIFS, and RANK.
7. **SQL_Queries** – Reference sheet containing the original SQL queries.

## SQL Analysis (Q1–Q11)

| Query | Analysis |
|---|---|
| Q1 | Overall comparison of WFH vs Office attendance and productivity. |
| Q2 | Department-wise WFH vs Office comparison (attendance and productivity). |
| Q3 | Weekday patterns showing which days employees prefer working from home. |
| Q4 | Monthly attendance trends (Office vs WFH). |
| Q5 | Monthly productivity trends and month-over-month changes using `LAG()`. |
| Q6 | Department-wise monthly productivity trends. |
| Q7 | Employee productivity rankings (overall and department-wise) using `RANK()`. |
| Q8 | Identifies employees whose productivity is 5+ percentage points lower when working from home. |
| Q9 | Identifies employees with attendance below 95%. |
| Q10 | Punctuality analysis: late arrivals by work mode and department. |
| Q11 | Analyzes whether higher WFH participation is associated with lower productivity. |

## Data Cleaning Process

The raw dataset was intentionally designed with inconsistencies to simulate real-world attendance data. All columns were initially stored as `VARCHAR` in SQL.

The following data cleaning operations were performed:

- **Employee ID Standardization:** Trimmed whitespace and converted employee IDs to uppercase (e.g., `' E001'`, `'e001'` → `E001`).
- **Date Standardization:** Converted three different date formats into a consistent `YYYY-MM-DD` format.
- **Work Mode Standardization:** Converted variations such as `WFO`, `In Office`, and `office` into **Office**, and `Work From Home`, `Home`, and `wfh` into **WFH**.
- **Attendance Status Standardization:** Standardized `P`, `PRESENT`, and `present` into **Present**, along with Absent, Leave, and Half Day.
- **Time Conversion:** Converted 12-hour time formats (e.g., `06:46 PM`) into 24-hour format.
- **Duplicate Removal:** Removed duplicate records based on `emp_id + work_date`.
- **Missing Time Handling:** Filled missing check-in and check-out times for present records using the respective employee's average time.
- **Task Validation:** Capped `tasks_completed` at `tasks_assigned` to prevent invalid productivity values.

**Data Cleaning Results:**

| Metric | Result |
|---|---:|
| Raw Attendance Records | 3,798 |
| Clean Attendance Records | 3,750 |
| Duplicate Records Removed | 48 |
| Records with Imputed Time Values | 44 |
| Records with Capped Task Values | 14 |

## Metric Definitions

- **Attended:** Records with status `Present` or `Half Day`.
- **Attendance %:** Attended days / (Attended days + Absent days).
- **Productivity:** Tasks completed / Tasks assigned (calculated only for attended days).
- **Late Arrival:** Check-in time after 10:00 AM.

## How to Run the SQL Project (DB Fiddle)

link:https://drive.google.com/file/d/1znpPDDFMptLPBrKAKrRSoQHD2UjWoMsI/view?usp=drive_link

**Note:** DB Fiddle displays the result of the query being executed. Run each query individually to view all 11 analysis results.

The project can also be executed using **MySQL Workbench**. First, run `online_schema.sql`, followed by the analysis queries one at a time.

## Key Findings

- **Attendance Rate:** Office – **96.6%** vs WFH – **98.5%**.
- **Productivity:** Office – **81.4%** vs WFH – **81.1%**, indicating nearly identical productivity levels.
- **Late Arrivals:** WFH – **36.4%** vs Office – **15.2%**.
- **WFH Preferences:** Monday (58.8%) and Friday (56.3%) have the highest WFH shares.
- **Productivity Differences:** 4 employees have productivity at least 5 percentage points lower when working from home: Suresh Pawar, Sneha Iyer, Gaurav Jain, and Priya Sharma.
- **Attendance Risks:** 3 employees have attendance rates below 95%: Rohan Mehta, Priya Sharma, and Tanvi Kamat.

## Important Notes

- The dataset is **sample data** covering January–June 2026. For real-world use, replace the `raw_attendance` table data with actual company attendance records using the same column structure.
- The employee lists in Excel sheets Q8, Q9, and Q11 were manually determined from the current dataset. Although numerical results update when the data changes, the employee lists will not automatically update.
- Dashboard chart Y-axis ranges are fixed (for example, attendance charts use a 90–100 range). If the dataset changes significantly, the chart axis ranges may need manual adjustment.

## Author

**Monu Yadav**  
B.Sc. Computer Science | TSDC, Mumbai University

- **LinkedIn:** https://www.linkedin.com/in/monu-yadav-34b59825b/
- **GitHub:** https://github.com/monuyadav202403146-lang

---
# WFH & Employee Attendance Analysis

## 📊 Power BI / Excel Dashboard
![Dashboard](screenshots/dashboard.png)

## 📈 WFH vs Office Analysis
![WFH Analysis](screenshots/wfh-analysis.png)

## 📅 Monthly Trends
![Monthly Trends](screenshots/monthly-trends.png)

## 👥 Employee Analysis
![Employee Analysis](screenshots/employee-analysis.png)

## 🛠️ Tools & Technologies
- Microsoft Excel
- MySQL 8.0
- SQL
- Data Cleaning
- Data Visualization

