# PUBLIC SECUIRTY GROUP 
resource "aws_security_group" "lms-pub-sg" {
    name = "lms-pub-server-sg"
    description = "Allows pub Server Traffic"
    vpc_id = aws_vpc.lms-vpc.id
    
    tags = {
        Name = "lms-pub-secuirty-group"
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }

    
}

# SSH TRAFFIC 
resource "aws_vpc_security_group_ingress_rule" "lms-pub-ssh" {
  security_group_id = aws_security_group.lms-pub-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# HTTP TRAFFIC 
resource "aws_vpc_security_group_ingress_rule" "lms-http-ssh" {
  security_group_id = aws_security_group.lms-pub-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# ALL TRAFFIC 
resource "aws_vpc_security_group_ingress_rule" "allow_all" {
  security_group_id = aws_security_group.lms-pub-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}




