# k3d Multi-Node Cluster Walkthrough

A simple repo to document and describe setting up and working with a local k3d cluster.

## k3d Cluster Config

k3d supports using config files to configure k3d clusters. This repo has a basic config file defined as `k3d-cluster-config.yaml`. You can find more information [here](https://k3d.io/v5.5.2/usage/configfile/)

## Local Registries

k3d supports using local registries. This is configured by default within the k3d cluster config. You can find more information [here](https://k3d.io/v5.5.2/usage/registries/)

## Make

### Install

`make install` will use the `k3d-cluster-config.yaml` file to install a new k3d cluster.

### Delete

`make delete` will use the `k3d-cluster-config.yaml` file to uninstall the k3d cluster.

### Test

`make test` will use the latest nginx image from Docker to validate the k3d local registry is operational.

