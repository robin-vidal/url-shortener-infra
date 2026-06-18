resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.project}/db/host"
  type  = "String"
  value = var.db_host
  tags  = { Name = "${var.project}-db-host" }
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.project}/db/name"
  type  = "String"
  value = var.db_name
  tags  = { Name = "${var.project}-db-name" }
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/${var.project}/db/user"
  type  = "String"
  value = var.db_user
  tags  = { Name = "${var.project}-db-user" }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.project}/db/password"
  type  = "SecureString"
  value = var.db_password
  tags  = { Name = "${var.project}-db-password" }
}
