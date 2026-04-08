-- Hotel Management System - Schema Setup & Sample Data

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- TABLE: users
CREATE TABLE users (
    user_id         VARCHAR(50) PRIMARY KEY,
    name            VARCHAR(100),
    phone_number    VARCHAR(15),
    mail_id         VARCHAR(100),
    billing_address TEXT
);

-- TABLE: items
CREATE TABLE items (
    item_id     VARCHAR(50) PRIMARY KEY,
    item_name   VARCHAR(100),
    item_rate   DECIMAL(10, 2)
);

-- TABLE: bookings
CREATE TABLE bookings (
    booking_id      VARCHAR(50) PRIMARY KEY,
    booking_date    DATETIME,
    room_no         VARCHAR(50),
    user_id         VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- TABLE: booking_commercials
CREATE TABLE booking_commercials (
    id              VARCHAR(50) PRIMARY KEY,
    booking_id      VARCHAR(50),
    bill_id         VARCHAR(50),
    bill_date       DATETIME,
    item_id         VARCHAR(50),
    item_quantity   DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- SAMPLE DATA: users
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('21wrcxuy-67erfn', 'John Doe',  '9712345678', 'john.doe@example.com',  '12, Street A, Mumbai'),
('user-002-abcdef', 'Jane Smith','9898765432', 'jane.smith@example.com','34, Street B, Delhi'),
('user-003-ghijkl', 'Bob Kumar', '9012345678', 'bob.kumar@example.com', '56, Street C, Pune'),
('user-004-mnopqr', 'Alice Roy',  '9123456780', 'alice.roy@example.com', '78, Street D, Nagpur');

-- SAMPLE DATA: items
INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-a9e8-q8fu',  'Tawa Paratha',    18.00),
('itm-a07vh-aer8', 'Mix Veg',         89.00),
('itm-w978-23u4',  'Butter Chicken', 220.00),
('itm-x123-bcde',  'Dal Makhani',    150.00),
('itm-y456-efgh',  'Masala Chai',     30.00),
('itm-z789-ijkl',  'Paneer Tikka',   180.00);

-- SAMPLE DATA: bookings
INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
-- John Doe – two bookings
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-nov1-0001',  '2021-11-05 10:00:00', 'rm-002-bbbbbb', '21wrcxuy-67erfn'),
-- Jane Smith
('bk-nov2-0002',  '2021-11-12 14:30:00', 'rm-003-cccccc', 'user-002-abcdef'),
-- Bob Kumar
('bk-oct1-0003',  '2021-10-08 09:15:00', 'rm-004-dddddd', 'user-003-ghijkl'),
('bk-nov3-0004',  '2021-11-20 18:45:00', 'rm-005-eeeeee', 'user-003-ghijkl'),
-- Alice Roy
('bk-oct2-0005',  '2021-10-25 11:00:00', 'rm-006-ffffff', 'user-004-mnopqr'),
('bk-dec1-0006',  '2021-12-01 08:00:00', 'rm-007-gggggg', 'user-004-mnopqr');

-- SAMPLE DATA: booking_commercials
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
-- Bill for bk-09f3e-95hj (Sep 2021)
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu',  3.0),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1.0),
('134lr-oyfo8-3qk4','bk-09f3e-95hj', 'bl-34qhd-r7h8', '2021-09-23 12:05:37', 'itm-w978-23u4',  0.5),

-- Bill for bk-nov1-0001 (Nov 2021)
('nov1-bc-001', 'bk-nov1-0001', 'bl-nov1-001', '2021-11-05 13:00:00', 'itm-a9e8-q8fu',  5.0),
('nov1-bc-002', 'bk-nov1-0001', 'bl-nov1-001', '2021-11-05 13:00:00', 'itm-x123-bcde',  2.0),
('nov1-bc-003', 'bk-nov1-0001', 'bl-nov1-002', '2021-11-06 08:00:00', 'itm-y456-efgh',  3.0),

-- Bill for bk-nov2-0002 (Nov 2021)
('nov2-bc-001', 'bk-nov2-0002', 'bl-nov2-001', '2021-11-12 19:00:00', 'itm-z789-ijkl',  2.0),
('nov2-bc-002', 'bk-nov2-0002', 'bl-nov2-001', '2021-11-12 19:00:00', 'itm-w978-23u4',  3.0),

-- Bill for bk-oct1-0003 (Oct 2021)
('oct1-bc-001', 'bk-oct1-0003', 'bl-oct1-001', '2021-10-08 20:00:00', 'itm-a07vh-aer8', 4.0),
('oct1-bc-002', 'bk-oct1-0003', 'bl-oct1-001', '2021-10-08 20:00:00', 'itm-x123-bcde',  5.0),
('oct1-bc-003', 'bk-oct1-0003', 'bl-oct1-002', '2021-10-09 09:00:00', 'itm-y456-efgh',  6.0),

-- Bill for bk-nov3-0004 (Nov 2021)
('nov3-bc-001', 'bk-nov3-0004', 'bl-nov3-001', '2021-11-20 21:00:00', 'itm-z789-ijkl',  4.0),
('nov3-bc-002', 'bk-nov3-0004', 'bl-nov3-001', '2021-11-20 21:00:00', 'itm-a9e8-q8fu', 10.0),

-- Bill for bk-oct2-0005 (Oct 2021)
('oct2-bc-001', 'bk-oct2-0005', 'bl-oct2-001', '2021-10-25 14:00:00', 'itm-w978-23u4',  3.0),
('oct2-bc-002', 'bk-oct2-0005', 'bl-oct2-001', '2021-10-25 14:00:00', 'itm-a07vh-aer8', 2.0),

-- Bill for bk-dec1-0006 (Dec 2021)
('dec1-bc-001', 'bk-dec1-0006', 'bl-dec1-001', '2021-12-01 10:00:00', 'itm-z789-ijkl',  1.0),
('dec1-bc-002', 'bk-dec1-0006', 'bl-dec1-001', '2021-12-01 10:00:00', 'itm-x123-bcde',  3.0);
