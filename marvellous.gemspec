# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marvellous/version'

Gem::Specification.new do |spec|
  spec.name          = "marvellous"
  spec.version       = Marvellous::VERSION
  spec.authors       = ["Nikhil Goyal"]
  spec.email         = ["nikhilgoyal22@gmail.com"]
  spec.description   = %q{Marvel Comics API Wrapper}
  spec.summary       = %q{Marvel Comics API Wrapper}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  spec.files = Dir["{lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path = "lib"

  if RUBY_VERSION == '1.9.2'
    spec.add_dependency "httparty", "0.8.3"
  else
    spec.add_dependency "httparty", "~> 0.12.0"
  end

  spec.add_dependency "hashie", "~> 2.0"

  spec.add_development_dependency "bundler", '~> 1.3'
  spec.add_development_dependency "rake", '~>12.2'
  spec.add_development_dependency "pry", '~> 0'
  spec.add_development_dependency "byebug", '~> 9.1'
end
