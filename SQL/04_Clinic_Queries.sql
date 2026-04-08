-- ============================================================
-- Clinic Management System – Query Solutions (Part B)
-- ============================================================
-- Replace @target_year  with the desired year  (e.g. 2021)
-- Replace @target_month with the desired month (e.g. 10 for October)
-- All queries use 2021 / October as the demo value.
-- ============================================================

-- ------------------------------------------------------------
-- Q1. Revenue from each sales channel in a given year
-- ------------------------------------------------------------

SELECT
    sales_channel,
    ROUND(SUM(amount), 2) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021          -- change year as needed
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- Q2. Top 10 most valuable customers in a given year
--     (ranked by total amount they spent)
-- ------------------------------------------------------------

SELECT
    cs.uid,
    c.name             AS customer_name,
    c.mobile,
    ROUND(SUM(cs.amount), 2) AS total_spent
FROM clinic_sales cs
INNER JOIN customer c ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = 2021       -- change year as needed
GROUP BY cs.uid, c.name, c.mobile
ORDER BY total_spent DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q3. Month-wise revenue, expense, profit and
--     profitability status for a given year
-- ------------------------------------------------------------

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime)        AS sale_month,
        ROUND(SUM(amount), 2)  AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime)        AS exp_month,
        ROUND(SUM(amount), 2)  AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT
    COALESCE(r.sale_month, e.exp_month)            AS month_no,
    COALESCE(r.total_revenue, 0)                   AS revenue,
    COALESCE(e.total_expense, 0)                   AS expense,
    COALESCE(r.total_revenue, 0)
        - COALESCE(e.total_expense, 0)             AS profit,
    CASE
        WHEN COALESCE(r.total_revenue, 0)
           - COALESCE(e.total_expense, 0) > 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END                                            AS status
FROM monthly_revenue  r
FULL OUTER JOIN monthly_expense e
    ON r.sale_month = e.exp_month    -- use LEFT JOIN if your DB lacks FULL OUTER
ORDER BY month_no;

-- NOTE: MySQL does not support FULL OUTER JOIN directly.
-- Use this equivalent for MySQL:
/*
SELECT
    m.month_no,
    COALESCE(r.total_revenue, 0)                        AS revenue,
    COALESCE(e.total_expense, 0)                        AS expense,
    COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0) AS profit,
    CASE
        WHEN COALESCE(r.total_revenue, 0) - COALESCE(e.total_expense, 0) > 0
        THEN 'Profitable' ELSE 'Not-Profitable'
    END AS status
FROM (
    SELECT MONTH(datetime) AS month_no FROM clinic_sales WHERE YEAR(datetime) = 2021
    UNION
    SELECT MONTH(datetime)              FROM expenses    WHERE YEAR(datetime) = 2021
) m
LEFT JOIN (
    SELECT MONTH(datetime) AS sale_month, SUM(amount) AS total_revenue
    FROM clinic_sales WHERE YEAR(datetime) = 2021 GROUP BY MONTH(datetime)
) r ON r.sale_month = m.month_no
LEFT JOIN (
    SELECT MONTH(datetime) AS exp_month, SUM(amount) AS total_expense
    FROM expenses WHERE YEAR(datetime) = 2021 GROUP BY MONTH(datetime)
) e ON e.exp_month = m.month_no
ORDER BY m.month_no;
*/

-- ------------------------------------------------------------
-- Q4. For each city, find the most profitable clinic
--     for a given month
-- ------------------------------------------------------------

WITH clinic_profit AS (
    SELECT
        cl.city,
        cl.cid,
        cl.clinic_name,
        COALESCE(rev.revenue, 0) - COALESCE(exp.expense, 0) AS profit
    FROM clinics cl
    LEFT JOIN (
        SELECT cid, SUM(amount) AS revenue
        FROM clinic_sales
        WHERE YEAR(datetime)  = 2021
          AND MONTH(datetime) = 10         -- change month as needed
        GROUP BY cid
    ) rev ON rev.cid = cl.cid
    LEFT JOIN (
        SELECT cid, SUM(amount) AS expense
        FROM expenses
        WHERE YEAR(datetime)  = 2021
          AND MONTH(datetime) = 10
        GROUP BY cid
    ) exp ON exp.cid = cl.cid
),
ranked AS (
    SELECT
        city,
        cid,
        clinic_name,
        profit,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT city, cid, clinic_name, profit AS highest_profit
FROM ranked
WHERE rnk = 1
ORDER BY city;

-- ------------------------------------------------------------
-- Q5. For each state, find the second least profitable clinic
--     for a given month
-- ------------------------------------------------------------

WITH clinic_profit AS (
    SELECT
        cl.state,
        cl.cid,
        cl.clinic_name,
        COALESCE(rev.revenue, 0) - COALESCE(exp.expense, 0) AS profit
    FROM clinics cl
    LEFT JOIN (
        SELECT cid, SUM(amount) AS revenue
        FROM clinic_sales
        WHERE YEAR(datetime)  = 2021
          AND MONTH(datetime) = 10         -- change month as needed
        GROUP BY cid
    ) rev ON rev.cid = cl.cid
    LEFT JOIN (
        SELECT cid, SUM(amount) AS expense
        FROM expenses
        WHERE YEAR(datetime)  = 2021
          AND MONTH(datetime) = 10
        GROUP BY cid
    ) exp ON exp.cid = cl.cid
),
ranked AS (
    SELECT
        state,
        cid,
        clinic_name,
        profit,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT state, cid, clinic_name, profit AS second_least_profit
FROM ranked
WHERE rnk = 2
ORDER BY state;
