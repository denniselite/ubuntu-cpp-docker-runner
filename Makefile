SHELL = /bin/bash

.DEFAULT_GOAL := all

IMAGE_VERSION := 0.1
IMAGE_CONTAINER := ubuntu-gcc

all: ubuntu/stop ubuntu/build ubuntu/start

build/%:
	@mkdir -p $*/build
	@g++ -o $*/build/$* $*/main.cpp

run/%:
	@cd ./$* && ./build/$*

.PHONY: ubuntu/build ubuntu/start ubuntu/stop ubuntu/exec ubuntu/attach

ubuntu/build: ## Build a Ubuntu container to run commands in
	@printf "docker build --tag $(IMAGE_CONTAINER):$(IMAGE_VERSION) ."
	@docker build --tag $(IMAGE_CONTAINER):$(IMAGE_VERSION) .

ubuntu/start: ## Start a Ubuntu container to run commands in
	@printf "docker run -d -it $(IMAGE_CONTAINER):$(IMAGE_VERSION)"
	@docker run --name $(IMAGE_CONTAINER) -d -it $(IMAGE_CONTAINER):$(IMAGE_VERSION)

ubuntu/stop: ## Stop the running Ubuntu container
	@printf "docker stop $(IMAGE_CONTAINER) && docker rm -f $(IMAGE_CONTAINER)\n"
	@docker stop $(IMAGE_CONTAINER) && docker rm -f $(IMAGE_CONTAINER)

ubuntu/exec: ## Exec a command in Ubuntu environment. Usage: $(make ubuntu/run) <command>
	@echo "docker exec -it -w /apps $(IMAGE_CONTAINER)"

ubuntu/attach: ## Attach to Ubuntu environment
	@docker exec -it -w /apps $(IMAGE_CONTAINER) /bin/bash