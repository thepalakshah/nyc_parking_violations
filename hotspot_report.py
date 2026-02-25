import mysql.connector
from datetime import datetime

# Connect to RDS
conn = mysql.connector.connect(
    host='parking-violations-db.c7440qy0mghz.us-east-2.rds.amazonaws.com',
    user='admin',
    password='Palakshah1907',
    database='parking_violations_db'
)

cursor = conn.cursor()

print('=========================================')
print('  NYC PARKING VIOLATIONS HOTSPOT REPORT')
print(f'  Generated: {datetime.now()}')
print('=========================================')

# Query 1 - Top violation hotspots
print('\n TOP 5 VIOLATION HOTSPOTS:')
cursor.execute("""
    SELECT borough, COUNT(*) AS total, SUM(fine_amount) AS revenue
    FROM violations
    GROUP BY borough
    ORDER BY total DESC
    LIMIT 5
""")
for row in cursor.fetchall():
    print(f'  {row[0]:<15} Tickets: {row[1]:<8} Revenue: ${row[2]:,.2f}')

# Query 2 - Unpaid violations alert
print('\n UNPAID VIOLATIONS ALERT:')
cursor.execute("""
    SELECT borough, COUNT(*) AS unpaid, SUM(fine_amount) AS owed
    FROM violations
    WHERE status = 'OPEN'
    GROUP BY borough
    ORDER BY owed DESC
""")
for row in cursor.fetchall():
    print(f'  {row[0]:<15} Unpaid: {row[1]:<8} Owed: ${row[2]:,.2f}')

# Query 3 - Top violation types
print('\n TOP 5 VIOLATION TYPES:')
cursor.execute("""
    SELECT vc.description, COUNT(*) AS total
    FROM violations v
    JOIN violation_codes vc ON v.violation_code = vc.violation_code
    GROUP BY vc.description
    ORDER BY total DESC
    LIMIT 5
""")
for row in cursor.fetchall():
    print(f'  {row[0]:<40} Count: {row[1]}')

print('\n=========================================')
print('  END OF REPORT')
print('=========================================')

cursor.close()
conn.close()