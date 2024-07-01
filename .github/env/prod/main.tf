
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "first" {
  id = element(data.aws_subnets.default.ids, 0)
}

resource "aws_security_group" "app_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  ingress {
    from_port   = 1337
    to_port     = 1337
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
    Name = "strapi-sg"
  }
}

resource "aws_instance" "shubh-strapi" {
  ami                    = "ami-01b1be742d950fb7f"  # Ensure this AMI ID is correct for your region
  instance_type          = "t3.medium"
  subnet_id              = data.aws_subnet.first.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = "shubham_prvt"

  user_data = file("user_data.sh")

  tags = {
    Name = "shubh-app"
  }
}


