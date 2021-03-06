# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require File.expand_path('../lib/roqua/healthy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "roqua-healthy"
  gem.version       = Roqua::Healthy::VERSION
  gem.summary       = 'Arranges communication between Mirth and RoQua'
  gem.description   = "Receives queries from RoQua, sends them to Mirth, and translates Mirth's responses back into Rubyland."
  gem.license       = "MIT"
  gem.authors       = ["Marten Veldthuis", "Jorn van de Beek", 'Samuel Esposito', 'Henk van der Veen']
  gem.email         = "support@roqua.nl"
  gem.homepage      = "https://github.com/roqua/healthy"

  gem.required_ruby_version = '~> 2.3'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = [] # executables in bin/ are helpers for use during development
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '>= 3.2', '< 6'
  gem.add_dependency 'addressable', '~> 2.3'
  gem.add_dependency 'roqua-support', '~> 0.1.22'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.3.0'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'appraisal'

  # Required for the tests
  gem.add_development_dependency 'webmock', '~> 1.13'

  # Workflow and tools
  gem.add_development_dependency 'guard', '~> 2.1'
  gem.add_development_dependency 'guard-rspec', '~> 4.2.4'
  gem.add_development_dependency 'listen', '~> 2.1'
  gem.add_development_dependency 'guard-rubocop', '~> 1.2.0'
  gem.add_development_dependency 'rubocop', '~> 0.40'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'fuubar'

  # Documentation generation
  gem.add_development_dependency 'kramdown', '1.2'
end
