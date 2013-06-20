# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tire_ransack/version'

Gem::Specification.new do |spec|
  spec.name          = 'tire_ransack'
  spec.version       = TireRansack::VERSION
  spec.authors       = ['Alex Leschenko']
  spec.email         = %w(leschenko.al@gmail.com)
  spec.summary       = %q{Conditions searching adapter for elasticsearch like ransack}
  spec.description   = %q{Search using predicates for conditions like 'name_cont' or 'category_id_in' for elasticsearch models}
  spec.homepage      = 'https://github.com/leschenko/tire_ransack'
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
