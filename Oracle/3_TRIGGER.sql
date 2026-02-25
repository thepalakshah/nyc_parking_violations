
-- =============================================
-- PIECE 3: TRIGGER
-- Auto updates violation status to PAID
-- whenever a new payment is inserted
-- No manual call needed — fires automatically
-- =============================================

CREATE OR REPLACE TRIGGER trg_payment_update
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    UPDATE violations
    SET status = 'PAID'
    WHERE violation_id = :NEW.violation_id;
    
    DBMS_OUTPUT.PUT_LINE(
        'Trigger fired — Violation ' || :NEW.violation_id || 
        ' automatically marked as PAID'
    );
END;
/

-- Test the trigger
-- Insert a payment directly — trigger should auto update violation
SET SERVEROUTPUT ON;

INSERT INTO payments VALUES ('PAY-1002', 1002, SYSDATE, 65.00);
COMMIT;

-- Check violation 1002 is now PAID automatically
SELECT violation_id, plate_number, fine_amount, status 
FROM violations 
WHERE violation_id = 1002;
