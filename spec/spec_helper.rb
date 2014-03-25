# encoding: utf-8
$LOAD_PATH << ::File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.command_name 'rspec'
SimpleCov.start

# Pull in all of the gems including those in the `test` group
require 'bundler'
Bundler.require :default, :test, :development

require 'test_server'

require File.expand_path('../../app/controllers/application_controller.rb', __FILE__)
Dir.glob(::File.expand_path('../../app/controllers/*.rb', __FILE__)).each { |f| require f }

# Loading support files
Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }

include TestServer
