# packer {
#   required_plugins {
#     amazon = {
#       source  = "github.com/hashicorp/amazon"
#       version = "~> 1"
#     }
#   }
# }

variable "imageName"{
  type = string
  default = "jenkins-master-2.204.1"
}

data "amazon-ami" "base-ami" {
    filters = {
        virtualization-type = "hvm"
        name = "al2023-ami-2023.5.20240916.0-*"
        root-device-type = "ebs"
    }
    owners = ["137112412989"]
    most_recent = true
}



source "amazon-ebs" "Jenkins-Master" {
  access_key = "AKIAQWC7OMED2NYWBQF5"
  secret_key = "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"
#   profile    = "default"
  region     = "us-east-1"
  ami_name = "${var.imageName}-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  ami_description = "Amazon Linux Image with Jenkins Server"
  instance_type = "t2.medium"
  source_ami = "${data.amazon-ami.base-ami.id}"
  ssh_username = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.Jenkins-Master"
  ]

  provisioner "file" {
    source      = "C:/Users/Abdul Musavvir/Desktop/Jenkins-project/Packer-Jenkins/setup.sh"
    destination = "/tmp/setup.sh"
  }
    # Copy additional scripts or config files (if necessary)
  # provisioner "file" {
  #   source      = "C:/Users/Abdul Musavvir/Desktop/Jenkins-project/Packer-Jenkins/scripts"
  #   destination = "/tmp/"
  # }
  # provisioner "file" {
  #   source      = "C:/Users/Abdul Musavvir/Desktop/Jenkins-project/Packer-Jenkins/config"
  #   destination = "/tmp/"
  # }

  provisioner "file" {
    source      = "C:/Users/Abdul Musavvir/Desktop/Jenkins-project/Packer-Jenkins/id_rsa"
    destination = "/tmp/"
  }
  provisioner "shell" {
    inline = [
      "ls -l /tmp/",                      # List files in /tmp
      "cat /tmp/setup.sh || echo 'setup.sh not found!'",  # Check if the file is there
      "chmod +x /tmp/setup.sh",           # Make it executable
      "/tmp/setup.sh"                      # Run the script
    ]
  }
}


# build {
#   sources = [
#     "source.amazon-ebs.Jenkins-Master"
#   ]

#   # First, copy all necessary files to the instance

#   # Copy the setup.sh script to the remote instance
#   provisioner "file" {
#     source = "C:/Users/Abdul Musavvir/Desktop/Jenkins-project/Packer-Jenkins/setup.sh"
#     destination = "/tmp/setup.sh"    # Destination path on the EC2 instance
#   }

#   # Copy additional scripts or config files (if necessary)
#   # provisioner "file" {
#   #   source      = "C:\\Users\\Abdul Musavvir\\Desktop\\Jenkins-project\\Packer-Jenkins\\scripts"
#   #   destination = "/tmp/scripts"
#   # }

#   # provisioner "file" {
#   #   source      = "C:\\Users\\Abdul Musavvir\\Desktop\\Jenkins-project\\Packer-Jenkins\\config"
#   #   destination = "/tmp/config"
#   # }

#   # provisioner "file" {
#   #   source      = "C:\\Users\\Abdul Musavvir\\Desktop\\Jenkins-project\\Packer-Jenkins\\id_rsa"
#   #   destination = "/tmp/id_rsa"
#   # }

#   # # Set proper permissions for the private key file
#   # provisioner "shell" {
#   #   inline = ["chmod 600 /tmp/id_rsa"]
#   # }

#   # # Ensure the setup.sh script has execution permissions
#   # provisioner "shell" {
#   #   inline = ["chmod +x /tmp/setup.sh"]
#   # }

#   # # Add sleep time to allow OS booting (optional)
#   # provisioner "shell" {
#   #   inline = ["sleep 30"]
#   # }

#   # Finally, run the setup.sh script
#   provisioner "shell" {
#     script = "/tmp/setup.sh"
#   }

#   # Post-processor for generating manifest
# #   post-processor "manifest" {
# #     output = "manifest.json"
# #     strip_path = true
# #     custom_data = {
# #       my_custom_data = "example"
# #     }
# #   }
# }
