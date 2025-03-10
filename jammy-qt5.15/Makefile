all: build

.PHONY: build
build:
	docker build --platform linux/amd64 $(BUILD_ARGS) -t ghcr.io/keepassxreboot/keepassxc-ci-docker:jammy-qt5.15 .

.PHONY: push
push:
	docker push ghcr.io/keepassxreboot/keepassxc-ci-docker:jammy-qt5.15

