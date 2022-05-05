.PHONY: bats publish test tests version

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export BASH_ENV := /etc/profile
basename := $(shell basename $(DIR))

bats:
	@! brew list bats &>/dev/null || brew uninstall bats
	@brew bundle --file tests/Brewfile --quiet --no-lock | grep -v "^Using"

main: tests
	@git add -A && git commit --quiet -a -m "auto" && git push --quiet && brew reinstall --quiet $(basename)

tests:
	@true
