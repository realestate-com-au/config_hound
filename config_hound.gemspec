# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'config_hound/version'

Gem::Specification.new do |spec|

  spec.name          = "config_hound"
  spec.version       = ConfigHound::VERSION

  spec.summary       = %q{Sniffs out config, wherever it may be.}
  spec.license       = "MIT"

  spec.authors       = ["Mike Williams"]
  spec.email         = ["mdub@dogbiscuit.org"]
  spec.homepage      = "https://github.com/mdub/config_hound"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dig_rb"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 11.0"

end
