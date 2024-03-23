variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"  # Set your preferred region
}

variable "project_name" {
  default = "sistema-pedidos"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "db_name" {
  description = "Name for the RDS database"
  default     = "sistema-pedidos"
}

variable "db_username" {
  description = "Username for the RDS database"
  default     = "sistema_pedidos_user"
}

variable "db_password" {
  description = "Password for the RDS database"
  default     = "admin123"
}
