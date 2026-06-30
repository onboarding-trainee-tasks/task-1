output "public_ip" {
  description = "The public IP of the instance"
  value       = aws_instance.this.public_ip
}