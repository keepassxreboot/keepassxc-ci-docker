all: build
IMAGE = ghcr.io/keepassxreboot/keepassxc-ci
VERSION = mcr-focal

.PHONY: build
build:
	docker build --platform linux/amd64 $(BUILD_ARGS) -t $(IMAGE):$(VERSION) .
#	docker tag $(IMAGE):latest $(IMAGE):focal-qt5.12

.PHONY: push
push:
	docker push $(IMAGE):$(VERSION)
#	docker push $(IMAGE):focal-qt5.12
