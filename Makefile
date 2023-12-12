.DEFAULT_GOAL := help
GEMSPEC_FILE=$$(find .  -name "*.gemspec")

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: env
env: ## gem dev env, all other tasks can be run once in this env
	nix \
		--extra-experimental-features 'nix-command flakes' build \
	&& nix \
		--extra-experimental-features 'nix-command flakes' \
		develop --ignore-environment \
		--show-trace \
		--keep HOME \
		--keep GITHUB_TOKEN \
		--keep GEM_HOST_API_KEY \
		--keep TERM # allows for interop with tmux

.PHONY: bundle
bundle: ## rebuild Gemfile.lock/gemset.nix from Gemfile
	./result/bin/update_deps

.PHONY: test
test: ## run tests
	bundle exec rspec $(test)

.PHONY: release
release: ## release to github and rubygems.org
	$(MAKE) release_to_github
	$(MAKE) release_to_rubygems

.PHONY: release_to_github
release_to_github: ## release to github
	./result/bin/release_to_github $(GEMSPEC_FILE)

.PHONY: release_to_rubygems
release_to_rubygems: ## release to rubygems.org
	./result/bin/release_to_rubygems $(GEMSPEC_FILE)
