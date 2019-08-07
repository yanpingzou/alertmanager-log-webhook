-include .env

VERSION := $(shell git describe --tags --always)
BUILD := $(shell git rev-parse --short HEAD)
PROJECTNAME := $(shell basename "$(PWD)")

# Use linker flags to provide version/build settings
LDFLAGS=-ldflags "-X=main.Version=$(VERSION) -X=main.Build=$(BUILD)"

## install: Install dependencies.
install: go-install

## build-linux: Building binary linux.
build-linux: go-install go-build-linux

## build-darwin: Building binary darwin.
build-darwin: go-install go-build-darwin

## clean: Clean build files.
clean:
	@-rm -rf build
	@-$(MAKE) go-clean

setup:
	@-mkdir -p build/linux
	@-mkdir -p build/osx

go-compile: go-get go-build

go-build-linux: setup
	@echo "  >  Building binary linux..."
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o build/linux/$(PROJECTNAME) cmd/alertmanager-log-webhook/main.go

go-build-darwin: setup
	@echo "  >  Building binary darwin..."
	@CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o build/darwin/$(PROJECTNAME) cmd/alertmanager-log-webhook/main.go

go-install:
	@echo "  >  Checking if there is any missing dependencies..."
	@-dep ensure 

go-clean:
	@echo "  >  Cleaning build cache"
	@-go clean

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo