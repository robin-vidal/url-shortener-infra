output "alb_dns_name"       { value = module.alb.alb_dns_name }
output "bastion_public_ip"  { value = module.ec2.bastion_public_ip }
output "backend_private_ip" { value = module.ec2.backend_private_ip }
output "frontend_private_ip"{ value = module.ec2.frontend_private_ip }
output "ecr_backend_url"    { value = module.ecr.backend_repo_url }
output "ecr_frontend_url"   { value = module.ecr.frontend_repo_url }
output "account_id"         { value = data.aws_caller_identity.current.account_id }
