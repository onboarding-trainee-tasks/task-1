resource "aws_key_pair" "this" {
  key_name   = "t1-terraform-key"
  public_key = file(pathexpand(var.ssh_key_path))
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = aws_key_pair.this.key_name

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "${var.instance_name}"
  }

  iam_instance_profile = var.iam_instance_profile
  user_data = templatefile(var.user_data, {
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_ENDPOINT = var.db_endpoint
    DB_NAME     = var.db_name
  })
}