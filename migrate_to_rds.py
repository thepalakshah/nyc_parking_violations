import mysql.connector

# Local connection
local = mysql.connector.connect(
    host='localhost',
    user='root',
    password='123456',
    database='parking_violations_db'
)

# RDS connection
rds = mysql.connector.connect(
    host='parking-violations-db.c7440qy0mghz.us-east-2.rds.amazonaws.com',
    user='admin',
    password='Palakshah1907',
    database='parking_violations_db'
)

local_cursor = local.cursor()
rds_cursor = rds.cursor()

# Step 1 - Migrate violation_codes
print('Migrating violation_codes...')
local_cursor.execute('SELECT * FROM violation_codes')
rows = local_cursor.fetchall()
rds_cursor.executemany('INSERT IGNORE INTO violation_codes VALUES (%s,%s,%s)', rows)
rds.commit()
print(f'{len(rows)} rows migrated')

# Step 2 - Migrate locations
print('Migrating locations...')
local_cursor.execute('SELECT * FROM locations')
rows = local_cursor.fetchall()
rds_cursor.executemany('INSERT IGNORE INTO locations VALUES (%s,%s)', rows)
rds.commit()
print(f'{len(rows)} rows migrated')

# Step 3 - Migrate violations
print('Migrating violations...')
local_cursor.execute('SELECT * FROM violations')
rows = local_cursor.fetchall()
rds_cursor.executemany(
    'INSERT IGNORE INTO violations VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',
    rows
)
rds.commit()
print(f'{len(rows)} rows migrated')

# Step 4 - Migrate payments
print('Migrating payments...')
local_cursor.execute('SELECT * FROM payments')
rows = local_cursor.fetchall()
rds_cursor.executemany(
    'INSERT IGNORE INTO payments VALUES (%s,%s,%s,%s)',
    rows
)
rds.commit()
print(f'{len(rows)} rows migrated')

local_cursor.close()
rds_cursor.close()
local.close()
rds.close()
print('Migration complete!')