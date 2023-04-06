provider "aws" {
  region = "eu-central-1"
}
# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

# Create subnet for Flask server
resource "aws_subnet" "web_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.vpc.id
}

resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "web_subnet_association" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.vpc_route_table.id
}
# Definiujemy grupę bezpieczeństwa
resource "aws_security_group" "web" {
  name_prefix = "web_"
  vpc_id      = aws_vpc.vpc.id
  
  # Otwieramy port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Otwieramy port 22 tylko dla połączeń z wewnętrznej sieci
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  # Otwieramy port 5000 tylko dla połączeń z wewnętrznej sieci
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }
  
  # Otwieramy port 80 między serwerami
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.apache.id]
  }

  # Otwieramy port 5000 między serwerami
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    security_groups = [aws_security_group.flask.id]
  }
  
  # Zamykamy port 22 z publicznej sieci
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Definiujemy regułę dla serwera Apache
resource "aws_security_group" "apache" {
  name_prefix = "apache_"
  vpc_id      = aws_vpc.vpc.id
}

# Definiujemy regułę dla serwera Flask
resource "aws_security_group" "flask" {
  name_prefix = "flask_"
  vpc_id      = aws_vpc.vpc.id
}

# Definujemy nazwę dla klucza publicznego
resource "aws_key_pair" "key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create EC2 instance for Apache server
resource "aws_instance" "apache" {
  ami           = "ami-0fa03365cde71e0ab"
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = aws_subnet.web_subnet.id
  vpc_security_group_ids = [
    aws_security_group.web.id,
    aws_security_group.apache.id,
    ]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}

# Create EC2 instance for Flask server
resource "aws_instance" "flask" {
  ami           = "ami-0fa03365cde71e0ab"
  instance_type = "t2.micro"
  key_name      = "my-key"
  subnet_id     = aws_subnet.web_subnet.id
  vpc_security_group_ids = [
    aws_security_group.web.id,
    aws_security_group.flask.id,
    ]
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y python3
              sudo yum install -y python3-pip
              sudo pip3 install flask
              echo 'export FLASK_APP=app.py' >> ~/.bashrc
              source ~/.bashrc
              EOF
  tags = {
    Name = "flask-server"
  }
}
output "public_ip" {
  value = aws_instance.apache.public_ip
}