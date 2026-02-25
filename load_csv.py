import pandas as pd
import mysql.connector

# Load CSV
df = pd.read_csv(r'F:\NYC_Parking_Violations\parking_sample.csv', nrows=10000)

# Clean column names
df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_').str.replace('-', '_')

# Connect to MySQL
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='123456', 
    database='parking_violations_db'
)

# Load into violations_raw
df.to_sql is not None  # just a check

cursor = conn.cursor()

# Insert row by row
inserted = 0
for _, row in df.iterrows():
    try:
        cursor.execute("""
            INSERT INTO violations_raw (
                summons_number, plate_id, registration_state, plate_type,
                issue_date, violation_code, vehicle_body_type, vehicle_make,
                issuing_agency, street_code1, street_code2, street_code3,
                vehicle_expiration_date, violation_location, violation_precinct,
                issuer_precinct, issuer_code, issuer_command, issuer_squad,
                violation_time, time_first_observed, violation_county,
                violation_in_front_of_or_opposite, house_number, street_name,
                intersecting_street, date_first_observed, law_section,
                sub_division, violation_legal_code, days_parking_in_effect,
                from_hours_in_effect, to_hours_in_effect, vehicle_color,
                unregistered_vehicle, vehicle_year, meter_number, feet_from_curb,
                violation_post_code, violation_description,
                no_standing_or_stopping_violation, hydrant_violation,
                double_parking_violation
            ) VALUES (
                %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,
                %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,
                %s,%s,%s
            )
        """, tuple(str(v) if pd.notna(v) else None for v in row))
        inserted += 1
        if inserted % 1000 == 0:
            print(f'{inserted} rows inserted...')
    except Exception as e:
        pass

conn.commit()
cursor.close()
conn.close()
print(f'Done! Total rows inserted: {inserted}')