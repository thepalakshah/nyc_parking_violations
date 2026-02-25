-- =============================================
-- NYC Parking Violations Monitoring System
-- Script 03: SQL Queries (15 Queries)
-- Covers: SELECT, WHERE, GROUP BY, HAVING,
--         JOIN, Subquery, CASE, Aggregates
-- =============================================

USE parking_violations_db;

-- =============================================
-- QUERY 1: Total tickets per borough
-- Concept: GROUP BY + COUNT + ORDER BY
-- =============================================
SELECT 
    borough, 
    COUNT(*) AS total_tickets
FROM violations
GROUP BY borough
ORDER BY total_tickets DESC;

-- =============================================
-- QUERY 2: Top 10 most common violation types
-- Concept: JOIN + GROUP BY + aggregate
-- =============================================
SELECT 
    vc.description, 
    COUNT(*) AS total,
    vc.penalty_amount
FROM violations v
JOIN violation_codes vc ON v.violation_code = vc.violation_code
GROUP BY vc.description, vc.penalty_amount
ORDER BY total DESC
LIMIT 10;

-- =============================================
-- QUERY 3: Top 10 most ticketed car brands
-- Concept: GROUP BY + COUNT + filter nulls
-- =============================================
SELECT 
    vehicle_make, 
    COUNT(*) AS total_tickets
FROM violations
WHERE vehicle_make IS NOT NULL
GROUP BY vehicle_make
ORDER BY total_tickets DESC
LIMIT 10;

-- =============================================
-- QUERY 4: Top 10 busiest precincts
-- Concept: JOIN across 2 tables + GROUP BY
-- =============================================
SELECT 
    v.precinct,
    l.borough,
    COUNT(*) AS total_tickets
FROM violations v
JOIN locations l ON v.precinct = l.precinct
GROUP BY v.precinct, l.borough
ORDER BY total_tickets DESC
LIMIT 10;

-- =============================================
-- QUERY 5: Top 10 states with most tickets
-- Concept: GROUP BY + HAVING + ORDER BY
-- =============================================
SELECT 
    state, 
    COUNT(*) AS total_tickets
FROM violations
GROUP BY state
HAVING total_tickets > 100
ORDER BY total_tickets DESC
LIMIT 10;

-- =============================================
-- QUERY 6: Total revenue per borough
-- Concept: SUM aggregate + JOIN + GROUP BY
-- =============================================
SELECT 
    v.borough,
    COUNT(*) AS total_tickets,
    SUM(v.fine_amount) AS total_revenue,
    ROUND(AVG(v.fine_amount), 2) AS avg_fine
FROM violations v
GROUP BY v.borough
ORDER BY total_revenue DESC;

-- =============================================
-- QUERY 7: Tickets by month
-- Concept: DATE functions + GROUP BY
-- =============================================
SELECT 
    MONTH(issue_date) AS month_number,
    MONTHNAME(issue_date) AS month_name,
    COUNT(*) AS total_tickets
FROM violations
WHERE issue_date IS NOT NULL
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY month_number;

-- =============================================
-- QUERY 8: Unpaid violations (status = OPEN)
-- Concept: WHERE filter + SUM + GROUP BY
-- =============================================
SELECT 
    borough,
    COUNT(*) AS unpaid_tickets,
    SUM(fine_amount) AS unpaid_amount
FROM violations
WHERE status = 'OPEN'
GROUP BY borough
ORDER BY unpaid_amount DESC;

-- =============================================
-- QUERY 9: Violations above average fine amount
-- Concept: Subquery
-- =============================================
SELECT 
    violation_id,
    plate_number,
    state,
    vehicle_make,
    fine_amount,
    borough
FROM violations
WHERE fine_amount > (SELECT AVG(fine_amount) FROM violations)
ORDER BY fine_amount DESC
LIMIT 20;

-- =============================================
-- QUERY 10: Payment summary per borough
-- Concept: JOIN across 3 tables
-- =============================================
SELECT 
    v.borough,
    COUNT(p.payment_id) AS total_payments,
    SUM(p.amount_paid) AS total_collected
FROM payments p
JOIN violations v ON p.violation_id = v.violation_id
GROUP BY v.borough
ORDER BY total_collected DESC;

-- =============================================
-- QUERY 11: Fine category breakdown using CASE
-- Concept: CASE statement + GROUP BY
-- =============================================
SELECT 
    CASE 
        WHEN fine_amount >= 150 THEN 'High (150+)'
        WHEN fine_amount >= 100 THEN 'Medium (100-149)'
        WHEN fine_amount >= 50  THEN 'Low (50-99)'
        ELSE 'Minimal (under 50)'
    END AS fine_category,
    COUNT(*) AS total_tickets,
    SUM(fine_amount) AS total_amount
FROM violations
GROUP BY fine_category
ORDER BY total_amount DESC;

-- =============================================
-- QUERY 12: Most ticketed plate per borough
-- Concept: Subquery + GROUP BY + MAX
-- =============================================
SELECT 
    borough,
    plate_number,
    COUNT(*) AS ticket_count
FROM violations
GROUP BY borough, plate_number
HAVING ticket_count = (
    SELECT MAX(cnt) FROM (
        SELECT borough AS b, COUNT(*) AS cnt
        FROM violations
        GROUP BY borough, plate_number
    ) sub
    WHERE sub.b = violations.borough
)
ORDER BY ticket_count DESC;

-- =============================================
-- QUERY 13: Violation hotspots (precinct analysis)
-- Concept: JOIN + GROUP BY + HAVING
-- =============================================
SELECT 
    l.precinct,
    l.borough,
    COUNT(*) AS total_violations,
    SUM(v.fine_amount) AS total_fines,
    ROUND(AVG(v.fine_amount), 2) AS avg_fine
FROM violations v
JOIN locations l ON v.precinct = l.precinct
GROUP BY l.precinct, l.borough
HAVING total_violations > 500
ORDER BY total_violations DESC;

-- =============================================
-- QUERY 14: Year over year ticket comparison
-- Concept: YEAR() function + GROUP BY
-- =============================================
SELECT 
    YEAR(issue_date) AS year,
    COUNT(*) AS total_tickets,
    SUM(fine_amount) AS total_revenue
FROM violations
WHERE issue_date IS NOT NULL
GROUP BY YEAR(issue_date)
ORDER BY year;

-- =============================================
-- QUERY 15: Full violation detail report
-- Concept: 3-table JOIN + ORDER BY
-- =============================================
SELECT 
    v.violation_id,
    v.plate_number,
    v.state,
    v.vehicle_make,
    v.vehicle_color,
    v.issue_date,
    vc.description AS violation_type,
    vc.penalty_amount,
    l.borough,
    l.precinct,
    v.status
FROM violations v
JOIN violation_codes vc ON v.violation_code = vc.violation_code
JOIN locations l ON v.precinct = l.precinct
ORDER BY v.issue_date DESC
LIMIT 50;