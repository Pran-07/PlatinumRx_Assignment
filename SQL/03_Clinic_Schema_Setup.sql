-- Clinic Management System – Schema Setup & Sample Data
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

-- TABLE: clinics
CREATE TABLE clinics (
    cid         VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

-- TABLE: customer
CREATE TABLE customer (
    uid     VARCHAR(50) PRIMARY KEY,
    name    VARCHAR(100),
    mobile  VARCHAR(15)
);

-- TABLE: clinic_sales
CREATE TABLE clinic_sales (
    oid          VARCHAR(50) PRIMARY KEY,
    uid          VARCHAR(50),
    cid          VARCHAR(50),
    amount       DECIMAL(12, 2),
    datetime     DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- TABLE: expenses
CREATE TABLE expenses (
    eid         VARCHAR(50) PRIMARY KEY,
    cid         VARCHAR(50),
    description VARCHAR(200),
    amount      DECIMAL(12, 2),
    datetime    DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- SAMPLE DATA: clinics
INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001', 'HealthFirst Clinic',   'Mumbai',    'Maharashtra', 'India'),
('cnc-0100002', 'CarePoint Clinic',     'Pune',      'Maharashtra', 'India'),
('cnc-0100003', 'MediLife Clinic',      'Nagpur',    'Maharashtra', 'India'),
('cnc-0100004', 'WellCure Clinic',      'Delhi',     'Delhi',       'India'),
('cnc-0100005', 'CityHealth Clinic',    'Gurgaon',   'Haryana',     'India'),
('cnc-0100006', 'QuickCare Clinic',     'Faridabad', 'Haryana',     'India');

-- SAMPLE DATA: customer
INSERT INTO customer (uid, name, mobile) VALUES
('cust-001', 'Jon Doe',     '9711111111'),
('cust-002', 'Priya Sharma','9722222222'),
('cust-003', 'Rahul Singh', '9733333333'),
('cust-004', 'Anjali Mehta','9744444444'),
('cust-005', 'Vikram Rao',  '9755555555'),
('cust-006', 'Neha Joshi',  '9766666666'),
('cust-007', 'Amit Verma',  '9777777777'),
('cust-008', 'Pooja Nair',  '9788888888'),
('cust-009', 'Ravi Kumar',  '9799999999'),
('cust-010', 'Sunita Das',  '9700000000');

-- SAMPLE DATA: clinic_sales  (year 2021)
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
-- Jan 2021
('ord-001', 'cust-001', 'cnc-0100001', 24999, '2021-01-10 10:00:00', 'online'),
('ord-002', 'cust-002', 'cnc-0100001',  8500, '2021-01-15 11:00:00', 'offline'),
('ord-003', 'cust-003', 'cnc-0100002', 15000, '2021-01-20 12:00:00', 'app'),
('ord-004', 'cust-004', 'cnc-0100003',  5000, '2021-01-25 13:00:00', 'online'),
-- Feb 2021
('ord-005', 'cust-005', 'cnc-0100001', 12000, '2021-02-05 09:00:00', 'app'),
('ord-006', 'cust-006', 'cnc-0100002', 30000, '2021-02-10 14:00:00', 'offline'),
('ord-007', 'cust-001', 'cnc-0100004', 18000, '2021-02-14 15:00:00', 'online'),
-- Mar 2021
('ord-008', 'cust-007', 'cnc-0100005', 22000, '2021-03-08 10:30:00', 'app'),
('ord-009', 'cust-008', 'cnc-0100006',  9500, '2021-03-15 11:30:00', 'offline'),
-- Apr-Jun 2021
('ord-010', 'cust-009', 'cnc-0100001', 45000, '2021-04-01 09:00:00', 'online'),
('ord-011', 'cust-010', 'cnc-0100002', 31000, '2021-05-10 10:00:00', 'app'),
('ord-012', 'cust-001', 'cnc-0100003', 27000, '2021-06-20 11:00:00', 'offline'),
-- Jul-Sep 2021
('ord-013', 'cust-002', 'cnc-0100004', 19000, '2021-07-05 10:00:00', 'online'),
('ord-014', 'cust-003', 'cnc-0100005', 35000, '2021-08-15 12:00:00', 'app'),
('ord-015', 'cust-004', 'cnc-0100006', 41000, '2021-09-23 12:03:22', 'online'),
-- Oct 2021
('ord-016', 'cust-005', 'cnc-0100001', 52000, '2021-10-05 09:00:00', 'app'),
('ord-017', 'cust-006', 'cnc-0100002', 16000, '2021-10-12 14:00:00', 'offline'),
('ord-018', 'cust-007', 'cnc-0100003', 28000, '2021-10-20 10:00:00', 'online'),
-- Nov 2021
('ord-019', 'cust-008', 'cnc-0100004', 37000, '2021-11-08 11:00:00', 'app'),
('ord-020', 'cust-009', 'cnc-0100005', 21000, '2021-11-18 15:00:00', 'offline'),
-- Dec 2021
('ord-021', 'cust-010', 'cnc-0100006', 48000, '2021-12-03 09:00:00', 'online'),
('ord-022', 'cust-001', 'cnc-0100001', 62000, '2021-12-15 10:00:00', 'app');

-- SAMPLE DATA: expenses  (year 2021)
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-001', 'cnc-0100001', 'first-aid supplies',  557,  '2021-01-05 07:00:00'),
('exp-002', 'cnc-0100001', 'staff salary',       25000, '2021-01-31 18:00:00'),
('exp-003', 'cnc-0100002', 'medicines',           8000, '2021-01-10 09:00:00'),
('exp-004', 'cnc-0100003', 'equipment rent',     12000, '2021-02-01 08:00:00'),
('exp-005', 'cnc-0100001', 'utilities',           3500, '2021-02-28 17:00:00'),
('exp-006', 'cnc-0100004', 'staff salary',       20000, '2021-03-31 18:00:00'),
('exp-007', 'cnc-0100005', 'rent',               15000, '2021-03-01 08:00:00'),
('exp-008', 'cnc-0100006', 'medicines',           6000, '2021-03-15 10:00:00'),
('exp-009', 'cnc-0100001', 'staff salary',       25000, '2021-04-30 18:00:00'),
('exp-010', 'cnc-0100002', 'rent',               18000, '2021-05-01 08:00:00'),
('exp-011', 'cnc-0100003', 'utilities',           4500, '2021-06-30 17:00:00'),
('exp-012', 'cnc-0100004', 'medicines',           9000, '2021-07-15 10:00:00'),
('exp-013', 'cnc-0100005', 'staff salary',       22000, '2021-08-31 18:00:00'),
('exp-014', 'cnc-0100006', 'equipment repair',   11000, '2021-09-10 09:00:00'),
('exp-015', 'cnc-0100001', 'staff salary',       25000, '2021-10-31 18:00:00'),
('exp-016', 'cnc-0100002', 'medicines',           7000, '2021-11-12 10:00:00'),
('exp-017', 'cnc-0100003', 'rent',               14000, '2021-12-01 08:00:00'),
('exp-018', 'cnc-0100004', 'utilities',           5000, '2021-12-31 17:00:00');
