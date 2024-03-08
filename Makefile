all: build

.PHONY: build
build:
	docker build $(BUILD_ARGS) -t ghcr.io/keepassxreboot/keepassxc-ci:latest .
	docker tag ghcr.io/keepassxreboot/keepassxc-ci:latest ghcr.io/keepassxreboot/keepassxc-ci:bionic-qt5.9

.PHONY: push
push:
	docker push ghcr.io/keepassxreboot/keepassxc-ci:latest
	docker push ghcr.io/keepassxreboot/keepassxc-ci:bionic-qt5.9
