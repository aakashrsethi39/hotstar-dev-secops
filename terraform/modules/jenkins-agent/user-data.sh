#!/bin/bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update -y

apt-get install -y \
  openjdk-21-jdk \
  docker.io \
  git \
  curl \
  wget \
  unzip \
  jq \
  ca-certificates \
  gnupg

systemctl enable --now docker

usermod -aG docker ubuntu

mkdir -p /home/ubuntu/jenkins

chown ubuntu:ubuntu /home/ubuntu/jenkins

# Install AWS CLI
curl -fsSL \
  https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
  -o /tmp/awscliv2.zip

unzip -q /tmp/awscliv2.zip -d /tmp

/tmp/aws/install

rm -rf /tmp/aws /tmp/awscliv2.zip

# Install kubectl compatible with EKS 1.35
KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable-1.35.txt)

curl -fsSL \
  "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  -o /usr/local/bin/kubectl

chmod +x /usr/local/bin/kubectl


# Install Trivy
curl -fsSL \
  https://github.com/aquasecurity/trivy/releases/download/v0.71.2/trivy_0.71.2_Linux-64bit.deb \
  -o /tmp/trivy.deb

apt-get install -y /tmp/trivy.deb

rm -f /tmp/trivy.deb

# Install Docker Scout
curl -fsSL \
  https://raw.githubusercontent.com/docker/scout-cli/main/install.sh \
  -o /tmp/install-scout.sh

mkdir -p /usr/local/lib/docker/cli-plugins

sh /tmp/install-scout.sh -b /usr/local/lib/docker/cli-plugins

rm -f /tmp/install-scout.sh

# Configure Kubernetes access for agent user
sudo -u ubuntu -H aws eks update-kubeconfig \
  --region ap-south-1 \
  --name hotstar-eks


# Install OWASP ZAP
ZAP_VERSION="2.17.0"

curl -fsSL \
  "https://github.com/zaproxy/zaproxy/releases/download/v${ZAP_VERSION}/ZAP_${ZAP_VERSION}_Linux.tar.gz" \
  -o /tmp/zap.tar.gz

tar -xzf /tmp/zap.tar.gz -C /opt

ln -sfn "/opt/ZAP_${ZAP_VERSION}" /opt/zap

rm -f /tmp/zap.tar.gz

echo "Jenkins agent bootstrap completed"
