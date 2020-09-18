SHELL 				:= /bin/bash
PUBLIC_IMAGE_REPO	?= tokaido/
# PRIVATE_IMAGE_REPO	?= asia.gcr.io/a1-cw-ironstar-io/

# Tokaido Full Version, for example 1.10.3
ifndef TOKAIDO_VERSION
$(error TOKAIDO_VERSION is not set)
endif

help:
	@echo ''
	@echo 'Usage: make [TARGET] [EXTRA_ARGUMENTS]'
	@echo 'Targets:'
	@echo '  build    	    build docker --image--'
	@echo '  build-all      build all images'
	@echo '  deploy  	    uploads --image-- to public and private repos'
	@echo '  deploy-all    uploads all images to public and private repos'
	@echo ''
	@echo ''

.PHONY: build-all
build-all:
	@$(MAKE) build-base
	@$(MAKE) build-syslog
	@$(MAKE) build-php
	@$(MAKE) build-admin
	@$(MAKE) build-nginx
	@$(MAKE) build-cron
	@$(MAKE) build-logrotate
	@$(MAKE) build-haproxy
	@$(MAKE) build-varnish
	@$(MAKE) build-kishu
	@$(MAKE) build-system-cron

.PHONY: deploy-all
deploy-all:
	@$(MAKE) deploy-base
	@$(MAKE) deploy-syslog
	@$(MAKE) deploy-php
	@$(MAKE) deploy-admin
	@$(MAKE) deploy-nginx
	@$(MAKE) deploy-cron
	@$(MAKE) deploy-logrotate
	@$(MAKE) deploy-haproxy
	@$(MAKE) deploy-varnish
	@$(MAKE) deploy-kishu
	@$(MAKE) deploy-system-cron


.PHONY: build-base
build-base:
	cd base && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/base:${TOKAIDO_VERSION}

.PHONY: build-syslog
build-syslog:
	cd syslog && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/syslog:${TOKAIDO_VERSION}

.PHONY: build-php
build-php:
	cd php72 && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/php72:${TOKAIDO_VERSION}
	cd php73 && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/php73:${TOKAIDO_VERSION}
	cd php74 && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/php74:${TOKAIDO_VERSION}

.PHONY: build-admin
build-admin:
	cd admin && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} --build-arg PHP_VERSION_SHORT=72 -t tokaido/admin72:${TOKAIDO_VERSION}
	cd admin-heavy && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} --build-arg PHP_VERSION_SHORT=72 -t tokaido/admin72-heavy:${TOKAIDO_VERSION}

	cd admin && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} --build-arg PHP_VERSION_SHORT=73 -t tokaido/admin73:${TOKAIDO_VERSION}
	cd admin-heavy && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} --build-arg PHP_VERSION_SHORT=73 -t tokaido/admin73-heavy:${TOKAIDO_VERSION}

	cd admin && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} --build-arg PHP_VERSION_SHORT=74 -t tokaido/admin74:${TOKAIDO_VERSION}
	cd admin-heavy && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} --build-arg PHP_VERSION_SHORT=74 -t tokaido/admin74-heavy:${TOKAIDO_VERSION}

.PHONY: build-nginx
build-nginx:
	cd nginx && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/nginx:${TOKAIDO_VERSION}

.PHONY: build-cron
build-cron:
	cd cron && docker build . --build-arg PHP_VERSION_SHORT=72 --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/cron72:${TOKAIDO_VERSION}
	cd cron && docker build . --build-arg PHP_VERSION_SHORT=73 --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/cron73:${TOKAIDO_VERSION}
	cd cron && docker build . --build-arg PHP_VERSION_SHORT=74 --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/cron74:${TOKAIDO_VERSION}

.PHONY: build-logrotate
build-logrotate:
	cd logrotate && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/logrotate:${TOKAIDO_VERSION}

.PHONY: build-haproxy
build-haproxy:
	cd haproxy && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/haproxy:${TOKAIDO_VERSION}

.PHONY: build-varnish
build-varnish:
	cd varnish && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/varnish:${TOKAIDO_VERSION}

.PHONY: build-kishu
build-kishu:
	cd kishu && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/kishu:${TOKAIDO_VERSION}

