
output "public-ip" {
  description = "Public IP"
  value       = aws_instance.docker.public_ip
}
