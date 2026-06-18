variable "project"           { type = string }
variable "ami_id"            { type = string }
variable "key_name"          { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "bastion_sg_id"     { type = string }
variable "backend_sg_id"     { type = string }
variable "frontend_sg_id"    { type = string }
