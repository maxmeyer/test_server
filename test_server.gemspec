# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test_server/version'

Gem::Specification.new do |spec|
  spec.name          = 'test_server'
  spec.version       = TestServer::VERSION
  spec.authors       = ['Dennis Günnewig']
  spec.email         = ['dg1@vrnetze.de']
  spec.summary       = %q{Test server for proxies}
  spec.description   = %q{Test server for proxies}
  #spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 1.5'

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'sass'
  spec.add_runtime_dependency 'haml', '~>4.0.0'
  spec.add_runtime_dependency 'uglifier'
  spec.add_runtime_dependency 'therubyracer'
  spec.add_runtime_dependency 'sprockets'
  spec.add_runtime_dependency 'sprockets-helpers'
  spec.add_runtime_dependency 'sprockets-sass'
  spec.add_runtime_dependency 'compass', '~>0.12.4'
  spec.add_runtime_dependency 'addressable'
  spec.add_runtime_dependency 'i18n'
  spec.add_runtime_dependency 'rack-contrib'
  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'activesupport', '~>4.0.0'
  spec.add_runtime_dependency 'pager'
  spec.add_runtime_dependency 'sinatra-param'
  spec.add_runtime_dependency 'sinatra-contrib'
  spec.add_runtime_dependency 'thor'
end
