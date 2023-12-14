#!/usr/bin/env bash
set -e

$(dirname "$0")/assert_arg.sh $0 1 "gemspec file" $1
$(dirname "$0")/assert_env_var.sh $0 "GITHUB_TOKEN"

gh auth login --hostname github.com

gem_version=$(ruby -e "
  require 'rubygems'
  puts Gem::Specification::load('$1').version
")
release_version="v$gem_version"
gh release create $release_version --generate-notes
