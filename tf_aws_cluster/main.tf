provider "aws" {
  region     = var.region
}

resource "random_pet" "suffix" {
  length = 1
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_${random_pet.suffix.id}"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "kitchen_pub_key" {
  key_name   = "kitchen-pub-key_${random_pet.suffix.id}"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "example" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = aws_key_pair.kitchen_pub_key.key_name
  security_groups = [aws_security_group.allow_ssh.name]
    tags = {
    Name = "kitchen-instance_${random_pet.suffix.id}"
  }

}
