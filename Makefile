MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

shell_scripts := $(shell find . -name '*.sh')

.PHONY: format
.PHONY: lint
.PHONY: test

.PHONY: format-lua
format: format-lua
format-lua:
	stylua -a .

.PHONY: format-brew-formulae
format: format-brew-formulae
format-brew-formulae:
	sort -o brew-formulae.txt brew-formulae.txt

.PHONY: format-shell
format: format-shell
format-shell:
	shfmt -w $(shell_scripts)

.PHONY: lint-shell
lint: lint-shell
lint-shell:
	shellcheck $(shell_scripts)

.PHONY: test-bats
test: test-bats
test-bats:
	bats tests/
