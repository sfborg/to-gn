PROJ_NAME := "to-gn"

VERSION := `git describe --tags`
VER := `git describe --tags --abbrev=0`
DATE := `date -u '+%Y-%m-%d_%H:%M:%S%Z'`

FLAGS_LD := "-ldflags \"-X github.com/sfborg/" + PROJ_NAME + "/pkg.Build=" + DATE + " -X github.com/sfborg/" + PROJ_NAME + "/pkg.Version=" + VERSION + "\""
FLAGS_REL := "-trimpath -ldflags \"-s -w -X github.com/sfborg/" + PROJ_NAME + "/pkg.Build=" + DATE + "\""

RELEASE_DIR := "/tmp"
TEST_OPTS := "-count=1 -p 1 -shuffle=on -coverprofile=coverage.txt -covermode=atomic"

# Runs install
default: install

# Show available recipes
help:
    @just --list

# Download dependencies
deps:
    go mod download

# Install tools
tools: deps
    @cat tools.go | grep _ | awk -F'"' '{print $$2}' | xargs -tI % go install %

# Build binary
build:
    CGO_ENABLED=0 go build -o {{PROJ_NAME}} {{FLAGS_LD}} .

# Build binary without debug info and with hardcoded version
buildrel:
    CGO_ENABLED=0 go build -o {{PROJ_NAME}} {{FLAGS_REL}} .

# Build and install binary
install:
    CGO_ENABLED=0 go install {{FLAGS_LD}}

# Build and package binaries for a release
release: buildrel
    go clean
    CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build {{FLAGS_REL}}
    tar zcvf {{RELEASE_DIR}}/{{PROJ_NAME}}-{{VER}}-linux-amd64.tar.gz {{PROJ_NAME}}
    go clean
    CGO_ENABLED=0 GOARCH=amd64 GOOS=darwin go build {{FLAGS_REL}}
    tar zcvf {{RELEASE_DIR}}/{{PROJ_NAME}}-{{VER}}-darwin-amd64.tar.gz {{PROJ_NAME}}
    go clean
    GOARCH=arm64 GOOS=darwin go build {{FLAGS_REL}}
    tar zcvf {{RELEASE_DIR}}/{{PROJ_NAME}}-{{VER}}-darwin-arm64.tar.gz {{PROJ_NAME}}
    go clean
    CGO_ENABLED=0 GOARCH=amd64 GOOS=windows go build {{FLAGS_REL}}
    zip -9 {{RELEASE_DIR}}/{{PROJ_NAME}}-{{VER}}-windows-amd64.zip {{PROJ_NAME}}.exe
    go clean

# Clean all the files and binaries generated
clean:
    rm -rf ./out

# Run the tests of the project
test:
    go test {{TEST_OPTS}} ./...

# Run the tests of the project and export the coverage
coverage:
    go test -cover -covermode=count -coverprofile=profile.cov ./...
    go tool cover -func profile.cov

# Display current version
version:
    @echo {{VERSION}}
