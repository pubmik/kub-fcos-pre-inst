#!/bin/bash

systemctl enable --now cri-o && systemctl enable --now kubelet
# fes extraargs ist angeblich deprecated, install funkt aber nicht ohne
echo "KUBELET_EXTRA_ARGS=--cgroup-driver=systemd" | tee /etc/sysconfig/kubelet

# fes geht noch nicht hier, vor kubeadm init , weil er config.yaml bei init wieder überschreibt
##sed -i '$ a cgroupDriver: systemd' /var/lib/kubelet/config.yaml
#mkdir /var/lib/kubelet
#echo "apiVersion: kubelet.config.k8s.io/v1beta1" >> /var/lib/kubelet/config.yaml
#echo "kind: KubeletConfiguration" >> /var/lib/kubelet/config.yaml
#echo "cgroupDriver: systemd" >> /var/lib/kubelet/config.yaml

echo "kubelet started, cgroupdriver auf systemd gesetzt"
#read -N1 a
