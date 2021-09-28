all: build

.PHONY: build
build:
	docker build . -t keepassxc/keepassxc-ci:latest
	docker tag keepassxc/keepassxc-ci:latest keepassxc/keepassxc-ci:bionic-qt5.9

.PHONY: push
push:
	docker push keepassxc/keepassxc-ci:latest
	docker push keepassxc/keepassxc-ci:bionic-qt5.9
