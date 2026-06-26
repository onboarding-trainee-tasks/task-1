resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr
  availability_zone_id = var.azs[(tonumber(regex("[0-9]+", each.key)) - 1) % length(var.azs)]

  map_public_ip_on_launch = each.value.type == "public"

  tags = {
    Name = "${each.key}"
    Type = "${each.value.type}"
  }
}