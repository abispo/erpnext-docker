PATH         := /opt/docker_utils/bin:$(PATH)
SHELL        := env PATH=$(PATH) /bin/bash
REGISTRY     ?= quay.io
IMAGE        ?= seibertmedia/erpnext
VERSION      ?= latest
VERSIONS     = $(VERSION)
VERSIONS     += $(shell git fetch --tags; git tag -l --points-at HEAD)

default: build

all: build upload clean

build:
	@tags=""; \
	for i in $(VERSIONS); do \
		tags="$$tags -t $(REGISTRY)/$(IMAGE):$$i"; \
	done; \
	echo "docker build --no-cache --rm=true $$tags ."; \
	docker build --no-cache --rm=true $$tags .

clean:
	@for i in $(VERSIONS); do \
		echo "docker rmi $(REGISTRY)/$(IMAGE):$$i"; \
		docker rmi $(REGISTRY)/$(IMAGE):$$i || true; \
	done

upload:
	@for i in $(VERSIONS); do \
		exists=`docker-remote-tag-exists \
			-registry=${REGISTRY} \
			-repository="${IMAGE}" \
			-tag="$$i" \
			-alsologtostderr \
			-v=0`; \
		if [ "$${exists}" = "false" ] || [ "$$i" = "master" ] || [ "$$i" = "test" ]; then \
			docker push $(REGISTRY)/$(IMAGE):$$i; \
		else \
			echo "$(REGISTRY)/$(IMAGE):$$i already exists => skip"; \
		fi; \
	done

versions:
	@for i in $(VERSIONS); do echo $$i; done;

open:
	open http://127.0.0.1:8080

exec:
	docker exec -ti erpnext bash

logs:
	docker logs erpnext -f

run:
	docker-compose up -d
	docker-compose logs -f --tail=10 
