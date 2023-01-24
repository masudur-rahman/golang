SHELL=/bin/bash -o pipefail

REGISTRY   ?= ghcr.io/masudur-rahman
BIN        ?= golang
IMAGE      := $(REGISTRY)/$(BIN)
VERSION    ?= 1.19.3
SRC_REG    ?=

DOCKER_PLATFORMS := darwin/arm64 linux/amd64 linux/arm64 windows/amd64
PLATFORM         ?= $(firstword $(DOCKER_PLATFORMS))
TAG              = $(VERSION)_$(subst /,_,$(PLATFORM))
#TAG              = $(VERSION)

container-%:
	@$(MAKE) container \
	    --no-print-directory \
	    PLATFORM=$(subst _,/,$*)

push-%:
	@$(MAKE) push \
	    --no-print-directory \
	    PLATFORM=$(subst _,/,$*)

all-container: $(addprefix container-, $(subst /,_,$(DOCKER_PLATFORMS)))

all-push: $(addprefix push-, $(subst /,_,$(DOCKER_PLATFORMS)))

.PHONY: container
ifeq (,$(SRC_REG))
container:
	@echo "container: $(IMAGE):$(TAG)"
	docker buildx build --platform $(PLATFORM) --load --pull -t $(IMAGE):$(TAG) -f Dockerfile .
	#docker buildx build --load --pull -t $(IMAGE):$(TAG) -f Dockerfile .
	@echo
else
container:
	@echo "container: $(IMAGE):$(TAG)"
	@docker tag $(SRC_REG)/$(BIN):$(TAG) $(IMAGE):$(TAG)
	@echo
endif

push: container
	@docker push $(IMAGE):$(TAG)
	@echo "pushed: $(IMAGE):$(TAG)"
	@echo

# https://stackoverflow.com/a/3732456
VER_MAJOR := $(shell echo $(VERSION) | cut -f1 -d.)
VER_MINOR := $(shell echo $(VERSION) | cut -f2 -d.)
Mm        := $(VER_MAJOR).$(VER_MINOR)

.PHONY: docker-manifest
docker-manifest:
	docker manifest create -a $(IMAGE):$(VERSION) $(foreach PLATFORM,$(DOCKER_PLATFORMS),$(IMAGE):$(VERSION)_$(subst /,_,$(PLATFORM)))
	docker manifest push $(IMAGE):$(VERSION)
	docker manifest create -a $(IMAGE):$(Mm) $(foreach PLATFORM,$(DOCKER_PLATFORMS),$(IMAGE):$(VERSION)_$(subst /,_,$(PLATFORM)))
	docker manifest push $(IMAGE):$(Mm)

.PHONY: release
release:
	@$(MAKE) all-push docker-manifest --no-print-directory

# make and load docker image to kind cluster
.PHONY: push-to-kind
push-to-kind: container
	@echo "Loading docker image into kind cluster...."
	@kind load docker-image $(IMAGE):$(TAG)
	@echo "Image has been pushed successfully into kind cluster."
