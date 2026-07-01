variable "allowed_cidr_blocks" {
  description = "A list of allowed CIDR blocks for the security group"
  type        = list(string)
  default     = ["178.212.0.0/16", "195.160.0.0/16"]
}

variable "ssh_key_path" {
  description = "Path to the SSH key pair for EC2 instances"
  type        = string
  default     = "C:\\Onboarding\\.ssh\\terraform-ssh-key.pub"
}