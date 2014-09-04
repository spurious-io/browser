# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spurious/browser/version'

Gem::Specification.new do |spec|
  spec.name          = "spurious-browser"
  spec.version       = Spurious::Browser::VERSION
  spec.authors       = ["Steven Jack"]
  spec.email         = ["stevenmajack@gmail.com"]
  spec.summary       = %q{GUI for spurious services}
  spec.description   = %q{A simple sinatra app that allows control of the various spurious services }
  spec.homepage      = "https://github.com/stevenjack/spurious-browser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "spurious"
  spec.add_runtime_dependency "spurious-ruby-awssdk-helper"
  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "mustache"
  spec.add_runtime_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rerun"
  spec.add_development_dependency "pry"
end
