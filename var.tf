variable "aws_region" {
    description = "AWS account region"
    default = "us-east-2"
}

variable "aws_access_key" {
    description = "AWS account access key"
}

variable "aws_secret_key" {
    description = "AWS account secret key"
}

variable "public_key" {
  default = "~/.ssh/MyKeyPair.pub"
}

variable "private_key" {
  default = "~/.ssh/MyKeyPair.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}