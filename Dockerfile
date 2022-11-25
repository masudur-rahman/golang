FROM golang:1.19.3-alpine

LABEL org.opencontainers.image.source "https://github.com/masudur-rahman/golang"
LABEL org.opencontainers.image.description "Custom Golang docker image for improved Go experience..!"

RUN apk add -q --update \
    && apk add -q \
        bash \
        git \
        curl \
        build-base \
    && rm -rf /var/cache/apk/*

RUN set -x \
    && export GOPATH=/usr/local/go \
    && go install github.com/incu6us/goimports-reviser/v3@latest \
    && go install golang.org/x/lint/golint@latest \
    && rm -rf $GOPATH/src/* && rm -rf $GOPATH/pkg/*

RUN set -x \
  && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/go/bin v1.50.1
