resource "aws_key_pair" "this" {
  key_name   = "terraform-key"
  public_key = file("${var.ssh_key_path}")
}

resource "aws_instance" "this" {
  ami           = var.ami_id
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