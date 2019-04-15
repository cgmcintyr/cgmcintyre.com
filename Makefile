BASEDIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
ZOLA:=$(BASEDIR)/bin/zola
BASEURL="http://cgmcintyre.com"


.PHONY: serve
serve:
	$(ZOLA) serve --port 1313


.PHONY: docs
docs:
	$(ZOLA) build --base-url $(BASEURL) --output-dir $(BASEDIR)/docs


.PHONY: new-post
new-post:
	TITLE="$$([ ! -z "$(TITLE)" ] && echo $(TITLE) || echo "new")"; \
	date -u +"%Y%m%d_%H%M%S_$$TITLE"
