.DEFAULT_GOAL := help
THEMIS_HOME := $(HOME)/.vim/pack/themis/start/vim-themis
THEMIS := $(THEMIS_HOME)/bin/themis

$(THEMIS):
	git clone https://github.com/thinca/vim-themis $(THEMIS_HOME)

.PHONY: test
test: $(THEMIS) ## Run all tests
	$(THEMIS) tests/**

.PHONY: help
help: ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
