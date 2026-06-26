variable allowed_cidr_blocks {
  description = "A list of allowed CIDR blocks for the security group"
  type        = list(string)
}

variable sg_id {
  description = "The ID of the security group"
  type        = string
}