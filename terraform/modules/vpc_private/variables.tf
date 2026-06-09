
variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
  description = "List of availability zones."
}

variable "vpc_cidr" {
  type        = string
  default     = "172.32.0.0/16"
  description = "CIDR block for the private VPC."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["172.32.1.0/24", "172.32.2.0/24"]
  description = "CIDR blocks for public subnets (ALB + NAT)."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["172.32.3.0/24", "172.32.4.0/24"]
  description = "CIDR blocks for private subnets (App AZ-1a + AZ-1b)."
}

variable "vpc_name" {
  type        = string
  default     = "private-vpc"
  description = "Name for the private VPC."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment for the VPC."
}
