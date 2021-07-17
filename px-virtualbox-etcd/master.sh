#!/bin/bash
set -e

kubeadm config images pull
kubeadm init --pod-network-cidr=10.244.0.0/16 \
        --token ${TOKEN} --apiserver-advertise-address=${MASTER_IP}

KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f /tmp/kube-flannel.yml

sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf taint node master.example.com node-role.kubernetes.io/master:NoSchedule-
