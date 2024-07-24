all: build

.PHONY: build
build:
	docker build --platform linux/amd64 $(BUILD_ARGS) -t ghcr.io/keepassxreboot/keepassxc-ci:latest .
	docker tag ghcr.io/keepassxreboot/keepassxc-ci:latest ghcr.io/keepassxreboot/keepassxc-ci:focal-qt5.12

.PHONY: push
push:
	docker push ghcr.io/keepassxreboot/keepassxc-ci:latest
	docker push ghcr.io/keepassxreboot/keepassxc-ci:focal-qt5.12
