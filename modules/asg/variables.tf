variable "image_id" {
  description = "The ID of the AMI to use for the instances."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use."
  type        = string
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs for the ASG to launch instances in."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the instances."
  type        = list(string)
}

variable "key_name" {
  description = "The name of the key pair to use for the instances."
  type        = string
}

variable "min_size" {
  description = "The minimum size of the ASG."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum size of the ASG."
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The desired capacity of the ASG."
  type        = number
  default     = 2
}

variable "lb_target_group_arn" {
  description = "The ARN of the target group to attach to the ASG."
  type        = string
}