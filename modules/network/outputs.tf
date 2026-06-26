output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [ for subnet in aws_subnet.this : subnet.id if subnet.tags["Type"] == "public" ]
}

output "private_subnet_ids" {
  value = [ for subnet in aws_subnet.this : subnet.id if subnet.tags["Type"] == "private" ]
}

output "database_subnet_ids" {
  value = [ for subnet in aws_subnet.this : subnet.id if subnet.tags["Type"] == "database" ]
}