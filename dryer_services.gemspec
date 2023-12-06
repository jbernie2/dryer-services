Gem::Specification.new do |spec|
  spec.name                  = 'dryer_services'
  spec.version               = "1.0.0"
  spec.authors               = ['John Bernier']
  spec.email                 = ['john.b.bernier@gmail.com']
  spec.summary               = 'A service object leveraging the dry-monads gem'
  spec.description           = <<~DOC
    An extension of the Dry family of gems (dry-rb.org).
    This gem provides a base service class that leverages the dry-monads gem
    to build composable service objects.
  DOC
  spec.homepage              = 'https://github.com/jbernie2/dryer_services'
  spec.license               = 'MIT'
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.0.0'
  spec.files = Dir[
    'README.md',
    'LICENSE',
    'CHANGELOG.md',
    'lib/**/*.rb',
    'dryer_services.gemspec',
    '.github/*.md',
    'Gemfile'
  ]
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "debug", "~> 1.8"
end
