ROOT_DIR := $(CURDIR)
SHELL := /bin/bash

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: all install delete test

all: help

## Install:
install: ## Install k3d cluster using config file
	k3d cluster create -c k3d-cluster-config.yaml
	kubectl cluster-info

delete: ## Delete k3d cluster using config file
	k3d cluster delete -c k3d-cluster-config.yaml

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
