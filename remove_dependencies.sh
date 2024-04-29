#!/bin/bash

# This script removes Docker, Minikube and Kubectl from the system, ask user for confirmation before proceeding
read -p "Are you sure you want to remove Docker, Minikube, and Kubectl? (yes/no): " answer
if [ "$answer" != "yes" ]; then
    echo "Aborted."
    exit 1
fi


# Remove Minikube and Kubectl binaries
echo "Removing Minikube and Kubectl binaries..."
rm /usr/local/bin/minikube /usr/local/bin/kubectl

# Remove Minikube and Kubectl directories
#echo "Removing Minikube and Kubectl directories..."
#rm -rf ~/.minikube ~/.kube

# Remove package dependencies
echo "Removing package dependencies for the cluster..."
apt-get remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# auto remove dependencies
echo "Auto removing dependencies..."
apt-get autoremove -y

# Remove Docker APT repository
echo "Removing Docker APT repository..."
rm /etc/apt/sources.list.d/docker.list

# Remove Docker public keys
echo "Removing Docker public key..."
rm /etc/apt/keyrings/docker.asc

# Check docker, minikube and kubectl are removed
if [ -x "$(command -v docker)" ] || [ -x "$(command -v kubectl)" ]; then
    # Echo in red
    echo -e "Failed to remove dependencies. Check for errors above"
else
    echo "Dependencies removed successfully!"
fi