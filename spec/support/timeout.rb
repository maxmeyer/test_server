# encoding: utf-8
require 'timeout'

module TestServer
  module SpecHelper
    module Timeout
      def run_for(seconds, &block)
        ::Timeout::timeout(seconds, &block)
      rescue ::Timeout::Error
      end
    end
  end
end

RSpec.configure do |c|
  c.include TestServer::SpecHelper::Timeout
end

