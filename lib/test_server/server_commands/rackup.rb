# encoding: utf-8
module TestServer
  module ServerCommands
    class Rackup

      private

      attr_reader :environment, :pid_file, :config_file, :host, :port

      public

      def initialize(options = {})
        @environment = options.fetch(:environment, :development)
        @pid_file    = options.fetch(:pid_file, TestServer.config.pid_file)
        @config_file = options.fetch(:config_file, ::File.expand_path('../../../../config.ru', __FILE__))
        listen       = options.fetch(:listen, '127.0.0.1:8080')

        begin
          uri = Addressable::URI.heuristic_parse(listen)
        rescue StandardError => e
          fail Exceptions::ServerListenStatementInvalid, "I cannot parse the listen statement: #{listen}. It is invalid: #{e.message}"
        end

        @port        = uri.port
        @host        = uri.host
      rescue KeyError => e
        raise ArgumentError, e.message
      end

      def to_s
        cmd = []

        cmd << 'rackup'
        cmd << "-E #{environment}" if environment
        cmd << "-P #{pid_file}" if pid_file
        cmd << "-o #{host}" if host
        cmd << "-p #{port}" if port
        cmd << config_file if config_file

        cmd.join(" ")
      end
    end
  end
end
