variable vpc_id {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable security_groups {
  description = "A map of security groups to create"
  type = map(object({
    name          = string
    type          = string ###
    ingress_ports = list(number)
    protocol      = string
    allowed_cidr_blocks = list(string)
    allowed_security_groups = list(string)
  }))
}