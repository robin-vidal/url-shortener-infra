resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = { Name = "${var.project}-db-subnet-group" }
}

resource "aws_db_instance" "main" {
  identifier           = "${var.project}-db"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot  = true
  publicly_accessible  = false
  tags                 = { Name = "${var.project}-db" }
}
