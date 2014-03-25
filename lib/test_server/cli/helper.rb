# encoding: utf-8
module TestServer
  module Cli
    module Helper
      def pid(config = TestServer.config)
        ::File.read(config.pid_file).chomp
      rescue Errno::ENOENT
        'Stale PID-file'
      end
    end
  end
end
