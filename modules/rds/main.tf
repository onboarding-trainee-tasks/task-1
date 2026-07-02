resource "aws_db_subnet_group" "this" {
  name = "rds-subnet-group"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16"
  username               = var.db_username
  password               = var.db_password # temporary without secret manager
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot = true
}

# resource "aws_db_instance" "replica" {
#   instance_class         = "db.t3.micro"
#   allocated_storage      = 5
#   db_subnet_group_name   = aws_db_subnet_group.this.name
#   replicate_source_db    = aws_db_instance.this.id

#   skip_final_snapshot = true
# }