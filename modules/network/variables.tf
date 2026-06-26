variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "A map of subnets with their CIDR blocks and availability zones"
  type = map(object({
    cidr = string
    az   = string
    type = string
  }))
}