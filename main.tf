data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

# resource "aws_instance" "bastion" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
# }

module "network" {
  source   = "./modules/network"
  vpc_cidr = "10.10.0.0/16"

  azs = ["euc1-az1", "euc1-az2", "euc1-az3"]
  subnets = {
    public_subnet_1 = {
      cidr = "10.10.1.0/24"
      type = "public"
    }
    public_subnet_2 = {
      cidr = "10.10.2.0/24"
      type = "public"
    }
    private_subnet_1 = {
      cidr = "10.10.3.0/24"
      type = "private"
    }
    private_subnet_2 = {
      cidr = "10.10.4.0/24"
      type = "private"
    }
    # private_subnet_3 = {
    #   cidr = "10.10.7.0/24"
    #   type = "private"
    # }
    database_subnet_1 = {
      cidr = "10.10.5.0/24"
      type = "database"
    }
    database_subnet_2 = {
      cidr = "10.10.6.0/24"
      type = "database"
    }
  }
}

module "security_group" {
  source              = "./modules/security_group"
  vpc_id              = module.network.vpc_id
  allowed_cidr_blocks = var.allowed_cidr_blocks

  security_groups = {
    bastion_sg = {
      name                    = "bastion_sg"
      ingress_ports           = [22]
      type                    = "ingress"
      protocol                = "tcp"
      allowed_cidr_blocks     = var.allowed_cidr_blocks
      allowed_security_groups = []
    }
    lb_health_check_sg = {
      name                    = "lb_health_check_sg"
      ingress_ports           = [80, 443]
      type                    = "ingress"
      protocol                = "tcp"
      allowed_cidr_blocks     = var.allowed_cidr_blocks
      allowed_security_groups = []
    }
  }
}

module "instance" {
  source = "./modules/instance"
  # ...
}

