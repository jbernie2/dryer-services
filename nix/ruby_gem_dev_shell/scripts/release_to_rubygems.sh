#!/usr/bin/env bash
set -e

$(dirname "$0")/assert_arg.sh $0 1 "gemspec file" $1
$(dirname "$0")/assert_env_var.sh $0 "GEM_HOST_API_KEY"

gem build $1

gem_build_file=$(ruby -e "
  require 'rubygems'
  spec = Gem::Specification::load('$1')
  puts \"#{spec.name}-#{spec.version}.gem\"
")

gem push $gem_build_file
