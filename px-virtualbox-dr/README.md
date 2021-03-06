# px-virtualbox
Portworx deployed with Vagrant using Virtualbox

# Prerequisites

Install Vagrant and Virtualbox on Linux or macOS hosts\
\
-32GB RAM recommended.\
-12CPUs recommended.\
-400GB of free storage Flash storage recommended, I have 1TB on my laptop.

# Upgrade successful to CentOS 8 =)

This version has been updated to CentOS 8 but creating only one disk of 130GB per worker node, one kvdb disk of 15GB and making the root partition bigger (25GB) due to this version uses more space.

Current versions (this can change in the future), that are working:\
\
-Kubernetes 1.21.2.
\
-Kernel 4.18.0-305 with kernel-devel installed.
\
-Portworx 2.7.2.

# Create the cluster

```
$ ./CreateCluster.sh
$ vagrant ssh master -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes"
NAME      STATUS   ROLES                  AGE     VERSION
master.example.com    Ready    control-plane,master   8m29s   v1.21.2
worker0.example.com   Ready    <none>                 6m10s   v1.21.2
worker1.example.com   Ready    <none>                 3m27s   v1.21.2
worker2.example.com   Ready    <none>                 65s     v1.21.2

```

# Check the Portworx Cluster

```
$ vagrant ssh master -c "sudo cat /etc/kubernetes/admin.conf" > ${HOME}/.kube/config
$ kubectl get nodes
NAME                  STATUS   ROLES                  AGE     VERSION
master.example.com    Ready    control-plane,master   15m     v1.21.2
worker0.example.com   Ready    <none>                 13m     v1.21.2
worker1.example.com   Ready    <none>                 11m     v1.21.2
worker2.example.com   Ready    <none>                 8m58s   v1.21.2
```
Check the PX pods status:

```
$ POD=$(kubectl get pods -o wide -n kube-system -l name=portworx | tail -1 | awk '{print $1}')
$ kubectl logs ${POD} -n kube-system -f
[ ctrl+c ]
$ kubectl exec -it pod/${POD} -n kube-system -- /opt/pwx/bin/pxctl status
```
![pxctl status](/images/px-status.png)


# Monitoring enabled

Follow this guide to enable Grafana:\
\
https://docs.portworx.com/portworx-install-with-kubernetes/operate-and-maintain-on-kubernetes/monitoring/monitoring-px-prometheusandgrafana.1
\
\
Cluster dashboard\
![Cluster dashboard](/images/grafana-cluster.png)\
\
Node dashboard\
![Node dashboard](/images/grafana-node.png)\
\
ETCD dashboard\
![ETCD dashboard](/images/grafana-etcd.png)\
\
Volume dashboard\
![Volume dashboard](/images/grafana-volume.png)

# About this project

This is a derivative project from:

https://github.com/dotnwat/k8s-vagrant-libvirt 

Includes a Portworx deployment on a 3 worker node cluster and 1 master node.

It creates 3 virtual disks per worker node. Uses 6GB of RAM per node, I would recommend to have at least 32GB of RAM on your host.

Portworx pods will take up to 10 minutes to become ready.
