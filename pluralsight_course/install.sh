#!/bin/bash

echo -e "\e[1;31m configure Hosts file for your enviroment  \e[0m"
sudo echo -e "172.20.50.11  docker01 \n172.20.50.12    c1-master1 \n172.20.50.21    c1-node1 \n172.20.50.22    c1-node2   \n172.20.50.23    c1-node3" >> /etc/hosts

echo -e "\e[1;31m change sshd config for vagrant box and restart service  \e[0m"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/UseDNS no/UseDNS yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo -e "\e[1;31m change root pass  \e[0m"
sudo echo "root" | sudo passwd --stdin root

echo -e "\e[1;31m install requered packages  \e[0m"
sudo yum update -y
sudo yum install epel-release -y
sudo yum install vim tuned net-tools make nano zip unzip wget yum-utils iptables-services screen telnet  tmux openssh-server  mc  iftop  htop iotop wget -y 
sudo yum install tcpdump lynx  links pinfo bash-completion bash-completion-extras  gcc sysstat lsof rsync  nc -y
sudo yum remove docker-ce -y


echo -e "\e[1;31m disable Swap  for kubernetes  \e[0m"
sudo swapoff -a
sudo sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

echo -e "\e[1;31m disbale Firewall and Selinux  \e[0m"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo -e "\e[1;31m add kube repo and kube install packages  \e[0m"
sudo echo  -e "[kubernetes] \n
name=Kubernetes \n
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 \n
enabled=1 \n
gpgcheck=1 \n
repo_gpgcheck=1 \n
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg \n
exclude=kube* \n " > /etc/yum.repos.d/kubernetes.repo
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum install -y docker kubelet kubeadm kubectl --disableexcludes=kubernetes

echo -e "\e[1;31m start and enable kubernetes services  \e[0m"
sudo systemctl enable docker ; sudo systemctl start docker
sudo systemctl enable kubelet ; sudo systemctl start kubelet


### Enable Iptables filtering for proxy working correctly and add sysctl.conf
sudo echo -e  "net.bridge.bridge-nf-call-ip6tables = 1 \n
net.bridge.bridge-nf-call-iptables = 1" > /etc/sysctl.d/k8s.conf

### Show you changing on yur system
#sudo sysctl --system


echo -e "\e[1;31m rebooting system take time about 10 seconds  \e[0m"
sleep 5 
sudo reboot
