provider "aws" {
  region = var.region
}

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*20*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = file("add-ssh-web-app.yaml")
}

resource "aws_instance" "hashicups-backend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnets[0]
  vpc_security_group_ids      = [data.terraform_remote_state.network.outputs.hashicups_security_group_id]
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered

  tags = {
    Name = "hashicups-backend-${var.pull_request_id}"
  }
}