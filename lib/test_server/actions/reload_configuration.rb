# encoding: utf-8
module TestServer
  module Actions
    class ReloadConfiguration

      private

      attr_reader :config

      public

      def initialize(config = Config.new)
        @config = config
      end

      def run
        TestServer.config = config
      end
    end
  end
end
