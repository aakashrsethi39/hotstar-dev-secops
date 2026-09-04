#!/bin/bash

set -e

apt-get update -y

apt-get install -y \
  unzip \
  wget \
  curl \
  git \
  docker.io

systemctl enable docker
systemctl start docker

sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

cat <<EOF >> /etc/sysctl.conf
vm.max_map_count=524288
fs.file-max=131072
EOF

docker run -d \
  --name sonarqube \
  --restart unless-stopped \
  -p 9000:9000 \
  sonarqube:lts-community