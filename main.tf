module "network" {
  source   = "./modules/network"
  vpc_cidr = "10.10.0.0/16"

  azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
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
      tcp_ingress_ports       = [22]
      udp_ingress_ports       = []
      allowed_cidr_blocks     = var.allowed_cidr_blocks
      allowed_security_groups = []
    }
    lb_health_check_sg = {
      name                    = "lb_health_check_sg"
      tcp_ingress_ports       = [80, 443]
      udp_ingress_ports       = []
      allowed_cidr_blocks     = ["0.0.0.0/0"]
      allowed_security_groups = []
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

module "bastion_instance" {
  source             = "./modules/instance"
  instance_name      = "bastion"
  instance_type      = "t3.micro"
  volume_size        = 8
  subnet_id          = module.network.public_subnet_ids[0]
  ssh_key_path       = var.ssh_key_path
  security_group_ids = [module.security_group.sg_ids["bastion_sg"]]
  ami_id             = data.aws_ami.ubuntu.id
}

module "alb" {
  source = "./modules/alb"
  security_group_id = [module.security_group.sg_ids["lb_health_check_sg"]]
  subnet_ids        = module.network.public_subnet_ids
  vpc_id            = module.network.vpc_id
}

module "asg" {
  source = "./modules/asg"
  image_id            = data.aws_ami.ubuntu.id
  instance_type       = "t3.micro"
  vpc_zone_identifier = module.network.private_subnet_ids
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  lb_target_group_arn = module.alb.target_group_arn
  security_group_ids  = [module.security_group.sg_ids["lb_health_check_sg"]]
}

### us-east-1
### s3 encryption