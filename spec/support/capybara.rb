module TestServer
  module SpecHelper
    module Capybara
      include ::Capybara::DSL
    end
  end
end

RSpec.configure do |c|
  c.include TestServer::SpecHelper::Capybara
end
