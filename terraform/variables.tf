variable "project" {
  type    = string
  default = "url-shortener"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "ami_id" {
  type    = string
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2 us-east-1
}

variable "key_name" {
  type    = string
  default = "url-shortener-key"
}
