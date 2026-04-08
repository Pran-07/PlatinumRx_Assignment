-- ============================================================
-- Hotel Management System – Query Solutions (Part A)
-- ============================================================

-- ------------------------------------------------------------
-- Q1. For every user, get user_id and last booked room_no
-- ------------------------------------------------------------
-- Strategy: rank bookings per user by booking_date DESC,
--           then keep only rank = 1 (the latest booking).
-- Note: Users with no bookings at all will not appear (INNER JOIN).

SELECT
    u.user_id,
    u.name,
    b.room_no        AS last_booked_room_no,
    b.booking_date   AS last_booking_date
FROM users u
INNER JOIN (
    SELECT
        user_id,
        room_no,
        booking_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY booking_date DESC
        ) AS rn
    FROM bookings
) b ON b.user_id = u.user_id AND b.rn = 1;

-- ------------------------------------------------------------
-- Q2. booking_id and total billing amount for every booking
--     created in November 2021
-- ------------------------------------------------------------
-- Total bill = SUM(item_quantity * item_rate) across all
-- booking_commercial rows that belong to a booking.

SELECT
    bk.booking_id,
    ROUND(SUM(bc.item_quantity * i.item_rate), 2) AS total_billing_amount
FROM bookings bk
INNER JOIN booking_commercials bc ON bc.booking_id = bk.booking_id
INNER JOIN items               i  ON i.item_id     = bc.item_id
WHERE YEAR(bk.booking_date)  = 2021
  AND MONTH(bk.booking_date) = 11          -- November
GROUP BY bk.booking_id;

-- ------------------------------------------------------------
-- Q3. bill_id and bill amount of all bills raised in
--     October 2021 where bill amount > 1000
-- ------------------------------------------------------------

SELECT
    bc.bill_id,
    ROUND(SUM(bc.item_quantity * i.item_rate), 2) AS bill_amount
FROM booking_commercials bc
INNER JOIN items i ON i.item_id = bc.item_id
WHERE YEAR(bc.bill_date)  = 2021
  AND MONTH(bc.bill_date) = 10             -- October
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- ------------------------------------------------------------
-- Q4. Most ordered AND least ordered item of each month
--     in year 2021 (by total quantity ordered)
-- ------------------------------------------------------------
-- Step 1: compute total quantity per item per month.
-- Step 2: rank items within each month in both directions.
-- Step 3: keep rank-1 from each direction.

WITH monthly_item_qty AS (
    SELECT
        MONTH(bc.bill_date)                          AS bill_month,
        i.item_id,
        i.item_name,
        SUM(bc.item_quantity)                        AS total_qty
    FROM booking_commercials bc
    INNER JOIN items i ON i.item_id = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_id, i.item_name
),
ranked AS (
    SELECT
        bill_month,
        item_id,
        item_name,
        total_qty,
        RANK() OVER (PARTITION BY bill_month ORDER BY total_qty DESC) AS rank_most,
        RANK() OVER (PARTITION BY bill_month ORDER BY total_qty ASC)  AS rank_least
    FROM monthly_item_qty
)
SELECT
    bill_month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_most  = 1 THEN total_qty  END) AS most_ordered_qty,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN total_qty  END) AS least_ordered_qty
FROM ranked
WHERE rank_most = 1 OR rank_least = 1
GROUP BY bill_month
ORDER BY bill_month;

-- ------------------------------------------------------------
-- Q5. Customers with the second highest bill value of each
--     month in year 2021
-- ------------------------------------------------------------
-- "Bill value" = total amount on one bill_id.
-- We rank bills per month; the customer who owns the 2nd
-- highest bill in that month is our answer.

WITH bill_totals AS (
    SELECT
        MONTH(bc.bill_date)                           AS bill_month,
        bc.bill_id,
        bk.user_id,
        u.name                                        AS customer_name,
        ROUND(SUM(bc.item_quantity * i.item_rate), 2) AS bill_amount
    FROM booking_commercials bc
    INNER JOIN items    i  ON i.item_id    = bc.item_id
    INNER JOIN bookings bk ON bk.booking_id = bc.booking_id
    INNER JOIN users    u  ON u.user_id    = bk.user_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), bc.bill_id, bk.user_id, u.name
),
ranked_bills AS (
    SELECT
        bill_month,
        bill_id,
        user_id,
        customer_name,
        bill_amount,
        DENSE_RANK() OVER (
            PARTITION BY bill_month
            ORDER BY bill_amount DESC
        ) AS bill_rank
    FROM bill_totals
)
SELECT
    bill_month,
    bill_id,
    user_id,
    customer_name,
    bill_amount AS second_highest_bill_amount
FROM ranked_bills
WHERE bill_rank = 2
ORDER BY bill_month;
