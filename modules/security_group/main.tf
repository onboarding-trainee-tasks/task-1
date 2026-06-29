resource "aws_security_group" "this" {
  for_each = var.security_groups
  vpc_id = var.vpc_id
  name = each.key

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = each.value.name
  }
}

locals {
  sg_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for port in sg.ingress_ports : {
        sg_name    = sg_name
        name       = sg.name
        port       = port
        type       = sg.type
        protocol   = sg.protocol
        cidrs      = sg.allowed_cidr_blocks
      }
    ]
  ])
  sg_rules_map = {
    for idx, rule in local.sg_rules :
    "${rule.sg_name}-${rule.port}" => rule
  }
}

resource "aws_security_group_rule" "this" {
  for_each = local.sg_rules_map

  security_group_id = aws_security_group.this[each.value.sg_name].id
  type              = each.value.type
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidrs
}