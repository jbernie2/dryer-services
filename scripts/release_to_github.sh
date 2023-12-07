#!/usr/bin/env bash

gh auth login --hostname github.com

gem_version=$(ruby -e "
  require 'rubygems'
  puts Gem::Specification::load('$1').version
")
release_version="v$gem_version"
gh release create $release_version --generate-notes
