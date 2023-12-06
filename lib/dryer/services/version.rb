require "rubygems"

module Dryer
  module Services
    VERSION = Gem::Specification::load(
      "./dryer_services.gemspec"
    ).version
  end
end
