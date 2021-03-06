#!/bin/bash

systemctl enable firewalld --now

# firewallports, sowohl für flannes als auch für calico
# Master nodes firewall ports
firewall-cmd --add-port 6443/tcp --permanent
firewall-cmd --add-port 2379-2380/tcp --permanent
firewall-cmd --add-port 10250-10251/tcp --permanent

# Worker nodes firewall ports
firewall-cmd --add-port 10250/tcp --permanent
firewall-cmd --add-port 30000-32767/tcp --permanent

# Calico CNI firewall ports
#calico_udp_ports:
firewall-cmd --add-port 47839/udp --permanent

#calico_tcp_ports:
firewall-cmd --add-port 5473/tcp --permanent
firewall-cmd --add-port 179/tcp --permanent


# Flannel CNI firewall ports
#flannel_udp_ports:
firewall-cmd --add-port 8285/udp --permanent
firewall-cmd --add-port 8472/udp --permanent

firewall-cmd --reload

# Load required kernel modules
modprobe overlay && modprobe br_netfilter

# Kernel module should be loaded on every reboot
cat <<EOF > /etc/modules-load.d/crio-net.conf
overlay
br_netfilter
EOF

# Network settings
cat <<EOF > /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system
sed -i -z s+/usr/share/containers/oci/hooks.d+/etc/containers/oci/hooks.d+ /etc/crio/crio.conf

echo "modules and settings for crio done, ports opened"
#read -N1 a

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "config repo kubernetes"
#read -N1 a

# Set SELinux to permissive mode
setenforce 0
# Make setting persistent
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo "disable SELinux, install kubelet kubeadm kubectl, reboot"
rpm-ostree install kubelet kubeadm kubectl && \
# Make sure to reboot to have layered packages available
systemctl reboot
