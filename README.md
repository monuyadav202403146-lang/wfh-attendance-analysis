# WFH & Employee Attendance Analysis (Excel + SQL)

Is project mein 30 employees ka Jan–Jun 2026 ka attendance data clean kiya gaya hai, aur **Work From Home vs Office** ka comparison kiya gaya hai: attendance, productivity, punctuality aur monthly trends.

## Files

| File | Kya hai |
|---|---|
| `WFH_Attendance_Analysis.xlsx` | Main project: Dashboard, README, Employees, Raw_Attendance, Clean_Attendance, Q1–Q11 analysis sheets, SQL_Queries |
| `online_schema.sql` | MySQL 8.0 script: tables, raw data (30 + 3,798 rows), data cleaning, analysis view `vw_attendance` |
| `online_queries.sql` | 11 analysis queries (Q1–Q11) |

## Excel sheets

1. **Dashboard** - 6 KPI tiles, key insights (formulas se auto-update), 7 charts
2. **README** - sheets ki list, cleaning rules, definitions
3. **Employees** - master table (30 employees, 5 departments)
4. **Raw_Attendance** - raw data jaisa SQL mein insert hua (messy)
5. **Clean_Attendance** - cleaned data + derived columns (`ym`, `weekday`, `hours_worked`, `attended`, `productivity`, `is_late`) formulas ke saath
6. **Q1 – Q11** - har SQL query ka result (COUNTIFS / SUMIFS / AVERAGEIFS / RANK formulas)
7. **SQL_Queries** - original queries reference ke liye

## Analysis (Q1 – Q11)

| Query | Kya nikalta hai |
|---|---|
| Q1 | WFH vs Office overall comparison |
| Q2 | Department-wise WFH vs Office (attendance + productivity) |
| Q3 | Weekday pattern: kis din log WFH karte hain |
| Q4 | Monthly attendance trend (Office vs WFH) |
| Q5 | Monthly productivity + month-over-month change (`LAG`) |
| Q6 | Department productivity trend by month |
| Q7 | Employee productivity ranking (`RANK`, overall + department) |
| Q8 | Employees jo ghar pe 5+ points kam productive hain |
| Q9 | Attendance risk list (95% se kam) |
| Q10 | Punctuality: late arrivals by work mode & department |
| Q11 | Kya zyada WFH ka matlab kam productivity? |

## Data cleaning

Raw data jaan-boojhkar messy rakha gaya hai (saare columns `VARCHAR`), phir SQL mein ye steps hue:

- `emp_id` trim + uppercase (`' E001'`, `'e001'` → `E001`)
- 3 date formats ek standard mein: `yyyy-mm-dd`, `dd/mm/yyyy`, `dd-mm-yyyy`
- Work mode standard: `WFO / In Office / office` → **Office**, `Work From Home / Home / wfh` → **WFH**
- Status standard: `P / PRESENT / present` → **Present**, aur Absent / Leave / Half Day
- 12-hour times (`06:46 PM`) → 24-hour
- Duplicate rows hataye (`emp_id + work_date` pe)
- Present rows ke missing check-in/out ko us employee ke average time se fill kiya
- `tasks_completed` ko `tasks_assigned` pe cap kiya

**Result:** 3,798 raw rows → 3,750 clean rows (48 duplicates hataye, 44 rows mein time imputed, 14 mein tasks capped).

## Metric definitions

- **Attended** = status `Present` ya `Half Day`
- **Attendance %** = attended / (attended + absent)
- **Productivity** = tasks completed / tasks assigned (sirf attended days)
- **Late** = check-in 10:00 ke baad

## SQL run karne ka tarika (DB Fiddle)

1. [dbfiddle.uk](https://dbfiddle.uk) kholo aur **MySQL 8.0** select karo
2. `online_schema.sql` ka poora content **left panel (Schema SQL)** mein paste karo, phir **Build** dabao
3. `online_queries.sql` se **ek time pe ek query** **right panel (Query SQL)** mein paste karo aur **Run** dabao (panel sirf last query ka result dikhata hai)

MySQL Workbench mein bhi chalega: pehle `online_schema.sql` run karo, phir queries ek-ek karke.

## Key findings

- Attendance: Office **96.6%** vs WFH **98.5%**
- Productivity lagbhag same: Office **81.4%** vs WFH **81.1%**
- Late arrivals WFH mein zyada: **36.4%** vs Office **15.2%**
- Mon aur Fri ko WFH share sabse zyada hai (**58.8%** aur **56.3%**)
- 4 employees ghar pe 5+ points kam productive hain: Suresh Pawar, Sneha Iyer, Gaurav Jain, Priya Sharma
- 3 employees ki attendance 95% se kam hai: Rohan Mehta, Priya Sharma, Tanvi Kamat

## Important

- Data **sample** hai (Jan–Jun 2026). Real company data ho to `raw_attendance` ko usi column format mein replace karo.
- Excel mein Q8, Q9 aur Q11 ki employee lists data se tay hui hain. Data badla to numbers update honge, lekin list mein kaun aayega woh nahi badlega.
- Dashboard ke charts ka Y-axis range fixed hai (jaise attendance 90–100). Data bahut badle to axis adjust karna padega.

## Author

**Monu Yadav** - B.Sc. Computer Science, TSDC (Mumbai University)
[LinkedIn](https://www.linkedin.com/in/monu-yadav-34b59825b/) · [GitHub](https://github.com/monu827)
