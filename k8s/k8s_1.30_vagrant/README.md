# Deploy Kubernetes 1.30 using kubeadm on Vagrant deployed Ubuntu 22.04 VMs with Calico as a CNI

## Summary

This article provides a comprehensive guide on how to deploy a Kubernetes 1.30 cluster. 
We are using kubeadm to do the deploy rather than to deploy and configure each service manually.  If there is interest in the manual process, I will create a series for that. 
We are deploying onto a physical server running Ubuntu 22.04.  Vagrant will manage the deployment of Ubuntu 22.04 nodes which will be the kubernetes cluster. 
Calico is serving as the Container Network Interface (CNI). 

The reader is expected to have Ubuntu 22.04 installed on a physical machine, Vagrant set up, and a bridged network configured. The guide will walk the user through the necessary steps, from setting up the VMs to deploying Kubernetes and configuring Calico.

## Prerequisites

- Ubuntu 22.04 installed on a physical machine
- Vagrant installed on the physical machine
- Bridged network configured on the physical machine
    - `/etc/vbox/networks.conf` should have the following line: `* 10.0.0.0/8`

## Setting up the Physical Server

In this section, we will set up the environment that will host the Kubernetes VM's.  This is written to be a single physical server, however there is nothing keeping you from adding Kubernetes nodes on additional servers provided that the networks are setup correctly. 

This deployment will invoke the following steps:
1. Ubuntu 22.04
1. Linux virtualization
1. Vagrant
1. Network Setup

## Using Vagrant to deploy the Kubernetes master and worker nodes

Once the physical servers are setup with networking, we are ready to deploy the Kubernetes master and worker nodes.  This will be done using Vagrant.  The Vagrantfile will handle the deployment of everything up to cluster testing, however the sections below cover the steps in more detail.

There are 3 types of nodes that I will call out.
  - kubenodes: These include all nodes that are part of the cluster.  At the time of writing, this includes the master and worker nodes.
  - masternodes: (TODO: change this to main or service node.) This node hosts the services that are required for the cluster to function.  This includes:
    - API server, the 
    - controller manager, the 
    - scheduler, and the 
    - etcd database.
    - dns
    - calico
    - TODO: What did i forget here?
  - workernodes: These nodes are where the containers are deployed.  They are the workhorses of the cluster.  They are responsible for running the containers and the pods that contain them.  They are also responsible for the networking between the containers and the pods.

## Deployment on kubenodes

- apt repo configuration.
- apt package installation
- containerd configuration
- containerd installation
- hosts
- prepare for troubleshoot.sh


## Deploying the master node

- nat setup
- kubeadmin installation
- kubeadmin execution
  - kubeadmin configuration
- distribute join command
- distribute kubeconfig
- deploy calico

## Deploying the worker nodes

- join the cluster
- execute cluster tests

## Testing the deployment

```bash
kubectl diff -R -f samples/
kubectl apply -R -f samples/
```