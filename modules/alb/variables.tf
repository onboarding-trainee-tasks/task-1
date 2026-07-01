variable "security_group_id" {
  description = "Security group ID to associate with the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be created"
  type        = string
}