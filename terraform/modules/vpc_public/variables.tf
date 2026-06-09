
variable "vpc_bastion_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "CIDR block for the bastion VPC."
}

variable "vpc_bastion_name" {
  type        = string
  default     = "bastion-vpc"
  description = "Name for the bastion VPC."
}


variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment for the VPC."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["192.168.1.0/24"]
  description = "CIDR block for the public subnet."
}


variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
  description = "List of availability zones."
}
