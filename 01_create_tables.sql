-- =============================================
-- NYC Parking Violations Monitoring System

CREATE DATABASE IF NOT EXISTS parking_violations_db;
USE parking_violations_db;

-- =============================================
-- Table 1: violation_codes (lookup table)
-- Stores unique violation types and penalties
-- =============================================
CREATE TABLE IF NOT EXISTS violation_codes (
    violation_code   INT PRIMARY KEY,
    description      VARCHAR(100),
    penalty_amount   DECIMAL(8,2)
);

-- =============================================
-- Table 2: locations (lookup table)
-- Maps NYC precincts to boroughs
-- =============================================
CREATE TABLE IF NOT EXISTS locations (
    precinct   INT PRIMARY KEY,
    borough    VARCHAR(30)
);

-- =============================================
-- Table 3: violations (main table)
-- Core ticket records — 78,000+ real NYC rows
-- =============================================
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

-- =============================================
-- Table 4: payments (transaction table)
-- Simulated payment records for demo purposes
-- =============================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id     VARCHAR(10) PRIMARY KEY,
    violation_id   BIGINT,
    payment_date   DATE,
    amount_paid    DECIMAL(8,2),
    FOREIGN KEY (violation_id) REFERENCES violations(violation_id)
);

-- =============================================
-- Table 5: violations_raw (staging table)
-- Temporary table to load raw CSV data
-- All columns match CSV exactly — no FK rules
-- =============================================
CREATE TABLE IF NOT EXISTS violations_raw (
    summons_number BIGINT,
    plate_id VARCHAR(50),
    registration_state VARCHAR(10),
    plate_type VARCHAR(20),
    issue_date VARCHAR(50),
    violation_code INT,
    vehicle_body_type VARCHAR(20),
    vehicle_make VARCHAR(50),
    issuing_agency VARCHAR(100),
    street_code1 INT,
    street_code2 INT,
    street_code3 INT,
    vehicle_expiration_date VARCHAR(20),
    violation_location VARCHAR(50),
    violation_precinct INT,
    issuer_precinct INT,
    issuer_code INT,
    issuer_command VARCHAR(50),
    issuer_squad VARCHAR(50),
    violation_time VARCHAR(20),
    time_first_observed VARCHAR(20),
    violation_county VARCHAR(50),
    violation_in_front_of_or_opposite VARCHAR(10),
    house_number VARCHAR(20),
    street_name VARCHAR(100),
    intersecting_street VARCHAR(100),
    date_first_observed VARCHAR(20),
    law_section INT,
    sub_division VARCHAR(10),
    violation_legal_code VARCHAR(20),
    days_parking_in_effect VARCHAR(50),
    from_hours_in_effect VARCHAR(20),
    to_hours_in_effect VARCHAR(20),
    vehicle_color VARCHAR(20),
    unregistered_vehicle VARCHAR(5),
    vehicle_year INT,
    meter_number VARCHAR(20),
    feet_from_curb INT,
    violation_post_code VARCHAR(20),
    violation_description VARCHAR(255),
    no_standing_or_stopping_violation VARCHAR(5),
    hydrant_violation VARCHAR(5),
    double_parking_violation VARCHAR(5)
);
SHOW TABLES;