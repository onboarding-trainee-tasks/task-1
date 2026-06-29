resource "aws_key_pair" "this" {
  key_name   = "terraform-key"
  public_key = file("${var.ssh_key_path}")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name = aws_key_pair.this.key_name



  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "${var.instance_name}"
  }
}