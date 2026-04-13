MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

shell_scripts := $(shell find . -name '*.sh')

.PHONY: format
.PHONY: lint

.PHONY: format-lua
format: format-lua
format-lua:
	stylua -a .

.PHONY: lint-shell
lint: lint-shell
lint-shell:
	shellcheck $(shell_scripts)
