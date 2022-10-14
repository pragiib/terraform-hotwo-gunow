terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# Get current spot instances pricing
data "aws_ec2_spot_price" "current" {
  instance_type     = "t3.micro"
  availability_zone = "eu-central-1a"

  filter {
    name   = "product-description"
    values = ["Linux/UNIX"]
  }
}

# Configure Security group
resource "aws_security_group" "allow_ports" {
  name        = "allow_ports"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Request a spot instance
resource "aws_spot_instance_request" "worker" {
  ami                    = "ami-0caef02b518350c8b"
  spot_price             = data.aws_ec2_spot_price.current.spot_price + data.aws_ec2_spot_price.current.spot_price * 0.05
  instance_type          = "t3.micro"
  spot_type              = "one-time"
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  key_name               = "roma-pidr"
  user_data              = file("user_data.sh")
}

# Configure EC2 instance
#resource "aws_instance" "web" {
#  ami             = "ami-0caef02b518350c8b"
#  instance_type   = "t3.micro"
#  vpc_security_group_ids = [aws_security_group.allow_ports.id]
#  key_name = "roma-pidr"
#
#  user_data       = file("user_data.sh")
#}
