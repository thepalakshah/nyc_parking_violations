CREATE OR REPLACE PROCEDURE get_violations_by_plate (
    p_plate IN VARCHAR2
) AS
BEGIN
    FOR rec IN (
        SELECT violation_id, issue_date, violation_code, 
               fine_amount, borough, status
        FROM violations
        WHERE plate_number = p_plate
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || rec.violation_id ||
            ' | Date: ' || rec.issue_date ||
            ' | Fine: $' || rec.fine_amount ||
            ' | Borough: ' || rec.borough ||
            ' | Status: ' || rec.status
        );
    END LOOP;
END;
