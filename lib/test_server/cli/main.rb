# encoding: utf-8
module TestServer
  module Cli
    class Main < Thor
      class_option :config_file, type: :string, desc: 'Config file'
      class_option :log_level, default: 'info', type: :string, desc: 'Log level for ui logging'
      class_option :debug_mode, type: :boolean, desc: 'Run application in debug mode'

      desc 'serve', 'Serve pacfiles'
      option :access_log, type: :string, desc: 'File to write access log to'
      option :listen, type: :string, desc: 'Listen for requests'
      option :environment, type: :string, desc: 'Rack environment for application'
      option :worker_count, type: :numeric, desc: 'Count of workers'
      option :with, type: :string, default: 'puma', desc: 'Server used to serve proxy pac'
      def serve
        TestServer.config = TestServer::Config.new(options[:config_file]) if options[:config_file]
        TestServer.config.access_log = options[:access_log] if options[:access_log]
        TestServer.config.log_level = options[:log_level] if options[:log_level]
        TestServer.config.debug_mode = options[:debug_mode] if options[:debug_mode]
        TestServer.config.environment = options[:environment] if options[:environment]
        TestServer.config.worker_count = options[:worker_count] if options[:worker_count]
        TestServer.config.listen = options[:listen] if options[:listen]
        TestServer.config.lock

        TestServer.ui_logger.level = TestServer.config.log_level
        TestServer.enable_debug_mode if TestServer.config.debug_mode

        TestServer.ui_logger.debug('Options: ' + options.to_s)
        TestServer.ui_logger.debug("Config:\n" + TestServer.config.to_s)

        command_klass = case options[:with].to_sym
                 when :puma
                   ServerCommands::Puma
                 when :rackup
                   ServerCommands::Rackup
                 else
                   ServerCommands::Rackup
                 end

        command = command_klass.new(
          listen: TestServer.config.listen,
          environment: TestServer.config.environment,
          worker_count: TestServer.config.worker_count,
        )

        ENV['DEBUG']      = TestServer.config.debug_mode.to_s if TestServer.config.debug_mode
        ENV['ACCESS_LOG'] = TestServer.config.access_log.to_s if TestServer.config.access_log
        ENV['LOG_LEVEL']  = TestServer.config.log_level.to_s  if TestServer.config.log_level

        Server.new(command).start
      end

      desc 'init', 'Create files/directories to use local_pac in dir or $PWD'
      option :force, type: :boolean, default: false, desc: 'Overwrite existing files?'
      option :pre_seed, type: :boolean, default: false, desc: 'Add some example files to git repository'
      option :config_file, type: :string, desc: 'Path to config file'

      option :pid_file, type: :string, desc: 'Path to pid file'
      option :access_log, type: :string, desc: 'Path to access log'
      option :sass_cache, type: :string, desc: 'Path to sass cache'
      option :reload_config_signal, type: :string, desc: 'Signal to reload config'
      option :listen, type: :string, desc: 'Listen statement for rack server'
      option :environment, type: :string, desc: 'Default environment for rack server'

      option :create_pid_directory, type: :boolean, desc: 'Create pid directory', default: true
      option :create_log_directory, type: :boolean, desc: 'Create log directory', default: true
      option :create_sass_cache, type: :boolean, desc: 'Create sass cache directory', default: true
      option :create_config_file, type: :boolean, desc: 'Create config_directory', default: true
      def init
        TestServer.config = TestServer::Config.new(options[:config_file]) if options[:config_file]

        TestServer.config.log_level             = options[:log_level]              if options[:log_level]
        TestServer.config.debug_mode            = options[:debug_mode]             if options[:debug_mode]
        TestServer.config.pid_file              = options[:pid_file]               if options[:pid_file]
        TestServer.config.access_log            = options[:access_log]             if options[:access_log]
        TestServer.config.sass_cache            = options[:sass_cache]             if options[:sass_cache]
        TestServer.config.reload_config_signal  = options[:reload_config_signal]   if options[:reload_config_signal]
        TestServer.config.log_level             = options[:log_level]              if options[:log_level]
        TestServer.config.listen                = options[:listen]                 if options[:listen]
        TestServer.config.environment           = options[:environment]            if options[:environment]

        TestServer.config.lock

        TestServer.ui_logger.level = TestServer.config.log_level
        TestServer.enable_debug_mode if TestServer.config.debug_mode

        TestServer.ui_logger.debug('Options: ' + options.to_s)
        TestServer.ui_logger.debug("Config:\n" + TestServer.config.to_s)

        Actions::InitializeApplication.new(
          force: options[:force], 
          pre_seed: options[:pre_seed],
          create_pid_directory: options[:create_pid_directory],
          create_log_directory: options[:create_log_directory],
          create_sass_cache: options[:create_sass_cache],
          create_config_file: options[:create_config_file],
        ).run
      end

      desc 'reload', 'Reload configuration, local storage etc.'
      option :pid_file, type: :string, desc: 'Pid file of daemon'
      subcommand 'reload', TestServer::Cli::Reload
    end
  end
end
