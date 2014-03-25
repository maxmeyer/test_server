# encoding: utf-8
module TestServer
  module Cli
    class Reload < Thor
      no_commands {
        include TestServer::Cli::Helper
      }

      desc 'configuration', 'Reload configuration'
      def configuration
        TestServer.config = TestServer::Config.new(options[:config_file]) if options[:config_file]
        TestServer.config.log_level = options[:log_level] if options[:log_level]
        TestServer.config.debug_mode = options[:debug_mode] if options[:debug_mode]
        TestServer.config.pid_file = options[:pid_file] if options[:pid_file] 
        TestServer.config.lock

        TestServer.ui_logger.level = TestServer.config.log_level
        TestServer.enable_debug_mode if TestServer.config.debug_mode

        TestServer.ui_logger.info "Ask web application (PID: #{pid(TestServer.config)}) to reload configuration"
        Actions::SendSignal.new(TestServer.config.reload_config_signal).run
      end

      desc 'local_storage', 'Reload local_storage'
      def local_storage
        TestServer.config = TestServer::Config.new(options[:config_file]) if options[:config_file]
        TestServer.config.log_level = options[:log_level] if options[:log_level]
        TestServer.config.debug_mode = options[:debug_mode] if options[:debug_mode]
        TestServer.config.pid_file = options[:pid_file] if options[:pid_file] 
        TestServer.config.lock

        TestServer.ui_logger.level = TestServer.config.log_level
        TestServer.enable_debug_mode if TestServer.config.debug_mode

        TestServer.ui_logger.info "Ask web application (PID: #{pid(TestServer.config)}) to reload storage"
        Actions::SendSignal.new(TestServer.config.reload_storage_signal).run
      end
    end
  end
end
