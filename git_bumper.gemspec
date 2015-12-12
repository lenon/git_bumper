# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_bumper/version'

Gem::Specification.new do |spec|
  spec.name          = 'git_bumper'
  spec.version       = GitBumper::VERSION
  spec.authors       = ['Lenon Marcel']
  spec.email         = ['lenon.marcel@gmail.com']

  spec.summary       = 'A CLI utility to bump git tags.'
  spec.description   = 'A CLI utility to bump git tags.'
  spec.homepage      = 'https://github.com/lenon/git_bumper'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ['git-bump']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
