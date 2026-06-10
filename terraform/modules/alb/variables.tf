variable "alb_security_group_id" {
  description = "Security group ID for the load balancer"
  type        = string
}

variable "public_subnet_id0" {
  description = "Public subnet ID for the load balancer"
  type        = string
}

variable "public_subnet_id1" {
  description = "Public subnet ID for the load balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "environment" {
  description = "Environment tag"
  default     = "dev"
  type        = string
}
