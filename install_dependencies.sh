#!/bin/bash

# Set the environment to noninteractive to suppress prompts
export DEBIAN_FRONTEND=noninteractive

# Check kubectl isn't already installed
if [[ ! -x "$(command -v kubectl)" ]]; then
    echo "Kubectl is not installed. Proceeding with installation..."
    # Install Kubectl
    echo "Installing Kubectl..."

    # Download and Install Kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl

    # Check for errors in installation
    if [[ $? -eq 0 && -x $(command -v kubectl) ]]; then
        echo "Kubectl installed successfully!"
    else
        echo "Failed to install Kubectl. Check for errors above. Exiting..."
        exit 1
    fi
else
    echo "Kubectl is already installed. Skipping installation..."
fi

# Check minikube isn't already installed
if [[ ! -x "$(command -v minikube)" ]]; then
    # Install minikube
    echo "Installing minikube..."

    # Download and Install Minikube
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

    # Check for errors in installation
    if [[ $? -eq 0 && -x $(command -v minikube) ]]; then
        echo "Minikube installed successfully!"
    else
        echo "Failed to install Minikube. Check for errors above. Exiting..."
        exit 1
    fi
else
    echo "minikube is already installed. Skipping installation..."
fi

# Check docker isn't already installed
if [[ ! -x "$(command -v docker)" ]]; then
    # Install Docker
    echo "Installing Docker.."
    # Uninstall old conflicting packages
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

    # Add Docker's official GPG key
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    # Install the latest docker version
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Check for errors in installation
    if [[ $? -eq 0 && -x $(command -v docker) ]]; then
        echo "Docker installed successfully!"
    else
        echo "Failed to install Docker. Check for errors above. Exiting..."
        exit 1
    fi
else
    echo "Docker is already installed. Skipping installation..."
fi

# Dependencies installed successfully
echo -e "Dependencies installed successfully!"
