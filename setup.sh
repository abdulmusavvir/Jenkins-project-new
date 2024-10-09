#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Add Jenkins repository
echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade the system packages
echo "Upgrading installed packages..."
sudo yum upgrade -y

# Install Java 17 (Amazon Corretto)
echo "Installing Java 17 (Amazon Corretto)..."
sudo dnf install java-17-amazon-corretto -y

# Install Jenkins
echo "Installing Jenkins..."
sudo yum install jenkins -y

# Install Git
echo "Installing Git..."
sudo yum install -y git

# Enable Jenkins to start at boot
echo "Enabling Jenkins service..."
sudo systemctl enable jenkins

# Start Jenkins
echo "Starting Jenkins service..."
sudo systemctl start jenkins
sleep 10  # Allow some time for Jenkins to start

# Check Jenkins service status and wait if it's still starting
while ! sudo systemctl is-active --quiet jenkins; do
    echo "Waiting for Jenkins to start..."
    sleep 5
done

# Output Jenkins service status
echo "Jenkins service status:"
sudo systemctl status jenkins

# Move private SSH key to Jenkins user's .ssh directory and set proper permissions
if [ -f /tmp/id_rsa ]; then
    echo "Setting up SSH key for Jenkins..."
    sudo mkdir -p /var/lib/jenkins/.ssh
    sudo touch /var/lib/jenkins/.ssh/known_hosts
    sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
    sudo chmod 700 /var/lib/jenkins/.ssh
    sudo mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
    sudo chmod 600 /var/lib/jenkins/.ssh/id_rsa
    sudo chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa
    echo "SSH key setup successfully."
else
    echo "No SSH key found at /tmp/id_rsa; skipping SSH setup."
fi

echo "Jenkins installation and configuration completed successfully."
















# #!/bin/bash

# # Update system packages
# sudo yum update -y

# # Add Jenkins repository
# echo "Adding Jenkins repository..."
# sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# if [ $? -ne 0 ]; then
#     echo "Failed to add Jenkins repo."
#     exit 1
# fi

# # Import Jenkins key
# echo "Importing Jenkins key..."
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# if [ $? -ne 0 ]; then
#     echo "Failed to import Jenkins key."
#     exit 1
# fi

# # Upgrade the system packages
# sudo yum upgrade -y

# # Install Java 17 (Amazon Corretto)
# echo "Installing Java 17 (Amazon Corretto)..."
# sudo dnf install java-17-amazon-corretto -y
# if [ $? -ne 0 ]; then
#     echo "Failed to install Java 17."
#     exit 1
# fi

# # Install Jenkins
# echo "Installing Jenkins..."
# sudo yum install jenkins -y
# if [ $? -ne 0 ]; then
#     echo "Failed to install Jenkins."
#     exit 1
# fi

# # Install Git
# echo "Installing Git..."
# sudo yum install -y git
# if [ $? -ne 0 ]; then
#     echo "Failed to install Git."
#     exit 1
# fi

# # Enable Jenkins to start at boot
# echo "Enabling Jenkins service..."
# sudo systemctl enable jenkins
# if [ $? -ne 0 ]; then
#     echo "Failed to enable Jenkins service."
#     exit 1
# fi

# # Start Jenkins
# echo "Starting Jenkins service..."
# sudo systemctl start jenkins
# sleep 10  # Allow some time for Jenkins to start

# # Check Jenkins service status
# echo "Checking Jenkins service status..."
# sudo systemctl status jenkins
# if [ $? -ne 0 ]; then
#     echo "Jenkins service failed to start."
#     sudo journalctl -xeu jenkins.service
#     exit 1
# fi

# echo "Jenkins installed and running successfully."

# # Move private SSH key to Jenkins user's .ssh directory and set proper permissions
# if [ -f /tmp/id_rsa ]; then
#     sudo mkdir /var/lib/jenkins/.ssh                                              
#     sudo touch /var/lib/jenkins/.ssh/known_hosts                                  
#     sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh                           
#     sudo chmod 700 /var/lib/jenkins/.ssh                                          
#     sudo mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa                              
#     sudo chmod 600 /var/lib/jenkins/.ssh/id_rsa
#     sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa
#     echo "SSH USER IS setup successfully"
# fi


