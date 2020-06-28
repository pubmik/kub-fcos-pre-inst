#!/bin/bash

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# fes falls am master node auch pods gestartet werden sollen
kubectl taint nodes --all node-role.kubernetes.io/master-
