# encoding: utf-8
module TestServer
  module Actions
    class SendSignal
      private

      attr_reader :signal, :pid_file, :signalizer

      public

      def initialize(signal, pid_file = TestServer.config.pid_file, signalizer = Process)
        @signal     = signal
        @pid_file   = pid_file
        @signalizer = signalizer
      end

      def run
        signalizer.kill signal, pid
      rescue Exceptions::PidFileDoesNotExist
        TestServer.ui_logger.error "Pid-file \"#{pid_file}\" does not exist. I'm not able to send daemon signal \"#{signal}\"."
      end

      private

      def pid
        ::File.read(pid_file).to_i
      rescue Errno::ENOENT => e
        raise Exceptions::PidFileDoesNotExist, e.message
      end
    end
  end
end
