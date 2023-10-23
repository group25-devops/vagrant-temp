#!/bin/bash

echo ">>> SYSTEM UPDATE & UPGRADE"

sudo apt update
sudo apt -y upgrade


echo ">>> KERNEL MODULES"

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

echo ">>> INSTALL CRI"
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y


echo ">>> DISABLE SWAP"

sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
sudo swapoff -a