FROM golang:1.20.1

LABEL org.opencontainers.image.source "https://github.com/masudur-rahman/golang"
LABEL org.opencontainers.image.description "Custom Golang docker image for improved Go experience..!"

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils         \
    bash              \
    build-essential   \
    bzip2             \
    bzr               \
    ca-certificates   \
    curl              \
    git               \
    gnupg             \
    mercurial         \
    protobuf-compiler \
    socat             \
    upx               \
    wget              \
    xz-utils          \
    zip               \
    g++ \
    make \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

RUN set -x \
    && export GOPATH=/usr/local/go \
    && go install github.com/incu6us/goimports-reviser/v3@latest \
    && go install golang.org/x/lint/golint@latest \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1 \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2.0 \
    && go install github.com/golang/mock/mockgen@latest

RUN set -x \
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/go/bin v1.50.1

# https://stackoverflow.com/questions/65538591/run-protoc-command-into-docker-container
