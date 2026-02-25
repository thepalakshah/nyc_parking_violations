# =============================================
# NYC Parking Violations Monitoring System
# Terraform Infrastructure as Code
# Provisions: S3 + EC2 + RDS + Security Groups
# =============================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# =============================================
# Provider — AWS Region
# =============================================
provider "aws" {
  region = "us-east-2"  # Ohio — same as your RDS
}

# =============================================
# S3 Bucket — Portfolio Dashboard
# =============================================
resource "aws_s3_bucket" "dashboard" {
  bucket = "nyc-parking-violations-dashboard"

  tags = {
    Name    = "NYC Parking Dashboard"
    Project = "parking-violations"
  }
}

resource "aws_s3_bucket_website_configuration" "dashboard" {
  bucket = aws_s3_bucket.dashboard.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "dashboard" {
  bucket = aws_s3_bucket.dashboard.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# =============================================
# Security Group — EC2
# Allows SSH + HTTP access
# =============================================
resource "aws_security_group" "ec2_sg" {
  name        = "parking-ec2-sg"
  description = "Security group for parking violations EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name    = "parking-ec2-sg"
    Project = "parking-violations"
  }
}

# =============================================
# Security Group — RDS
# Allows MySQL access from EC2
# =============================================
resource "aws_security_group" "rds_sg" {
  name        = "parking-rds-sg"
  description = "Security group for parking violations RDS"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
    description     = "MySQL from EC2"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "MySQL from anywhere (dev only)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "parking-rds-sg"
    Project = "parking-violations"
  }
}

# =============================================
# EC2 Instance — Application Server
# Runs Python hotspot detection script
# =============================================
resource "aws_instance" "app_server" {
  ami = "ami-00e428798e77d38d9" # Amazon Linux 2023 Ohio
  instance_type = "t3.micro"               # Free tier

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name    = "parking-violations-server"
    Project = "parking-violations"
  }
}

# =============================================
# RDS MySQL Instance — Database Layer
# Stores 78,000+ NYC parking violation records
# =============================================
resource "aws_db_instance" "mysql" {
  identifier        = "parking-violations-tf"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"       # Free tier
  allocated_storage = 20

  db_name  = "parking_violations_db"
  username = "admin"
  password = "Palakshah1907"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  tags = {
    Name    = "parking-violations-db"
    Project = "parking-violations"
  }
}

# =============================================
# Outputs — show important values after apply
# =============================================
output "ec2_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "EC2 Public IP address"
}

output "rds_endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "RDS MySQL endpoint"
}

output "s3_website_url" {
  value       = aws_s3_bucket_website_configuration.dashboard.website_endpoint
  description = "S3 Dashboard URL"
}