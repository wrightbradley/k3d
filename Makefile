ROOT_DIR := $(CURDIR)
SHELL := /bin/bash

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

EXECUTABLES = kubectl kubectx helm kustomize k3d
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH. Run `brew install $(exec)`")))

.PHONY: all install delete test

all: help

## Cluster Install:
install-multinode:  ## Install k3d cluster using config file
	k3d cluster create -c cluster-configs/k3d-multinode-config.yaml
	kubectl cluster-info

delete-multinode:  ## Delete k3d cluster using config file
	k3d cluster delete -c cluster-configs/k3d-multinode-config.yaml

install-istio: ## Install k3d cluster using config file for Istio
	k3d cluster create -c cluster-configs/k3d-istio-config.yaml
	kubectl cluster-info

delete-istio: ## Delete k3d cluster using config file for Istio
	k3d cluster delete -c cluster-configs/k3d-istio-config.yaml

## Deploy:
deploy-istio: ## Helm Install Istio
	bash ./scripts/setup-istio.sh
	kubectl apply -f ./scripts/istio-ingressclass.yaml

deploy-dashboard: ## Helm Install Kubernetes Dashboard
	bash ./scripts/setup-dashboard.sh

deploy-echoserver: ## Kustomize Install EchoServer
	kustomize build ./manifests/echoserver | kubectl apply -f -

deploy-httpbin: ## Kustomize Install httpbin
	kustomize build ./manifests/httpbin | kubectl apply -f -

## Test:
test: test-reg ## Run all available tests

test-reg: ## Test k3d local registry
	bash ./scripts/test-local-registry.sh

## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
