include help.mk

.PHONY: install update

install:
	carthage bootstrap --platform iOS --no-use-binaries

update:
	carthage update --platform iOS --no-use-binaries

