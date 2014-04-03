module TestServer
  module SpecHelper
    module Capybara
      include ::Capybara::DSL
    end
  end
end

RSpec.configure do |c|
  c.include TestServer::SpecHelper::Capybara
  c.beforc(:all) do
    Capybara.default_engine = :rack_test
    Capybara.javascript_engine = :poltergeist
  end
end

