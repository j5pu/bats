.PHONY: bats binsh cask commit main uninstall

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export BASH_ENV := /etc/profile
basename := $(shell basename $(DIR))

#bats:
#	@! brew list bats &>/dev/null || brew uninstall bats
#	@brew bundle --file tests/Brewfile --quiet --no-lock | grep -v "^Using"

bats:
	@brew reinstall --quiet $(basename)

binsh:
	@brew reinstall --quiet binsh

cask:
	@brew reinstall --cask --quiet $(basename)

commit:
	@test -z $$(git status --porcelain) || { git add -A && git commit --quiet -a -m "auto"; }

main:
	@for i in $${HOME}/bats $${HOME}/binsh $${HOME}/secrets $${HOME}/shrc $$(brew taps --path); do \
		cd $${i} \
		&& { test -z $$(git status --porcelain) || { git add -A && git commit --quiet -a -m "auto"; }; } \
		&& git push --quiet; \
	done; \
	@brew reinstall --quiet $(basename)
	@brew reinstall --quiet binsh
	@brew reinstall --quiet secrets

uninstall:
	@for i in bats binsh secrets bats-core bats-assert bats-file bats-support; do \
		brew uninstall $${i} || true; \
	done; \
	brew autoremove
