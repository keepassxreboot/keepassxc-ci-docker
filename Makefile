all: build
IMAGE = devcontainers1/keepassxc
VERSION = latest

.PHONY: build
build:
	docker build --platform linux/amd64 $(BUILD_ARGS) -t $(IMAGE):$(VERSION) .

.PHONY: push
push:
	docker push $(IMAGE):$(VERSION)
