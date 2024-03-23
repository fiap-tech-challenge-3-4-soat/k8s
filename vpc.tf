resource "aws_vpc" "sistema-pedidos_vpc" {
  cidr_block = "10.0.0.0/16" # Update with your VPC CIDR block
  tags = {
    Name = "${var.project_name}_vpc"
  }
}

resource "aws_subnet" "sistema-pedidos_subnet_a" {
  vpc_id            = aws_vpc.sistema-pedidos_vpc.id
  cidr_block        = "10.0.1.0/24" # Update with your subnet CIDR block
  availability_zone = "us-east-1a" # Update with your desired AZ
  tags = {
    Name = "${var.project_name}_subnet"
  }
}

resource "aws_subnet" "sistema-pedidos_subnet_b" {
  vpc_id            = aws_vpc.sistema-pedidos_vpc.id
  cidr_block        = "10.0.2.0/24" # Update with your subnet CIDR block
  availability_zone = "us-east-1b" # Update with your desired AZ
  
  tags = {
    Name = "${var.project_name}_subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "sistema-pedidos_igw" {
  vpc_id = aws_vpc.sistema-pedidos_vpc.id
  
  tags = {
    Name = "${var.project_name}_igw"
  }

  depends_on = [aws_vpc.sistema-pedidos_vpc]
}

# Attach internet gateway to VPC
resource "aws_internet_gateway_attachment" "sistema-pedidos_igw_attachment" {
  vpc_id       = aws_vpc.sistema-pedidos_vpc.id
  internet_gateway_id = aws_internet_gateway.sistema-pedidos_igw.id
  depends_on = [aws_internet_gateway.sistema-pedidos_igw]
}


resource "aws_security_group" "sistema-pedidos_security_group" {
  vpc_id = aws_vpc.sistema-pedidos_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_security_group"
  }
}