# -*- encoding: utf-8 -*-

require File.expand_path('../lib/healthy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "healthy"
  gem.version       = Healthy::VERSION
  gem.summary       = %q{Arranges communication between Mirth and RoQua}
  gem.description   = %q{Receives queries from RoQua, sends them to Mirth, and translates Mirth's responses back into Rubyland.}
  gem.license       = "MIT"
  gem.authors       = ["Marten Veldthuis"]
  gem.email         = "marten@roqua.nl"
  gem.homepage      = "https://github.com/roqua/healthy"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '~> 3.2'
  gem.add_dependency 'addressable', '~> 2.3'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'yard', '~> 0.8'

  # Required for the tests
  gem.add_development_dependency 'webmock', '~> 1.13'

  # Workflow and tools
  gem.add_development_dependency 'guard', '~> 1.8'
  gem.add_development_dependency 'guard-rspec', '~> 2.5'
  gem.add_development_dependency 'fuubar'

  # Documentation generation
  gem.add_development_dependency 'kramdown', '1.2'
end
