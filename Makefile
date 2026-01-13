MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

.PHONY: format
format: format-lua

.PHONY: format-lua
format-lua:
	stylua -a .

.PHONY: lint
lint: lint-shell

.PHONY: lint-shell
lint-shell:
	shellcheck *.sh