.PHONY: build-system-cron
build-system-cron:
	cd system-cron && docker build . --build-arg TOKAIDO_VERSION=${TOKAIDO_VERSION} -t tokaido/system-cron:${TOKAIDO_VERSION}

.PHONY: deploy-base
deploy-base:
	# docker push tokaido/base:${TOKAIDO_VERSION}

.PHONY: deploy-syslog
deploy-syslog:
	# docker push tokaido/syslog:${TOKAIDO_VERSION}

.PHONY: deploy-php
deploy-php:
	docker push tokaido/php72:${TOKAIDO_VERSION}
	docker tag tokaido/php72:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-php72:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-php72:${TOKAIDO_VERSION}

	docker push tokaido/php73:${TOKAIDO_VERSION}
	docker tag tokaido/php73:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-php73:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-php73:${TOKAIDO_VERSION}

	docker push tokaido/php74:${TOKAIDO_VERSION}
	docker tag tokaido/php74:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-php74:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-php74:${TOKAIDO_VERSION}

.PHONY: deploy-admin
deploy-admin:
	# docker push tokaido/admin72:${TOKAIDO_VERSION}
	docker tag tokaido/admin72:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-admin72:${TOKAIDO_VERSION}
	# docker push tokaido/admin72-heavy:${TOKAIDO_VERSION}
	docker tag tokaido/admin72-heavy:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-admin72-heavy:${TOKAIDO_VERSION}

	# docker push tokaido/admin73:${TOKAIDO_VERSION}
	docker tag tokaido/admin73:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-admin73:${TOKAIDO_VERSION}
	# docker push tokaido/admin73-heavy:${TOKAIDO_VERSION}
	docker tag tokaido/admin73-heavy:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-admin73-heavy:${TOKAIDO_VERSION}

	# docker push tokaido/admin74:${TOKAIDO_VERSION}
	docker tag tokaido/admin74:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-admin74:${TOKAIDO_VERSION}
	# docker push tokaido/admin74-heavy:${TOKAIDO_VERSION}
	docker tag tokaido/admin74-heavy:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-admin74-heavy:${TOKAIDO_VERSION}


.PHONY: deploy-nginx
deploy-nginx:
	# docker push tokaido/nginx:${TOKAIDO_VERSION}
	docker tag tokaido/nginx:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-nginx:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-nginx:${TOKAIDO_VERSION}


.PHONY: deploy-cron
deploy-cron:
	# docker push tokaido/cron72:${TOKAIDO_VERSION}
	docker tag tokaido/cron72:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-cron72:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-cron72:${TOKAIDO_VERSION}

	# docker push tokaido/cron73:${TOKAIDO_VERSION}
	docker tag tokaido/cron73:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-cron73:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-cron73:${TOKAIDO_VERSION}

	# docker push tokaido/cron74:${TOKAIDO_VERSION}
	docker tag tokaido/cron74:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-cron74:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-cron74:${TOKAIDO_VERSION}

.PHONY: deploy-logrotate
deploy-logrotate:
	# docker push tokaido/logrotate:${TOKAIDO_VERSION}
	docker tag tokaido/logrotate:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-logrotate:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-logrotate:${TOKAIDO_VERSION}

.PHONY: deploy-haproxy
deploy-haproxy:
	# docker push tokaido/haproxy:${TOKAIDO_VERSION}
	docker tag tokaido/haproxy:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-haproxy:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-haproxy:${TOKAIDO_VERSION}

.PHONY: deploy-varnish
deploy-varnish:
	# docker push tokaido/varnish:${TOKAIDO_VERSION}
	docker tag tokaido/varnish:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-varnish:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-varnish:${TOKAIDO_VERSION}

.PHONY: deploy-kishu
deploy-kishu:
	# docker push tokaido/kishu:${TOKAIDO_VERSION}

.PHONY: deploy-system-cron
deploy-system-cron:
	# docker push tokaido/system-cron:${TOKAIDO_VERSION}
	docker tag tokaido/system-cron:${TOKAIDO_VERSION} ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-system-cron:${TOKAIDO_VERSION}
	docker push ${TOKAIDO_REGISTRY_SYDNEY}/tokaido-system-cron:${TOKAIDO_VERSION}
