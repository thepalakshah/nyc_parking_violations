# NYC Parking Violations Monitoring System

A cloud-based IT operations project built to demonstrate database administration, cloud infrastructure, automation, and Infrastructure as Code skills.

Built using real NYC government data from Kaggle — Fiscal Year 2017.

---

## Live Links

- **Dashboard:** http://nyc-parking-violations-dashboard.s3-website.us-east-2.amazonaws.com
- **GitHub:** https://github.com/thepalakshah/nyc_parking_violations

---

## Project Overview

This project simulates a real-world IT Operations monitoring system for NYC parking violations. It covers the full stack from database design to cloud deployment and automated reporting.

**Dataset:** NYC Parking Violations Issued — Fiscal Year 2017 (Kaggle)  
**Records:** 78,164 violations across 5 NYC boroughs  
**Schema:** 4 normalized tables — violations, violation_codes, locations, payments

---

## Key Findings

| Borough | Tickets | Revenue |
|---|---|---|
| Manhattan | 30,948 | $1,906,900 |
| Queens | 12,395 | $685,885 |
| Brooklyn | 7,917 | $460,565 |
| Bronx | 7,435 | $413,775 |
| Staten Island | 1,139 | $60,005 |

- Top violation: School Zone Speed (25,736 tickets)
- NY plates account for 78.3% of all violations
- Total unpaid fines: $4.4M across all boroughs
- Most ticketed brand: Toyota (9,842 tickets)

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Oracle Live SQL | PL/SQL stored procedures, triggers, cursors |
| MySQL Workbench | Local database + 15 SQL queries |
| AWS RDS MySQL | Cloud database — 78,164 rows live on cloud |
| AWS EC2 | Python hotspot detection script server |
| AWS S3 | Static dashboard website hosting |
| Terraform | Full AWS environment as Infrastructure as Code |
| AWS CloudWatch | CPU + storage monitoring alarms |
| Python | Automated violation hotspot report |

---

## Architecture

```
Internet → S3 Dashboard → EC2 (Python) → RDS MySQL → CloudWatch
           
           All AWS infrastructure provisioned with Terraform
```

---

## Project Structure

```
nyc_parking_violations/
│
├── Oracle/
│   ├── Create_table.sql          # Oracle table definitions
│   ├── insert_data.sql           # Sample data for PL/SQL demo
│   ├── Procedure 1.sql           # Get violations by plate number
│   ├── Procedure 2.sql           # Process payment + update status
│   ├── 3_TRIGGER.sql             # Auto-update status on payment
│   └── 4_CURSOR.sql              # Loop through unpaid violations
│
├── RDS/
│   └── 01_create_tables.sql      # RDS MySQL schema
│
├── terraform/
│   └── main.tf                   # Full AWS infrastructure as code
│
├── 01_create_tables.sql          # MySQL local schema (4 tables)
├── 02_load_data.sql              # Data loading + transformation
├── 03_sql_queries.sql            # 15 SQL queries (joins, subqueries, CASE)
├── hotspot_report.py             # Python script running on EC2
├── migrate_to_rds.py             # Local MySQL to RDS migration
├── load_csv.py                   # CSV data loader
└── index.html                    # S3 hosted dashboard
```

---

## Database Schema

```
violation_codes     violation_id (PK)
                    description
                    penalty_amount

locations           precinct (PK)
                    borough

violations          violation_id (PK)
                    plate_number
                    state
                    issue_date
                    violation_code (FK)
                    vehicle_make
                    fine_amount
                    borough
                    precinct (FK)
                    status

payments            payment_id (PK)
                    violation_id (FK)
                    payment_date
                    amount_paid
```

---

## SQL Queries Covered

- Basic SELECT, WHERE, ORDER BY
- GROUP BY + HAVING + aggregates (COUNT, SUM, AVG)
- Multi-table JOINs
- Subqueries
- CASE statements
- DATE functions
- 3-table JOIN reports

---

## Oracle PL/SQL

- **Stored Procedure 1** — Look up all violations by plate number
- **Stored Procedure 2** — Process payment and update violation status
- **Trigger** — Auto-update violation status when payment is inserted
- **Cursor** — Loop through unpaid violations and generate report

---

## Python Script (EC2)

Connects to AWS RDS MySQL and generates a live hotspot report:

```
NYC PARKING VIOLATIONS HOTSPOT REPORT
========================================
TOP 5 VIOLATION HOTSPOTS:
  Manhattan       Tickets: 30948    Revenue: $1,906,900
  Queens          Tickets: 12395    Revenue: $685,885
  Brooklyn        Tickets: 7917     Revenue: $460,565
  Bronx           Tickets: 7435     Revenue: $413,775
  Staten Island   Tickets: 1139     Revenue: $60,005
========================================
```

---

## Terraform Infrastructure

Single `terraform apply` command provisions:
- S3 bucket with static website hosting
- EC2 instance (Amazon Linux 2023, t3.micro)
- RDS MySQL instance (db.t3.micro)
- EC2 security group (SSH + HTTP)
- RDS security group (MySQL port 3306)

---

## Author

**Palak Shah**  
GitHub: [@thepalakshah](https://github.com/thepalakshah)