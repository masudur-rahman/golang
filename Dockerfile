FROM golang:1.21.0

LABEL org.opencontainers.image.source = "https://github.com/masudur-rahman/golang"
LABEL org.opencontainers.image.description = "Custom Golang docker image for improved Go experience..!"

ARG TARGETOS
ARG TARGETARCH
ARG VERSION

RUN set -x \
  && apt update \
  && apt install -y --no-install-recommends \
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
    socat             \
    wget              \
    xz-utils          \
    zip               \
    unzip             \
    g++               \
    make              \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

RUN set -x \
    && export GOPATH=/usr/local/go \
    && go install github.com/incu6us/goimports-reviser/v3@latest \
    && go install golang.org/x/lint/golint@latest \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.30.0 \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0 \
    && go install github.com/golang/mock/mockgen@latest

RUN set -x \
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/go/bin v1.54.1


RUN if [ "$TARGETARCH" = "arm64" ]; then \
      echo aarch_64 > /tmp/protoc_arch; \
    else \
      echo x86_64 > /tmp/protoc_arch; \
    fi

RUN set -x \
    && export PROTOC_ARCH=$(cat /tmp/protoc_arch) \
    && mkdir -p /tmp/protoc \
    && cd /tmp/protoc \
    && wget https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-$PROTOC_ARCH.zip \
    && unzip protoc-22.2-linux-$PROTOC_ARCH.zip \
    && cp bin/protoc /usr/local/bin/ \
    && cp -r include/* /usr/local/include/ \
    && cd - && rm -rf /tmp/protoc

# Just keeping it here
# ENV TARGETARCH=$TARGETARCH
# ADD scripts/install-protoc.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/install-protoc.sh
# RUN install-protoc.sh
