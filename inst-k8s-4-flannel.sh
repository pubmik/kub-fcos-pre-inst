#!/bin/bash

# fes prepare cluster for flannel cni

cat <<EOF > clusterconfig.yml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: v1.18.5
controllerManager:
  extraArgs:
    flex-volume-plugin-dir: "/etc/kubernetes/kubelet-plugins/volume/exec"
networking:
  podSubnet: 10.244.0.0/16
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
nodeRegistration:
  criSocket: /var/run/crio/crio.sock
EOF

echo "created raw cluster config file, next is cluster init"
#read -N1 a

kubeadm config images pull --config clusterconfig.yml
kubeadm init --config clusterconfig.yml


