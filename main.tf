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
  source = "./modules/security_group"
  vpc_id = module.network.vpc_id

  security_groups = {
    bastion_sg = {
      name                    = "bastion_sg"
      ingress_ports           = [22]
      type                    = "ingress"
      protocol                = "tcp"
      allowed_cidr_blocks     = ["178.212.0.0/16"]
      allowed_security_groups = []
    }
    lb_health_check_sg = {
      name                    = "lb_health_check_sg"
      ingress_ports           = [80, 443]
      type                    = "ingress"
      protocol                = "tcp"
      allowed_cidr_blocks     = ["0.0.0.0/0"]
      allowed_security_groups = []
    }
  }
}

module "bastion_instance" {
  source = "./modules/instance"
  instance_name = "bastion"
  instance_type = "t3.micro"
  volume_size = 8
  subnet_id = module.network.public_subnet_ids[0]
  ssh_key_path = "C:\\Onboarding\\.ssh\\terraform-ssh-key.pub"
  security_group_ids = [module.security_group.sg_ids["bastion_sg"]]
}