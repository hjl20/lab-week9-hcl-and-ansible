packer {
  required_plugins {
    # COMPLETE ME
    # add necessary plugins for ansible and aws
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
    amazon = {
      version = ">= 1.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  # COMPLETE ME
  # add configuration to use Ubuntu 24.04 image as source image
  # adapted from lab6
  ami_name      = "web-nginx-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  # - use the ssh user-name specified in the "variables.pkr.hcl" file
  ssh_username = "${var.ssh_username}"
}

build {
  # COMPLETE ME
  # add configuration to: 
  # - use the source image specified above
  # also adapted from lab6
  name = "web-nginx"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  # - use the "ansible" provisioner to run the playbook in the ansible directory
  provisioner "shell" {
    inline = ["export ANSIBLE_HOST_KEY_CHECKING=False"]
  }
  provisioner "ansible" {
    playbook_file = "../ansible/playbook.yml"
  }
}
