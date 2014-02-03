# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth/shibboleth/passive/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name     = 'omniauth-shibboleth-passive'
  gem.version  = OmniAuth::Shibboleth::Passive::VERSION
  gem.authors  = ['Scot Dalton']
  gem.email    = ['scotdalton@gmail.edu']
  gem.summary  = 'OmniAuth strategy for Shibboleth in "passive mode"'
  gem.homepage = 'https://github.com/scotdalton/omniauth-shibboleth-passive'
  gem.license  = 'MIT'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'omniauth-shibboleth', '~> 1.1.0'

  gem.add_development_dependency 'omniauth', '~> 1.2.0'
  gem.add_development_dependency 'rake', '~> 10.1.0'
  gem.add_development_dependency 'rspec', '~> 2.14.0'
  gem.add_development_dependency 'rack-test', '~> 0.6.2'
  gem.add_development_dependency 'activesupport', '~> 4.0.2'
end
