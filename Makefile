SHELL 				:= /bin/bash
PUBLIC_IMAGE_REPO	?= tokaido/
PRIVATE_IMAGE_REPO	?= asia.gcr.io/a1-cw-ironstar-io/

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
	@$(MAKE) build-php71
	@$(MAKE) build-php71-fpm
	@$(MAKE) build-admin71
	@$(MAKE) build-admin71-heavy
	@$(MAKE) build-php72
	@$(MAKE) build-php72-fpm
	@$(MAKE) build-admin72
	@$(MAKE) build-admin72-heavy
	@$(MAKE) build-php73
	@$(MAKE) build-php73-fpm
	@$(MAKE) build-admin73
	@$(MAKE) build-admin73-heavy
	@$(MAKE) build-proxy
	@$(MAKE) build-nginx
	@$(MAKE) build-cron
	@$(MAKE) build-logrotate
	@$(MAKE) build-haproxy
	@$(MAKE) build-varnish
	@$(MAKE) build-system-cron

.PHONY: deploy-all
deploy-all:
	@$(MAKE) deploy-base
	@$(MAKE) deploy-php71
	@$(MAKE) deploy-php71-fpm
	@$(MAKE) deploy-admin71
	@$(MAKE) deploy-admin71-heavy
	@$(MAKE) deploy-php72
	@$(MAKE) deploy-php72-fpm
	@$(MAKE) deploy-admin72
	@$(MAKE) deploy-admin72-heavy
	@$(MAKE) deploy-php73
	@$(MAKE) deploy-php73-fpm
	@$(MAKE) deploy-admin73
	@$(MAKE) deploy-admin73-heavy
	@$(MAKE) deploy-proxy
	@$(MAKE) deploy-nginx
	@$(MAKE) deploy-cron
	@$(MAKE) deploy-logrotate
	@$(MAKE) deploy-haproxy
	@$(MAKE) deploy-varnish
	@$(MAKE) deploy-system-cron


.PHONY: build-base
build-base:
	cd base && docker build . -t tokaido/base:${TOKAIDO_VERSION}

.PHONY: build-syslog
build-syslog:
	cd syslog && docker build . -t tokaido/syslog:${TOKAIDO_VERSION}

.PHONY: build-php71
build-php71:
	cd php71 && docker build . -t tokaido/php71:${TOKAIDO_VERSION}

.PHONY: build-php71-fpm
build-php71-fpm:
	cd php71-fpm && docker build . -t tokaido/php71-fpm:${TOKAIDO_VERSION}

.PHONY: build-admin71
build-admin71:
	cd admin71 && docker build . -t tokaido/admin71:${TOKAIDO_VERSION}

.PHONY: build-admin71-heavy
build-admin71-heavy:
	cd admin71 && docker build . -t tokaido/admin71-heavy:${TOKAIDO_VERSION}

.PHONY: build-php72
build-php72:
	cd php72 && docker build . -t tokaido/php72:${TOKAIDO_VERSION}

.PHONY: build-php72-fpm
build-php72-fpm:
	cd php72-fpm && docker build . -t tokaido/php72-fpm:${TOKAIDO_VERSION}

.PHONY: build-admin72
build-admin72:
	cd admin72 && docker build . -t tokaido/admin72:${TOKAIDO_VERSION}

.PHONY: build-admin72-heavy
build-admin72-heavy:
	cd admin72 && docker build . -t tokaido/admin72-heavy:${TOKAIDO_VERSION}

.PHONY: build-php73
build-php73:
	cd php73 && docker build . -t tokaido/php73:${TOKAIDO_VERSION}

.PHONY: build-php73-fpm
build-php73-fpm:
	cd php73-fpm && docker build . -t tokaido/php73-fpm:${TOKAIDO_VERSION}

.PHONY: build-admin73
build-admin73:
	cd admin73 && docker build . -t tokaido/admin73:${TOKAIDO_VERSION}

.PHONY: build-admin73-heavy
build-admin73-heavy:
	cd admin73 && docker build . -t tokaido/admin73-heavy:${TOKAIDO_VERSION}

.PHONY: build-proxy
build-proxy:
	cd proxy && docker build . -t tokaido/proxy:${TOKAIDO_VERSION}

.PHONY: build-nginx
build-nginx:
	cd nginx && docker build . -t tokaido/nginx:${TOKAIDO_VERSION}

.PHONY: build-cron
build-cron:
	cd cron && docker build . -t tokaido/cron:${TOKAIDO_VERSION}

.PHONY: build-logrotate
build-logrotate:
	cd logrotate && docker build . -t tokaido/logrotate:${TOKAIDO_VERSION}

.PHONY: build-haproxy
build-haproxy:
	cd haproxy && docker build . -t tokaido/haproxy:${TOKAIDO_VERSION}


.PHONY: build-varnish
build-varnish:
	cd varnish && docker build . -t tokaido/varnish:${TOKAIDO_VERSION}


.PHONY: build-system-cron
build-system-cron:
	cd system-cron && docker build . -t tokaido/system-cron:${TOKAIDO_VERSION}

.PHONY: deploy-base
deploy-base:
	docker push tokaido/base:${TOKAIDO_VERSION}
	docker tag tokaido/base:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-base:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-base:${TOKAIDO_VERSION}

.PHONY: deploy-php71
deploy-php71:
	docker push tokaido/php71:${TOKAIDO_VERSION}
	docker tag tokaido/php71:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-php71:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-php71:${TOKAIDO_VERSION}

.PHONY: deploy-php71-fpm
deploy-php71-fpm:
	docker push tokaido/php71-fpm:${TOKAIDO_VERSION}
	docker tag tokaido/php71-fpm:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-php71-fpm:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-php71-fpm:${TOKAIDO_VERSION}

.PHONY: deploy-admin71
deploy-admin71:
	docker push tokaido/admin71:${TOKAIDO_VERSION}
	docker tag tokaido/admin71:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-admin71:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-admin71:${TOKAIDO_VERSION}

.PHONY: deploy-admin71-heavy
deploy-admin71-heavy:
	docker push tokaido/admin71-heavy:${TOKAIDO_VERSION}
	docker tag tokaido/admin71-heavy:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-admin71-heavy:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-admin71-heavy:${TOKAIDO_VERSION}

.PHONY: deploy-deploy-admin71
deploy-deploy-admin71:
	docker push tokaido/deploy-admin71:${TOKAIDO_VERSION}
	docker tag tokaido/deploy-admin71:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-deploy-admin71:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-deploy-admin71:${TOKAIDO_VERSION}

.PHONY: deploy-php72
deploy-php72:
	docker push tokaido/php72:${TOKAIDO_VERSION}
	docker tag tokaido/php72:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-php72:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-php72:${TOKAIDO_VERSION}

.PHONY: deploy-php72-fpm
deploy-php72-fpm:
	docker push tokaido/php72-fpm:${TOKAIDO_VERSION}
	docker tag tokaido/php72-fpm:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-php72-fpm:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-php72-fpm:${TOKAIDO_VERSION}

.PHONY: deploy-admin72
deploy-admin72:
	docker push tokaido/admin72:${TOKAIDO_VERSION}
	docker tag tokaido/admin72:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-admin72:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-admin72:${TOKAIDO_VERSION}

.PHONY: deploy-admin72-heavy
deploy-admin72-heavy:
	docker push tokaido/admin72-heavy:${TOKAIDO_VERSION}
	docker tag tokaido/admin72-heavy:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-admin72-heavy:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-admin72-heavy:${TOKAIDO_VERSION}

.PHONY: deploy-deploy-admin72
deploy-deploy-admin72:
	docker push tokaido/deploy-admin72:${TOKAIDO_VERSION}
	docker tag tokaido/deploy-admin72:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-deploy-admin72:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-deploy-admin72:${TOKAIDO_VERSION}

.PHONY: deploy-php73
deploy-php73:
	docker push tokaido/php73:${TOKAIDO_VERSION}
	docker tag tokaido/php73:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-php73:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-php73:${TOKAIDO_VERSION}

.PHONY: deploy-php73-fpm
deploy-php73-fpm:
	docker push tokaido/php73-fpm:${TOKAIDO_VERSION}
	docker tag tokaido/php73-fpm:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-php73-fpm:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-php73-fpm:${TOKAIDO_VERSION}

.PHONY: deploy-admin73
deploy-admin73:
	docker push tokaido/admin73:${TOKAIDO_VERSION}
	docker tag tokaido/admin73:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-admin73:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-admin73:${TOKAIDO_VERSION}

.PHONY: deploy-admin73-heavy
deploy-admin73-heavy:
	docker push tokaido/admin73-heavy:${TOKAIDO_VERSION}
	docker tag tokaido/admin73-heavy:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-admin73-heavy:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-admin73-heavy:${TOKAIDO_VERSION}

.PHONY: deploy-deploy-admin73
deploy-deploy-admin73:
	docker push tokaido/deploy-admin73:${TOKAIDO_VERSION}
	docker tag tokaido/deploy-admin73:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-deploy-admin73:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-deploy-admin73:${TOKAIDO_VERSION}

.PHONY: deploy-proxy
deploy-proxy:
	docker push tokaido/proxy:${TOKAIDO_VERSION}
	docker tag tokaido/proxy:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-proxy:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-proxy:${TOKAIDO_VERSION}

.PHONY: deploy-nginx
deploy-nginx:
	docker push tokaido/nginx:${TOKAIDO_VERSION}
	docker tag tokaido/nginx:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-nginx:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-nginx:${TOKAIDO_VERSION}


.PHONY: deploy-cron
deploy-cron:
	docker push tokaido/cron:${TOKAIDO_VERSION}
	docker tag tokaido/cron:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-cron:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-cron:${TOKAIDO_VERSION}


.PHONY: deploy-logrotate
deploy-logrotate:
	docker push tokaido/logrotate:${TOKAIDO_VERSION}
	docker tag tokaido/logrotate:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-logrotate:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-logrotate:${TOKAIDO_VERSION}


.PHONY: deploy-haproxy
deploy-haproxy:
	docker push tokaido/haproxy:${TOKAIDO_VERSION}
	docker tag tokaido/haproxy:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-haproxy:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-haproxy:${TOKAIDO_VERSION}


.PHONY: deploy-varnish
deploy-varnish:
	docker push tokaido/varnish:${TOKAIDO_VERSION}
	docker tag tokaido/varnish:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-varnish:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-varnish:${TOKAIDO_VERSION}

.PHONY: deploy-system-cron
deploy-system-cron:
	docker push tokaido/system-cron:${TOKAIDO_VERSION}
	docker tag tokaido/system-cron:${TOKAIDO_VERSION} asia.gcr.io/a1-cw-ironstar-io/tokaido-system-cron:${TOKAIDO_VERSION}
	docker push asia.gcr.io/a1-cw-ironstar-io/tokaido-system-cron:${TOKAIDO_VERSION}
