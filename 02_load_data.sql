USE parking_violations_db;

INSERT ignore INTO violation_codes (violation_code, description, penalty_amount)
SELECT DISTINCT 
    violation_code,
    violation_description,
    CASE 
        WHEN violation_description LIKE '%HYDRANT%' THEN 115.00
        WHEN violation_description LIKE '%DOUBLE%' THEN 115.00
        WHEN violation_description LIKE '%SPEED%' THEN 175.00
        WHEN violation_description LIKE '%RED LIGHT%' THEN 150.00
        WHEN violation_description LIKE '%STREET CLEAN%' THEN 65.00
        WHEN violation_description LIKE '%METER%' THEN 65.00
        WHEN violation_description LIKE '%STANDING%' THEN 65.00
        WHEN violation_description LIKE '%PARKING%' THEN 65.00
        ELSE 50.00
    END AS penalty_amount
FROM violations_raw
WHERE violation_code IS NOT NULL
AND violation_description IS NOT NULL;

INSERT INTO locations (precinct, borough)
SELECT DISTINCT 
    violation_precinct,
    CASE 
        WHEN violation_precinct BETWEEN 1 AND 34 THEN 'Manhattan'
        WHEN violation_precinct BETWEEN 40 AND 49 THEN 'Brooklyn'
        WHEN violation_precinct BETWEEN 60 AND 69 THEN 'Bronx'
        WHEN violation_precinct BETWEEN 70 AND 94 THEN 'Queens'
        WHEN violation_precinct BETWEEN 120 AND 123 THEN 'Staten Island'
        ELSE 'Unknown'
    END AS borough
FROM violations_raw
WHERE violation_precinct IS NOT NULL
AND violation_precinct > 0;

INSERT IGNORE INTO violations (
    violation_id, plate_number, state, issue_date,
    violation_code, issuing_agency, vehicle_make,
    vehicle_color, precinct, fine_amount, borough, status
)
SELECT 
    vr.summons_number,
    vr.plate_id,
    vr.registration_state,
    CASE 
        WHEN vr.issue_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
        THEN STR_TO_DATE(vr.issue_date, '%m/%d/%Y')
        ELSE NULL
    END,
    vr.violation_code,
    vr.issuing_agency,
    vr.vehicle_make,
    vr.vehicle_color,
    vr.violation_precinct,
    vc.penalty_amount,
    l.borough,
    'OPEN'
FROM violations_raw vr
JOIN violation_codes vc ON vr.violation_code = vc.violation_code
JOIN locations l ON vr.violation_precinct = l.precinct
WHERE vr.summons_number IS NOT NULL;

INSERT INTO payments (payment_id, violation_id, payment_date, amount_paid)
SELECT 
    CONCAT('PAY-', LPAD(ROW_NUMBER() OVER (ORDER BY violation_id), 5, '0')),
    violation_id,
    DATE_ADD(issue_date, INTERVAL 30 DAY),
    fine_amount
FROM violations
ORDER BY RAND()
LIMIT 2000;INSERT IGNORE INTO violations (     violation_id, plate_number, state, issue_date,     violation_code, issuing_agency, vehicle_make,     vehicle_color, precinct, fine_amount, borough, status ) SELECT      vr.summons_number,     vr.plate_id,     vr.registration_state,     CASE          WHEN vr.issue_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'          THEN STR_TO_DATE(vr.issue_date, '%m/%d/%Y')         ELSE NULL     END,     vr.violation_code,     vr.issuing_agency,     vr.vehicle_make,     vr.vehicle_color,     vr.violation_precinct,     vc.penalty_amount,     l.borough,     'OPEN' FROM violations_raw vr JOIN violation_codes vc ON vr.violation_code = vc.violation_code JOIN locations l ON vr.violation_precinct = l.precinct WHERE vr.summons_number IS NOT NULL
