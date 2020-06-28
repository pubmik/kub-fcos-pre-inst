#!/bin/bash
# installs k8s: https://www.matthiaspreu.com/posts/fedora-coreos-kubernetes-basic-setup/
# firewalld settings from ansible playbook: https://computingforgeeks.com/deploy-kubernetes-cluster-on-centos-7-centos-8-with-ansible-and-calico-cni/

sed -i -z s/enabled=0/enabled=1/ /etc/yum.repos.d/fedora-modular.repo
sed -i -z s/enabled=0/enabled=1/ /etc/yum.repos.d/fedora-updates-modular.repo
# At the time of writing cri-o in version 1.17 is only available in testing
sed -i -z s/enabled=0/enabled=1/ /etc/yum.repos.d/fedora-updates-testing-modular.repo

echo "***** fedora repos enabled"
#read -N1 add

mkdir /etc/dnf/modules.d
cat <<EOF > /etc/dnf/modules.d/cri-o.module
[cri-o]
name=cri-o
stream=1.18
profiles=
state=enabled
EOF

echo "***** /etc/dnf/modules.d/cri-o.module created"
#read -N1 a
echo "install cri-o, reboot"; sleep 5

## rpm-ostree install vim cri-o firewalld && \
rpm-ostree install vim cri-o && \
# Make sure to reboot to have layered package available
systemctl reboot
