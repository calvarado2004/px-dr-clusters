#!/bin/bash
set -e

export PX_METADATA_NODE_LABEL="kubernetes.io/role=infra"

kubeadm join master.example.com:6443 --token ${TOKEN} \
  --discovery-token-unsafe-skip-ca-verification
