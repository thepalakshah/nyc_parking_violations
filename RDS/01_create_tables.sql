CREATE DATABASE IF NOT EXISTS parking_violations_db;
USE parking_violations_db;

CREATE TABLE IF NOT EXISTS violation_codes (
    violation_code   INT PRIMARY KEY,
    description      VARCHAR(100),
    penalty_amount   DECIMAL(8,2)
);

CREATE TABLE IF NOT EXISTS locations (
    precinct   INT PRIMARY KEY,
    borough    VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS violations (
    violation_id       BIGINT PRIMARY KEY,
    plate_number       VARCHAR(20),
    state              VARCHAR(5),
    issue_date         DATE,
    violation_code     INT,
    issuing_agency     VARCHAR(20),
    vehicle_make       VARCHAR(30),
    vehicle_color      VARCHAR(20),
    precinct           INT,
    fine_amount        DECIMAL(8,2),
    borough            VARCHAR(30),
    status             VARCHAR(10) DEFAULT 'OPEN',
    FOREIGN KEY (violation_code) REFERENCES violation_codes(violation_code),
    FOREIGN KEY (precinct) REFERENCES locations(precinct)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id     VARCHAR(10) PRIMARY KEY,
    violation_id   BIGINT,
    payment_date   DATE,
    amount_paid    DECIMAL(8,2),
    FOREIGN KEY (violation_id) REFERENCES violations(violation_id)
);

SHOW TABLES;