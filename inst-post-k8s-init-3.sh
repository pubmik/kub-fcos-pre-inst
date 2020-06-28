#!/bin/bash


if [ $# -ne 3 ]; then
   echo "param 1: ip/dns master node"
   echo "param 2: token"
   echo "param 3: discovery-token-ca-cert-hash"
   exit
fi

echo "***** join k8s cluster"
kubeadm join ${1}:6443 --token $2 \
    --discovery-token-ca-cert-hash $3
    --cri-socket /var/run/crio/crio.sock

