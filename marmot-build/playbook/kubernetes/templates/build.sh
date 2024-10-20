#!/bin/bash

export GOPATH=`pwd`
cd kubernetes
make all
make quick-release
make quick-release-images

mkdir /nfs/kubernetes/{{ k8s_version }}
cd _output/release-tars
tar xzvf kubernetes-client-linux-amd64.tar.gz -C /nfs/kubernetes/{{ k8s_version }}
tar xzvf kubernetes-manifests.tar.gz -C /nfs/kubernetes/{{ k8s_version }}
tar xzvf kubernetes-node-linux-amd64.tar.gz -C /nfs/kubernetes/{{ k8s_version }}
tar xzvf kubernetes-server-linux-amd64.tar.gz -C /nfs/kubernetes/{{ k8s_version }}

echo "END"

