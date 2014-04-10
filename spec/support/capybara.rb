# encoding: utf-8
require 'capybara/rspec'
require 'capybara/rails'

module TestServer
  module SpecHelper
    module Capybara
      include ::Capybara::DSL
    end
  end
end

RSpec.configure do |c|
  c.include TestServer::SpecHelper::Capybara
  c.before(:all) do
    Capybara.default_driver    = :rack_test
    Capybara.javascript_driver = :poltergeist
  end
end

