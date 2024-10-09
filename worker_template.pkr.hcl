data "amazon-ami" "base-ami" {
  filters = {
    virtualization-type = "hvm"
    name                = "al2023-ami-2023.5.20240916.0-*"
    root-device-type    = "ebs"
  }
  owners      = ["137112412989"]
  most_recent = true
}

variable "imageName" {
  default = "jenkins-worker1"
}


variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "access_key" {
  description = "AWS access_key"
  default     = "AKIAQWC7OMED2NYWBQF5"
  type        = string
}

variable "secret_key" {
  default = "zxLJ43eNHSAGptuvuPZbeHWbJJzkDlPC7kVN0l+4"
}


variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}


source "amazon-ebs" "Jenkins-worker" {
  access_key      = var.access_key
  secret_key      = var.secret_key
  region          = var.region
  source_ami      = "${data.amazon-ami.base-ami.id}"
  ssh_username    = "ec2-user"
  ami_name        = "${var.imageName}-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  instance_type   = var.instance_type
  ami_description = "Jenkins worker's AMI"
  run_tags = {
    Name = "packer-builder"
  }
}
build {
  sources = ["source.amazon-ebs.Jenkins-worker"]


  provisioner "shell" {
    script          = "C:/Users/Abdul Musavvir/Desktop/Jenkins-project/Packer-Jenkins/setup_worker.sh"
    execute_command = "sudo -E -S sh '{{ .Path }}'"
  }
}
