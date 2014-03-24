# encoding: utf-8

module TestServer
  module SpecHelper
    module Example
      def example_file(path)
        File.expand_path("../../examples/#{path}", __FILE__)
      end
    end
  end
end

RSpec.configure do |c|
  c.include TestServer::SpecHelper::Example
end

