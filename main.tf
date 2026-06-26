data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

# resource "aws_instance" "bastion" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
# }

module "network" {
  source = "./modules/network"
  vpc_cidr = "10.10.0.0/16"
  subnets = {
    public_subnet_a = {
      cidr = "10.10.1.0/24"
      az   = "euc1-az1"
      type = "public"
    }
    public_subnet_b = {
      cidr = "10.10.2.0/24"
      az   = "euc1-az2"
      type = "public"
    }
    private_subnet_a = {
      cidr = "10.10.3.0/24"
      az   = "euc1-az1"
      type = "private"
    }
    private_subnet_b = {
      cidr = "10.10.4.0/24"
      az   = "euc1-az2"
      type = "private"
    }
    database_subnet_a = {
      cidr = "10.10.5.0/24"
      az   = "euc1-az1"
      type = "database"
    }
    database_subnet_b = {
      cidr = "10.10.6.0/24"
      az   = "euc1-az2"
      type = "database"
    }
  }
}

module "instance" {
  source = "./modules/instance"
  # ...
}

module "security_group" {
  source = "./modules/security_group"
  # ...
}