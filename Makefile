VERSION ?= latest
FLAVOR ?= jammy
IMAGE ?= membraneframeworklabs/docker_membrane
DIR ?= `pwd`

build:
	docker build -t $(IMAGE):$(FLAVOR) -t $(IMAGE):$(VERSION) $(FLAVOR)

run:
	docker run -it --rm -v $(DIR):/app $(IMAGE):$(VERSION) /bin/bash
