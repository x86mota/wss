provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "lab-devops" {
  cidr_block = "10.10.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "Lab-DevOps"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.lab-devops.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.lab-devops.id
  cidr_block = "10.10.10.0/24"
  tags = {
    Name = "private-subnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.lab-devops.id
}

# Define route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.lab-devops.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id 
}

# Create security groups
resource "aws_security_group" "lab-devops-sg-http" {
  name = "http"
  description = "Security group for HTTP"
  vpc_id = aws_vpc.lab-devops.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-http"
  }
}

resource "aws_security_group" "lab-devops-sg-ssh" {
  name = "ssh"
  description = "Security group for SSH"
  vpc_id = aws_vpc.lab-devops.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-ssh"
  }
}

resource "aws_security_group" "lab-devops-sg-wp" {
  name = "wp"
  description = "Security group for Wordpress"
  vpc_id = aws_vpc.lab-devops.id

  tags = {
    Name = "sg-wp"
  }
}

resource "aws_security_group" "lab-devops-sg-mysql" {
  name = "mysql"
  description = "Security group for MySQL"
  vpc_id = aws_vpc.lab-devops.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.lab-devops-sg-wp.id]
  }

  tags = {
    Name = "sg-mysql"
  }
}