# EC2 Public Server

resource "aws_instance" "lms-web-server" { 
  count = 3
  ami           = "ami-0e001c9271cf7f3b9" # Ubuntu AMI 
  instance_type = "t2.micro"
  subnet_id = aws_subnet.lms-pub-sn.id
  key_name = "krishna"
  vpc_security_group_ids = [aws_security_group.lms-pub-sg.id]

  tags = {
    Name = "lms-web-${count.index}"
  }
}
