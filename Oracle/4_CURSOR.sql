-- =============================================
-- PIECE 4: CURSOR
-- Loops through all unpaid violations
-- and prints a summary report
-- This is like an automated monitoring alert
-- =============================================

CREATE OR REPLACE PROCEDURE unpaid_violations_report AS
    -- Declare cursor
    CURSOR c_unpaid IS
        SELECT violation_id, plate_number, borough, 
               fine_amount, issue_date
        FROM violations
        WHERE status = 'OPEN'
        ORDER BY fine_amount DESC;
    
    -- Variables to hold each row
    v_total_amount NUMBER := 0;
    v_count        NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('   UNPAID VIOLATIONS REPORT');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    -- Loop through every unpaid violation
    FOR rec IN c_unpaid LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID: '       || rec.violation_id ||
            ' | Plate: ' || rec.plate_number ||
            ' | Borough: '|| rec.borough ||
            ' | Fine: $' || rec.fine_amount ||
            ' | Date: '  || rec.issue_date
        );
        v_total_amount := v_total_amount + rec.fine_amount;
        v_count := v_count + 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Total Unpaid Tickets : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('Total Amount Owed    : $' || v_total_amount);
    DBMS_OUTPUT.PUT_LINE('========================================');
END;
/

-- Run the report
SET SERVEROUTPUT ON;
EXEC unpaid_violations_report;