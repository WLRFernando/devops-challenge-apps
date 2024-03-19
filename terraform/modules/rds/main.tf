resource "aws_security_group" "rds-sg" {
  name_prefix = "rds-sg-"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]
  }
}

resource "aws_db_subnet_group" "subnetgroup" {
  name       = "rds-subnetgroup"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "rds-subnetgroup"
  }
}

resource "aws_db_instance" "rds" {
  engine                 = "postgres"
  engine_version         = "12"
  db_name                = var.db_name
  identifier             = "${var.db_name}-identifier"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true
  db_subnet_group_name   = resource.aws_db_subnet_group.subnetgroup.name

  tags = {
    Name = var.db_name
  }
}

