# Cortex Deployment on Minikube

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/):
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/):
- [Docker](https://docs.docker.com/engine/install/)

We will be using the Docker driver for Minikube in this project but you can use another one from this list of [Drivers](https://minikube.sigs.k8s.io/docs/drivers/)

You can use the automated installation or follow the installation steps given.

## Prerequisites Automated Installation

Remember to examine scripts downloaded from the internet before running them locally.

```bash
cd cortex-on-minikube

# Examine script
cat install_dependencies.sh

# Execute script after examination
sudo ./install_dependencies.sh
```

## Prerequisites Installation Steps (Ubuntu/Debian)

If you have used the Automated Installation you can skip this steps.

### Installing Kubectl:

```bash
# Download and Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Installing Minikube:

```bash
# Download and Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

### Installing Docker:

```bash

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
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Now all the prerequisites have been installed.

## Getting Started

To start the minikube cluster with the Docker driver and 4096mb of RAM run the following commands:

```bash
# Starting the minikube cluster
minikube start --driver=docker --cpus 2 --memory 4096
```

Then, to deploy the Cortex and Elasticsearch services run the following commands:

```bash
# Enabling ingress controller
minikube addons enable ingress

# Creating namespace cortex
kubectl apply -f manifests/cortex-namespace.yml

# Changing default namespace to cortex
kubectl config set-context --current --namespace cortex

# Deploying config maps
kubectl apply -f manifests/cortex-config.yml
kubectl apply -f manifests/elasticsearch-config.yml

# Deploying network services:
kubectl apply -f manifests/cortex-service.yml
kubectl apply -f manifests/cortex-ingress.yml
kubectl apply -f manifests/elasticsearch-service.yml

# Depploying Elasticsearch statefulset
kubectl apply -f manifests/elasticsearch-statefulset.yml

# Deploying Cortex
kubectl apply -f manifests/cortex-deployment.yml
```

Now we have a Cortex running in Kubernetes in the port 80. You can check it by running the following command:

```bash
curl "http://$(minikube ip)/index.html"
```

If you want to check it in the browser and you are not in the same machine in which the minikube is running you will need to forward the minikube ip traffic to the ip of the machine. You can do this using the following command:

```bash
sudo ssh -fN -g -L 80:$(minikube ip):80 <ssh-user>@<machine-ip>
```

Then you can go to your browser and search for: ```http://<machine-ip>``` to access the Cortex platform.