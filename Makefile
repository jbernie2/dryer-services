.DEFAULT_GOAL := help
GEMSPEC_FILE=$$(find .  -name "*.gemspec")

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: env
env: ## gem dev env, all other tasks can be run once in this env
	nix \
		--extra-experimental-features 'nix-command flakes' build \
		-o ./result/updateDeps ".#updateDeps"\
	&& nix \
		--extra-experimental-features 'nix-command flakes' build \
		-o ./result/releaseToGithub ".#releaseToGithub"\
	&& nix \
		--extra-experimental-features 'nix-command flakes' build \
		-o ./result/releaseToRubygems ".#releaseToRubygems"\
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
	./result/updateDeps/bin/updateDeps

.PHONY: release
release: ## release to github and rubygems.org
	$(MAKE) release-to-github
	$(MAKE) release-to-rubygems

.PHONY: release-to-github
release-to-github: ## release to github
	./result/releaseToGithub/bin/releaseToGithub $(GEMSPEC_FILE)

.PHONY: release-to-rubygems
release-to-rubygems: ## release to rubygems.org
	./result/releaseToRubygems/bin/releaseToRubygems $(GEMSPEC_FILE)
