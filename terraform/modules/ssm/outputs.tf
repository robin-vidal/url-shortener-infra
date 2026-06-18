output "db_host_param"     { value = aws_ssm_parameter.db_host.name }
output "db_password_param" { value = aws_ssm_parameter.db_password.name }
