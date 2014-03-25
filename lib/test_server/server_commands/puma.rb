# encoding: utf-8
module TestServer
  module ServerCommands
    class Puma

      private

      attr_reader :environment, :pid_file, :config_file, :listen, :worker_count

      public

      def initialize(options = {})
        @environment  = options.fetch(:environment, :development)
        @pid_file     = options.fetch(:pid_file, TestServer.config.pid_file)
        @config_file  = options.fetch(:config_file, ::File.expand_path('../../../../config.ru', __FILE__))
        @listen       = options.fetch(:listen, 'tcp://127.0.0.1:8080')
        @worker_count = options.fetch(:worker_count, nil)

      rescue KeyError => e
        raise ArgumentError, e.message
      end

      def to_s
        cmd = []

        cmd << 'puma'
        cmd << "-e #{environment}" if environment
        cmd << "--pidfile #{pid_file}" if pid_file
        cmd << "-b #{listen}" if listen
        cmd << "-w #{worker_count}" if worker_count
        cmd << config_file if config_file

        cmd.join(" ")
      end
    end
  end
end
