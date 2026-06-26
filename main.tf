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

  azs      = ["euc1-az1", "euc1-az2", "euc1-az3"]
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

module "instance" {
  source = "./modules/instance"
  # ...
}

module "security_group" {
  source = "./modules/security_group"
  # ...
}