include common.mk
include apps.mk

.PHONY: all
all: deploy-all

.PHONY: deploy-all
deploy-all: $(foreach app,$(APPS),deploy-$(app))

.PHONY: deploy-%
deploy-%:
	$(MAKE) -C $* deploy
