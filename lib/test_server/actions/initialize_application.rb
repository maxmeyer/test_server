module TestServer
  module Actions
    class InitializeApplication

      private

      attr_reader :config, :options

      public

      def initialize(options = {}, config = TestServer.config)
        @options = options
        @config  = config
      end

      def run
        create_pid_directory if options[:create_pid_directory]
        create_log_directory if options[:create_log_directory]
        create_sass_cache if options[:create_sass_cache]
        create_local_storage if options[:create_local_storage]
        create_pre_receive_hook if options[:create_pre_receive_hook]
        create_config_file if options[:create_config_file]
        pre_seed if options[:pre_seed]

        show_example_config
      end

      private

      def create_pid_directory
        TestServer.ui_logger.info "Creating pid directory: #{::File.dirname(config.pid_file)}"
        Actions::CreateDirectory.new(::File.dirname(config.pid_file), force: options[:force]).run
      end

      def create_log_directory
        TestServer.ui_logger.info "Creating log directory: #{::File.dirname(config.access_log)}"
        Actions::CreateDirectory.new(::File.dirname(config.access_log), force: options[:force]).run
      end

      def create_sass_cache
        TestServer.ui_logger.info "Creating sass cache #{config.sass_cache}"
        Actions::CreateDirectory.new(config.sass_cache, force: options[:force]).run
      end

      def create_config_file
        TestServer.ui_logger.info "Creating config file at \"#{config.config_file}\"."
        Actions::CreateFile.new(:'example-config', config.config_file, TestServer::Data.new(config), force: options[:force], create_directories: true).run
      end

      def show_example_config
        TestServer.ui_logger.info "Showing the configuration of local_pac on your system."
        Actions::CreateOutput.new(:'example-config', $stdout, Data.new(config)).run
      end
    end
  end
end
