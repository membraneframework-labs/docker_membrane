VERSION ?= latest
FLAVOR ?= focal
IMAGE ?= membrane/membrane
DIR ?= `pwd`

build:
	docker build -t $(IMAGE):$(FLAVOR) -t $(IMAGE):$(VERSION) $(FLAVOR)

run:
	docker run -it --rm -v $(DIR):/app $(IMAGE):$(VERSION) /bin/bash
