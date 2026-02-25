CREATE OR REPLACE PROCEDURE process_payment (
    p_violation_id IN NUMBER,
    p_amount       IN NUMBER
) AS
    v_status VARCHAR2(10);
BEGIN
    -- Check if violation exists and is still open
    SELECT status INTO v_status
    FROM violations
    WHERE violation_id = p_violation_id;

    IF v_status = 'PAID' THEN
        DBMS_OUTPUT.PUT_LINE('Violation ' || p_violation_id || ' is already paid.');
    ELSE
        -- Insert payment record
        INSERT INTO payments VALUES (
            'PAY-' || p_violation_id,
            p_violation_id,
            SYSDATE,
            p_amount
        );

        -- Update violation status
        UPDATE violations
        SET status = 'PAID'
        WHERE violation_id = p_violation_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Payment processed successfully for violation ' || p_violation_id);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Violation ID ' || p_violation_id || ' not found.');
END;
/
SET SERVEROUTPUT ON;

-- Pay violation 1001
EXEC process_payment(1001, 115.00);

-- Try to pay it again (should say already paid)
EXEC process_payment(1001, 115.00);

-- Check it updated
SELECT violation_id, status FROM violations WHERE violation_id = 1001;