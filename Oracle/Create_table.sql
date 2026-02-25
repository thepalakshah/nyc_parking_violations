-- Create tables for NYC Parking Violations (Oracle version)
CREATE TABLE violations (
    violation_id    NUMBER PRIMARY KEY,
    plate_number    VARCHAR2(20),
    state           VARCHAR2(5),
    issue_date      DATE,
    violation_code  NUMBER,
    vehicle_make    VARCHAR2(30),
    fine_amount     NUMBER(8,2),
    borough         VARCHAR2(30),
    status          VARCHAR2(10) DEFAULT 'OPEN'
);

CREATE TABLE payments (
    payment_id    VARCHAR2(10) PRIMARY KEY,
    violation_id  NUMBER,
    payment_date  DATE,
    amount_paid   NUMBER(8,2)
);