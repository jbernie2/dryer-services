#!/usr/bin/env bash

gem build $1

gem_build_file=$(ruby -e "
  require 'rubygems'
  spec = Gem::Specification::load('$1')
  puts \"#{spec.name}-#{spec.version}.gem\"
")

gem push $gem_build_file
