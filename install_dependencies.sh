#!/bin/bash

# Set the environment to noninteractive to suppress prompts
export DEBIAN_FRONTEND=noninteractive
export PATH=$PATH:/usr/local/bin

# Check kubectl isn't already installed
if [[ ! -x "$(command -v kubectl)" ]]; then
    echo "Kubectl is not installed. Proceeding with installation..."
    # Install Kubectl
    echo "Installing Kubectl..."

    # Download and Install Kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl

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
    install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

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
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

    # Add Docker's official GPG key
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    # Install the latest docker version
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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

# Check helm isn't already installed
if [[ ! -x "$(command -v helm)" ]]; then
    # Install Helm
    echo "Installing Helm..."

    # Download and Install Helm
    curl -LO https://get.helm.sh/helm-v3.14.4-linux-amd64.tar.gz
    tar -zxvf helm-v3.14.4-linux-amd64.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm

    # Cleanup the downloaded files
    rm -rf linux-amd64 helm-v3.14.4-linux-amd64.tar.gz

    # Check for errors in installation
    if [[ $? -eq 0 && -x $(command -v helm) ]]; then
        echo "Helm installed successfully!"
    else
        echo "Failed to install Helm. Check for errors above. Exiting..."
        exit 1
    fi
else
    echo "Helm is already installed. Skipping installation..."
fi

# Dependencies installed successfully message in green
echo -e "\033[1;32mDependencies installed successfully!\033[0m"

# Tell the user to make sure to add /usr/local/bin to their PATH
echo -e "\033[1;33mIMPORTANT: To be able to use this dependencies make sure to add /usr/local/bin to your PATH by running:\033[0m \033[1;32mexport PATH=\$PATH:/usr/local/bin\033[0m"
