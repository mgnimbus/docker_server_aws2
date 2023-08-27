provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "randy" {
  length = 1
}

resource "aws_instance" "docker" {
  ami                  = "ami-08a52ddb321b32a8c"
  instance_type        = "t2.small"
  availability_zone    = "us-east-1a"
  key_name             = "tfkey"
  user_data            = file("${path.module}/scripts/install_docker_app.sh")
  security_groups      = [aws_security_group.docker_sg.name]
  iam_instance_profile = aws_iam_instance_profile.docker_profile.name
  tags = {
    Name = "cloudnimbus-docker-${random_pet.randy.id}"
  }
}

resource "aws_security_group" "docker_sg" {
  name        = "docker-sg-${random_pet.randy.id}"
  description = "Allow all inbound & outbound traffic"
  vpc_id      = "vpc-0aa0cdbe4c44c04a3"

  ingress {
    description = "allow traffic from internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_traffic_-${random_pet.randy.id}"
  }
}
