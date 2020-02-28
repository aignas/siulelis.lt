ARGS?=--source ./hugo

init:
	echo "Setting up git hooks"
	git config core.hooksPath .githooks

.PHONY: check
check: build

.PHONY: assets
assets:
	mkdir -p hugo/assets/img
	cp artwork/favicon.png hugo/assets/img/favicon.png
	cp logos/logo.svg hugo/assets/img/logo.svg

.PHONY: build
build: assets hugo gc

.PHONY: gc
gc:
	@echo "Garbage collecting"
	@hugo $(ARGS) --gc

.PHONY: hugo
hugo:
	hugo $(ARGS) --destination ./public

.PHONY: serve
serve: assets
	hugo $(ARGS) serve