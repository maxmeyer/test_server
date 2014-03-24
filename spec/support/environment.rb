# encoding: utf-8
require 'fedux_org/stdlib/environment'

module TestServer
  module SpecHelper
    module Environment
      include FeduxOrg::Stdlib::Environment
      alias_method :with_environment, :isolated_environment 

      def mock_stdin(&block)
        old_stdin = $stdin
        $stdin = double('stdin')

        block.call
      ensure
        $stdin = old_stdin
      end
    end
  end
end

RSpec.configure do |c|
  c.include TestServer::SpecHelper::Environment
  c.before(:suite) do
    %w{
      http_proxy
      https_proxy
      HTTP_PROXY
      HTTPS_PROXY
    }.each { |var| ENV.delete(var) }
  end
end

