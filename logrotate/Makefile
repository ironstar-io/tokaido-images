LOGROTATE_VERSION ?= "edge"

.PHONY all:
all: build deploy

.PHONY build:
build:
	docker build . -t ironstar/logrotate:${LOGROTATE_VERSION}

.PHONY deploy:
deploy:
	docker push ironstar/logrotate:${LOGROTATE_VERSION}

.PHONY run:
run:
	docker run --rm -it --entrypoint=bash ironstar/logrotate:edge