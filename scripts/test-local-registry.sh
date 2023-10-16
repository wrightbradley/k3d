#!/bin/bash

# This is configured within k3d-cluster.yaml config file
LOCAL_REGISTRY="localhost"
LOCAL_REGISTRY_PORT="5000"

# This is necessary for DNS resolution within the k3d cluster
K3D_REGISTRY="registry.$LOCAL_REGISTRY"

REGISTRY="docker.io"
IMAGE="nginx"
IMAGE_TAG="latest"

echo -e "\nPulling image $REGISTRY/$IMAGE:$IMAGE_TAG"
docker pull $REGISTRY/$IMAGE:$IMAGE_TAG

echo -e "\nTagging image $REGISTRY/$IMAGE:$IMAGE_TAG to $LOCAL_REGISTRY:$LOCAL_REGISTRY_PORT/$IMAGE:$IMAGE_TAG"
docker tag $REGISTRY/$IMAGE:$IMAGE_TAG "$LOCAL_REGISTRY:$LOCAL_REGISTRY_PORT/$IMAGE:$IMAGE_TAG"

echo -e "\nPushing image $LOCAL_REGISTRY:$LOCAL_REGISTRY_PORT/$IMAGE:$IMAGE_TAG"
docker push "$LOCAL_REGISTRY:$LOCAL_REGISTRY_PORT/$IMAGE:$IMAGE_TAG"

echo -e "\nDeploying nginx-test-registry using image: $K3D_REGISTRY:$LOCAL_REGISTRY_PORT/$IMAGE:$IMAGE_TAG"
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-test-registry
  namespace: default
  labels:
    app: nginx-test-registry
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-test-registry
  template:
    metadata:
      labels:
        app: nginx-test-registry
    spec:
      containers:
      - name: nginx-test-registry
        image: "$K3D_REGISTRY:$LOCAL_REGISTRY_PORT/$IMAGE:$IMAGE_TAG"
        ports:
        - containerPort: 80
EOF

echo -e "\nWaiting for pod to startup"
sleep 10

kubectl get pods -n default -l app=nginx-test-registry
