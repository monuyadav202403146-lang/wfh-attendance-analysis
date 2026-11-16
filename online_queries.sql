-- DB FIDDLE: paste ONE query at a time in the RIGHT panel (Query SQL), then click Run.
-- (The panel shows the result of the last query only.)

-- Q1. WFH vs Office: overall comparison
SELECT
    work_mode,
    COUNT(*)                                                       AS total_records,
    SUM(attended)                                                  AS attended_days,
    SUM(status = 'Absent')                                         AS absent_days,
    SUM(status = 'Leave')                                          AS leave_days,
    ROUND(100 * SUM(attended) / (SUM(attended) + SUM(status = 'Absent')), 1) AS attendance_pct,
    ROUND(AVG(hours_worked), 2)                                    AS avg_hours,
    ROUND(100 * AVG(productivity), 1)                              AS avg_productivity_pct,
    SUM(is_late)                                                   AS late_arrivals,
    ROUND(100 * SUM(is_late) / SUM(attended), 1)                   AS late_pct
FROM vw_attendance
GROUP BY work_mode;

-- Q2. Department-wise WFH vs Office (attendance & productivity side by side)
SELECT
    department,
    ROUND(100 * SUM(CASE WHEN work_mode='Office' THEN attended END) /
          (SUM(CASE WHEN work_mode='Office' THEN attended END) + SUM(work_mode='Office' AND status='Absent')), 1) AS office_att_pct,
    ROUND(100 * SUM(CASE WHEN work_mode='WFH' THEN attended END) /
          (SUM(CASE WHEN work_mode='WFH' THEN attended END) + SUM(work_mode='WFH' AND status='Absent')), 1)       AS wfh_att_pct,
    ROUND(100 * AVG(CASE WHEN work_mode='Office' THEN productivity END), 1) AS office_prod_pct,
    ROUND(100 * AVG(CASE WHEN work_mode='WFH'    THEN productivity END), 1) AS wfh_prod_pct,
    ROUND(100 * (AVG(CASE WHEN work_mode='WFH' THEN productivity END) -
                 AVG(CASE WHEN work_mode='Office' THEN productivity END)), 1) AS prod_diff_pts
FROM vw_attendance
GROUP BY department
ORDER BY prod_diff_pts DESC;

-- Q3. Weekday pattern: which days do people work from home?
SELECT
    weekday,
    SUM(CASE WHEN work_mode='Office' THEN attended END) AS office_attended,
    SUM(CASE WHEN work_mode='WFH'    THEN attended END) AS wfh_attended,
    ROUND(100 * SUM(CASE WHEN work_mode='WFH' THEN attended END) / SUM(attended), 1) AS wfh_share_pct
