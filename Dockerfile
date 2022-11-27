FROM golang:1.19.3-alpine

LABEL org.opencontainers.image.source "https://github.com/masudur-rahman/golang"
LABEL org.opencontainers.image.description "Custom Golang docker image for improved Go experience..!"

RUN apk add -q --update \
    && apk add -q --no-cache  \
        bash \
        git \
        curl \
        unzip \
        build-base \
        autoconf \
        automake \
        libtool \
        make \
        g++ \
        protoc=3.18.1-r3 \
    && rm -rf /var/cache/apk/*

RUN set -x \
    && export GOPATH=/usr/local/go \
    && go install github.com/incu6us/goimports-reviser/v3@latest \
    && go install golang.org/x/lint/golint@latest \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1 \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2.0 \
    && rm -rf $GOPATH/src/* && rm -rf $GOPATH/pkg/*

RUN set -x \
  && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/go/bin v1.50.1

# https://stackoverflow.com/questions/65538591/run-protoc-command-into-docker-container
