variable "instance_type" {
  description = "The type of instance to create"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the instance"
  type        = list(string)
}

variable "volume_size" {
  description = "The size of the root volume in GB"
  type        = number
}

variable "ssh_key_path" {
  description = "The path to the SSH private key for connecting to the instance"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the instance"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "db_endpoint" {
  description = "The endpoint of the database"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "user_data" {
  description = "The user data script to run on instance launch"
  type        = string
}