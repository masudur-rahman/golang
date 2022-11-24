FROM golang:1.19-alpine

RUN apk add -q --update \
    && apk add -q \
            bash \
            git \
            curl \
            build-base \
    && rm -rf /var/cache/apk/*

RUN go install golang.org/x/lint/golint@latest
RUN go install golang.org/x/tools/cmd/goimports@latest
# RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.50.1
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.50.1

# Remove the downloaded source files
RUN rm -rf $GOPATH/src/* && rm -rf $GOPATH/pkg/*