FROM vw_attendance
GROUP BY weekday
ORDER BY FIELD(weekday, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri');

-- Q4. Monthly attendance trend (Office vs WFH)
SELECT
    ym,
    SUM(CASE WHEN work_mode='Office' THEN attended END) AS office_attended,
    SUM(CASE WHEN work_mode='WFH'    THEN attended END) AS wfh_attended,
    ROUND(100 * SUM(CASE WHEN work_mode='Office' THEN attended END) /
          (SUM(CASE WHEN work_mode='Office' THEN attended END) + SUM(work_mode='Office' AND status='Absent')), 1) AS office_att_pct,
    ROUND(100 * SUM(CASE WHEN work_mode='WFH' THEN attended END) /
          (SUM(CASE WHEN work_mode='WFH' THEN attended END) + SUM(work_mode='WFH' AND status='Absent')), 1)       AS wfh_att_pct,
    ROUND(100 * SUM(attended) / (SUM(attended) + SUM(status='Absent')), 1) AS overall_att_pct,
    ROUND(100 * SUM(CASE WHEN work_mode='WFH' THEN attended END) / SUM(attended), 1) AS wfh_share_pct
FROM vw_attendance
GROUP BY ym
ORDER BY ym;

-- Q5. Monthly productivity + month-over-month change (window function LAG)
WITH monthly AS (
    SELECT ym,
           AVG(productivity) AS prod_all,
           AVG(CASE WHEN work_mode='Office' THEN productivity END) AS prod_office,
           AVG(CASE WHEN work_mode='WFH'    THEN productivity END) AS prod_wfh
    FROM vw_attendance
    GROUP BY ym
)
SELECT
    ym,
    ROUND(100 * prod_office, 1) AS office_prod_pct,
    ROUND(100 * prod_wfh, 1)    AS wfh_prod_pct,
    ROUND(100 * prod_all, 1)    AS overall_prod_pct,
    ROUND(100 * (prod_all - LAG(prod_all) OVER (ORDER BY ym)), 2) AS mom_change_pts
FROM monthly
ORDER BY ym;

-- Q6. Department productivity trend by month
SELECT
    department,
    ROUND(100 * AVG(CASE WHEN ym='2026-01' THEN productivity END), 1) AS jan,
    ROUND(100 * AVG(CASE WHEN ym='2026-02' THEN productivity END), 1) AS feb,
    ROUND(100 * AVG(CASE WHEN ym='2026-03' THEN productivity END), 1) AS mar,
    ROUND(100 * AVG(CASE WHEN ym='2026-04' THEN productivity END), 1) AS apr,
    ROUND(100 * AVG(CASE WHEN ym='2026-05' THEN productivity END), 1) AS may,
    ROUND(100 * AVG(CASE WHEN ym='2026-06' THEN productivity END), 1) AS jun
FROM vw_attendance
GROUP BY department;

-- Q7. Employee productivity ranking (overall + within department)
SELECT
    emp_id,
    employee_name,
    department,
    SUM(attended)                                     AS attended_days,
    ROUND(100 * SUM(attended) / (SUM(attended) + SUM(status='Absent')), 1) AS attendance_pct,
    ROUND(100 * AVG(CASE WHEN work_mode='Office' THEN productivity END), 1) AS office_prod_pct,
    ROUND(100 * AVG(CASE WHEN work_mode='WFH'    THEN productivity END), 1) AS wfh_prod_pct,
    ROUND(100 * AVG(productivity), 1)                 AS overall_prod_pct,
    RANK() OVER (ORDER BY AVG(productivity) DESC)     AS overall_rank,
    RANK() OVER (PARTITION BY department ORDER BY AVG(productivity) DESC) AS dept_rank
FROM vw_attendance
GROUP BY emp_id, employee_name, department
ORDER BY overall_rank;

-- Q8. Employees who are noticeably less productive at home (drop of 5+ pts)
SELECT * FROM (
    SELECT
        employee_name, department,
        ROUND(100 * AVG(CASE WHEN work_mode='Office' THEN productivity END), 1) AS office_prod_pct,
        ROUND(100 * AVG(CASE WHEN work_mode='WFH'    THEN productivity END), 1) AS wfh_prod_pct,
        ROUND(100 * (AVG(CASE WHEN work_mode='WFH' THEN productivity END) -
                     AVG(CASE WHEN work_mode='Office' THEN productivity END)), 1) AS wfh_minus_office_pts
    FROM vw_attendance
    GROUP BY employee_name, department
) t
WHERE wfh_minus_office_pts <= -5
ORDER BY wfh_minus_office_pts;

-- Q9. Attendance risk list: employees below 95% attendance
SELECT
    employee_name, department,
    SUM(attended) AS attended_days,
    SUM(status = 'Absent') AS absent_days,
    ROUND(100 * SUM(attended) / (SUM(attended) + SUM(status='Absent')), 1) AS attendance_pct
FROM vw_attendance
GROUP BY employee_name, department
HAVING attendance_pct < 95
ORDER BY attendance_pct;

-- Q10. Punctuality: late arrivals by work mode and department
SELECT
    department,
    ROUND(100 * SUM(CASE WHEN work_mode='Office' THEN is_late END) / SUM(CASE WHEN work_mode='Office' THEN attended END), 1) AS office_late_pct,
    ROUND(100 * SUM(CASE WHEN work_mode='WFH'    THEN is_late END) / SUM(CASE WHEN work_mode='WFH'    THEN attended END), 1) AS wfh_late_pct
FROM vw_attendance
GROUP BY department;

-- Q11. Does more WFH mean lower productivity? WFH-days share per employee vs productivity
SELECT
    employee_name, department,
    ROUND(100 * SUM(CASE WHEN work_mode='WFH' THEN attended END) / SUM(attended), 1) AS wfh_share_pct,
    ROUND(100 * AVG(productivity), 1) AS overall_prod_pct
FROM vw_attendance
GROUP BY employee_name, department
ORDER BY wfh_share_pct DESC
LIMIT 7;
