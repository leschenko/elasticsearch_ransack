# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elastic_ransack/version'

Gem::Specification.new do |spec|
  spec.name          = 'elastic_ransack'
  spec.version       = ElasticRansack::VERSION
  spec.authors       = ['Alex Leschenko']
  spec.email         = %w(leschenko.al@gmail.com)
  spec.summary       = %q{Search conditions adapter for elasticsearch models like ransack}
  spec.description   = %q{Search with conditions using predicates such as 'name_cont' or 'created_at_gt' for elasticsearch models}
  spec.homepage      = 'https://github.com/leschenko/elastic_ransack'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_dependency 'tire', '~> 0.6.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'bundler', '~> 1.3'
end
