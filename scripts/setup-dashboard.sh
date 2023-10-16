#!/bin/bash

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard --set fullnameOverride='kubernetes-dashboard'

kubectl create serviceaccount -n kubernetes-dashboard admin-user
kubectl create clusterrolebinding -n kubernetes-dashboard admin-user --clusterrole cluster-admin --serviceaccount=kubernetes-dashboard:admin-user

token=$(kubectl -n kubernetes-dashboard create token admin-user)
echo $token | pbcopy
