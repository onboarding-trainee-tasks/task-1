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