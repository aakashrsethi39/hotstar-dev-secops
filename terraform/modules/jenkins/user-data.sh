#!/bin/bash

set -e

apt-get update -y

apt-get install -y \
  openjdk-21-jdk \
  docker.io \
  git \
  curl \
  wget \
  unzip \
  jq \
  ca-certificates

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  -o /usr/share/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins