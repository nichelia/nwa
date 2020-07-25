SHELL := /bin/bash

MODULE=nwa
VERSION=$$(poetry version | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')

### Environment ###
.PHONY: env
env:
	./scripts/helpers/environment.sh

.PHONY: env-prod
env-prod:
	./scripts/helpers/environment.sh -p

.PHONY: env-update
env-update:
	./scripts/helpers/environment.sh -f

### PIP ###
.PHONY: build-package
build-package:
	poetry build

.PHONY: publish-package
publish-package:
	poetry publish

### Docker ###
.PHONY: build-docker-local
build-docker-local:
	./scripts/build_docker_image.sh -t

.PHONY: build-docker
build-docker:
	./scripts/build_docker_image.sh

### Lint ###
.PHONY: lint
lint:
	pre-commit run --all-files

### Test ###
.PHONY: test
test:
	pytest -v

.PHONY: test-coverage
test-coverage:
	pytest --cov=. --cov-report=xml

### Util ###
.PHONY : clean
clean :
	./scripts/helpers/cleanup.sh
