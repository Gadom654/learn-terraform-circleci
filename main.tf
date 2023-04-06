resource "aws_instance" "flask" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "my-key"
  vpc_security_group_ids = [aws_security_group.flask.id]

  subnet_id = aws_subnet.public.id

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install python3-pip",
      "sudo pip3 install flask",
    ]
  }

  tags = {
    Name = "flask"
  }
}

resource "aws_instance" "apache" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "my-key"
  vpc_security_group_ids = [aws_security_group.apache.id]

  subnet_id = aws_subnet.public.id

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install httpd",
    ]
  }

  tags = {
    Name = "apache"
  }
}