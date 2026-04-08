# PlatinumRx Data Analyst Assignment

## Overview
This repository contains solutions for the PlatinumRx Data Analyst assessment covering SQL, Spreadsheet, and Python proficiency.

---

## Folder Structure

```
Data_Analyst_Assignment/
│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    # CREATE TABLE + INSERT sample data (Hotel)
│   ├── 02_Hotel_Queries.sql         # Solutions for Part A – Questions 1–5
│   ├── 03_Clinic_Schema_Setup.sql   # CREATE TABLE + INSERT sample data (Clinic)
│   └── 04_Clinic_Queries.sql        # Solutions for Part B – Questions 1–5
│
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx         # 3-sheet workbook: ticket | feedbacks | Analysis
│
├── Python/
│   ├── 01_Time_Converter.py         # Convert minutes → "X hrs Y minutes"
│   └── 02_Remove_Duplicates.py      # Remove duplicate chars using a loop
│
└── README.md
```

---

## Phase 1 – SQL

### Hotel Management System (Part A)

| # | Question | Approach |
|---|---|---|
| 1 | Last booked room per user | `ROW_NUMBER()` window function partitioned by `user_id`, ordered by `booking_date DESC` |
| 2 | Total bill per booking in Nov 2021 | `JOIN` bookings → booking_commercials → items; `SUM(qty × rate)`; filter with `YEAR/MONTH` |
| 3 | Bills > 1000 in Oct 2021 | Same join pattern; filter month = 10; `HAVING SUM(...) > 1000` |
| 4 | Most & least ordered item each month | `RANK()` window function in both ASC/DESC order on monthly quantity totals |
| 5 | Customer with 2nd highest bill each month | `DENSE_RANK()` on bill totals per month; keep `rank = 2` |

### Clinic Management System (Part B)

| # | Question | Approach |
|---|---|---|
| 1 | Revenue by sales channel | `GROUP BY sales_channel`, `SUM(amount)` |
| 2 | Top 10 customers by spend | `JOIN customer`, `SUM(amount)`, `ORDER BY DESC LIMIT 10` |
| 3 | Monthly revenue / expense / profit | Two CTEs aggregated by month; `FULL OUTER JOIN` (or UNION-based LEFT JOIN for MySQL) |
| 4 | Most profitable clinic per city (month) | `RANK() OVER (PARTITION BY city ORDER BY profit DESC)` |
| 5 | 2nd least profitable clinic per state | `DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC)`, keep `rank = 2` |

> **DB Compatibility:** All queries are written for MySQL/MariaDB.  
> The `FULL OUTER JOIN` in Q3 has an equivalent MySQL workaround included as a comment.

---

## Phase 2 – Spreadsheet

**File:** `Spreadsheets/Ticket_Analysis.xlsx`

### Sheet: `ticket`
Raw ticket data with columns: `ticket_id`, `created_at`, `closed_at`, `outlet_id`, `cms_id`.

### Sheet: `feedbacks`
- `ticket_created_at` (column D) is populated using:
  ```excel
  =IFERROR(VLOOKUP(A2, ticket!$A:$E, 2, FALSE), "Not Found")
  ```
  This looks up `cms_id` (column A) in the `ticket` sheet's `cms_id` column (column E) and returns the matching `created_at` (column B).

### Sheet: `Analysis`
- **Helper columns** per ticket row:
  - `created_date` = `INT(created_at)` — extracts date portion
  - `closed_date`  = `INT(closed_at)`
  - `same_day?`    = `IF(created_date = closed_date, "Yes", "No")`
  - `created_hour` = `HOUR(created_at)`
  - `closed_hour`  = `HOUR(closed_at)`
  - `same_hour?`   = `IF(AND(same_day, created_hour = closed_hour), "Yes", "No")`

- **Outlet summary** using `COUNTIFS`:
  ```excel
  =COUNTIFS($D$4:$D$13, outlet_id, $G$4:$G$13, "Yes")   -- same day count
  =COUNTIFS($D$4:$D$13, outlet_id, $J$4:$J$13, "Yes")   -- same hour count
  ```

---

## Phase 3 – Python

### `01_Time_Converter.py`
```python
hours            = total_minutes // 60
remaining_minutes = total_minutes % 60
```
Outputs `"X hrs Y minutes"` (uses `"hr"` for exactly 1 hour).

### `02_Remove_Duplicates.py`
```python
result = ""
for char in input_string:
    if char not in result:
        result = result + char
```
Uses only a `for` loop and string concatenation — no sets or comprehensions.

---

## How to Run

### SQL
1. Open MySQL Workbench (or any RDBMS).
2. Run `01_Hotel_Schema_Setup.sql` → creates and seeds Hotel tables.
3. Run `02_Hotel_Queries.sql` → executes the 5 Hotel queries.
4. Run `03_Clinic_Schema_Setup.sql` → creates and seeds Clinic tables.
5. Run `04_Clinic_Queries.sql` → executes the 5 Clinic queries.

### Python
```bash
python Python/01_Time_Converter.py
python Python/02_Remove_Duplicates.py
```

### Spreadsheet
Open `Spreadsheets/Ticket_Analysis.xlsx` in Microsoft Excel or Google Sheets. All formulas are live and will auto-calculate.

---

## Assumptions
- All queries target **year 2021**. Change `YEAR(...) = 2021` or the month constant to query other periods.
- "Bill amount" in Hotel Q3 = `SUM(item_quantity × item_rate)` grouped by `bill_id`.
- "Most/least ordered" in Hotel Q4 is measured by **total quantity**, not order frequency.
- Clinic profit = `SUM(clinic_sales.amount) − SUM(expenses.amount)` for the same `cid` and period.
