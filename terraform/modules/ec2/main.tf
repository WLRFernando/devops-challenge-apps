data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ec2-sg" {
  name        = "${var.name}-sg"
  description = "${var.name}-ec2 security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
 tags = {
    Name = "${var.name}-sg"
  } 
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file(var.public_key)
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  security_groups = [ resource.aws_security_group.ec2-sg.id ]
  associate_public_ip_address = true
  key_name = resource.aws_key_pair.ssh_key.key_name

  tags = {
    Name = var.name
  }
}