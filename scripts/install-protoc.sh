#!/bin/bash

if [ "$TARGETARCH" = "arm64" ]; then
    PROTOC_ARCH="aarch_64"
else
    PROTOC_ARCH="x86_64"
fi

echo PROTOC_ARCH is $PROTOC_ARCH and TARGETARCH is $TARGETARCH

mkdir -p /tmp/protoc && cd /tmp/protoc

wget https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-$PROTOC_ARCH.zip
unzip protoc-22.2-linux-$PROTOC_ARCH.zip

su -c "cp bin/protoc /usr/local/bin/"
su -c "cp -r include/* /usr/local/include/"

cd - && rm -rf /tmp/protoc
