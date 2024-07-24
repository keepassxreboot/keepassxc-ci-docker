all: build

.PHONY: build
build:
	docker build --platform linux/amd64 $(BUILD_ARGS) --build-arg QT5_MINOR=15 --build-arg QT5_PATCH=2 -t ghcr.io/keepassxreboot/keepassxc-ci:focal-qt5.15 .

.PHONY: push
push:
	docker push ghcr.io/keepassxreboot/keepassxc-ci:focal-qt5.15

