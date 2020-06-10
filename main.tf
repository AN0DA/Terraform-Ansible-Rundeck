provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#Create Key Pair
resource "aws_key_pair" "key" {
  key_name   = "MyKeyPair"
  public_key = file(var.public_key)
}

# Ubuntu 20.04 server
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "rundeck_dev" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name

# TODO: REMOVE EXCESS OPEN PORTS!!!
  vpc_security_group_ids = [
    aws_security_group.web.id,
    aws_security_group.ssh.id,
    aws_security_group.egress-tls.id,
    aws_security_group.ping-ICMP.id,
	aws_security_group.web_server.id
  ]


  provisioner "remote-exec" {
      inline = ["echo ssh OK", ]
       connection {
         host = aws_instance.rundeck_dev.public_ip
    private_key = file(var.private_key)
    user        = var.ansible_user
  }
  }

  # This is where we configure the instance with ansible-playbook
  # Rundeck requires Java to be installed 
  # $1 - ${aws_instance.rundeck_dev.public_ip} / $2 - ${var.ansible_user} / $3 - ${var.private_key}
  provisioner "local-exec" {
	  command = "chmod +x ./install_rundeck.sh && bash ./install_rundeck.sh ${aws_instance.rundeck_dev.public_ip} ${var.ansible_user} ${var.private_key}"
  }

    tags = {
    Name = "rundeck_dev"
  }
}





resource "aws_security_group" "web" {
  name        = "default-web-example"
  description = "Security group for web that allows web traffic from internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "default-ssh-example"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "egress-tls" {
  name        = "default-egress-tls-example"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ping-ICMP" {
  name        = "default-ping-example"
  description = "Default security group that allows to ping the instance"

  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Allow the web app to receive requests on port 8080
resource "aws_security_group" "web_server" {
  name        = "default-web_server-example"
  description = "Default security group that allows to use port 8080"
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}