# k3d Multi-Node Cluster Walkthrough

A simple repo to document and describe setting up and working with a local k3d cluster.

## k3d Cluster Config

k3d supports using config files to configure k3d clusters. This repo has a basic config file defined as `k3d-multinode-config.yaml`. You can find more information [here](https://k3d.io/v5.5.2/usage/configfile/)

## Local Registries

k3d supports using local registries. This is configured by default within the k3d cluster config. You can find more information [here](https://k3d.io/v5.5.2/usage/registries/)

## Multi-node Setup

### Install

`make install-multinode` will use the `cluster-configs/k3d-multinode-config.yaml` file to install a new k3d cluster.

### Delete

`make delete-multinode` will use the `cluster-configs/k3d-multinode-config.yaml` file to uninstall the k3d cluster.

### Test

`make test` will use the latest nginx image from Docker to validate the k3d local registry is operational.


## Istio Setup

### Install

`make install-istio` will use the `cluster-configs/k3d-istio-config.yaml` file to install a new k3d cluster.

### Delete

`make delete-istio` will use the `cluster-configs/k3d-istio-config.yaml` file to uninstall the k3d cluster.

### Istio Install

`make deploy-istio` will install Istio using Helm

## Extras

### Kubernetes Dashboard

`make deploy-dashboard` will install the Kubernetes Dashboard

### Echo Server

`make deploy-echoserver` will install the Echo Server for testing

### Httpbin Server

`make deploy-httpbin` will install the httpbin for testing

## Updating /etc/hosts

To handle routing for services, you will want to update your local hosts file.

```bash
nvim /etc/hosts
```

```text
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost

255.255.255.255 broadcasthost
::1             localhost

127.0.0.1 httpbin.local echoserver.local
```

With these changes in place, you should be able to run: 

- `curl http://httpbin.local/headers`
- `curl http://echoserver.local/`
