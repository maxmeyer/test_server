# encoding: utf-8
module TestServer
  class Config

    private

    attr_reader :config

    @options = Set.new
    @process_environment = ProcessEnvironment.new

    class << self

      public

      attr_reader :options, :process_environment

      def option_reader(option, default_value)
        define_method option.to_sym do
          config.fetch(option.to_sym, default_value)
        end

        @options << option
      end

      def option_writer(option)
        define_method "#{option}=".to_sym do |value|
          begin
            config[option.to_sym] = value
          rescue RuntimeError
            raise Exceptions::ConfigLocked
          end
        end

        @options << option
      end

      def option(option, default_value)
        option_reader(option, default_value)
        option_writer(option)
      end
    end

    public

    def initialize(file = available_config_file, config_engine = Psych)
      config_mutex = Mutex.new
      config_mutex.synchronize do
        yaml = Psych.load_file(file)

        if yaml.respond_to? :[]
          @config = yaml.symbolize_keys
        else
          @config = {}
        end
      end
    rescue StandardError => e
      fail Exceptions::ConfigFileNotReadable, JSON.dump(message: e.message, file: file)
    end

    def lock
      config.freeze
    end

    def to_s
      result = []
      result << sprintf("%20s | %s", 'option', 'value')
      result << sprintf("%s + %s", '-' * 20, '-' * 80)

      Config.options.each do |o|
        result << sprintf("%20s | %s", o, Array(public_send(o)).join(', '))
      end

      result.join("\n")
    end

    def allowed_config_file_paths
      [
        ::File.expand_path(::File.join(process_environment.fetch('HOME'), '.config', 'test_server', 'config.yaml')),
        ::File.expand_path(::File.join(process_environment.fetch('HOME'), '.test_server', 'config.yaml')),
        ::File.expand_path(::File.join('/etc', 'test_server', 'config.yaml')),
        ::File.expand_path('../../../files/config.yaml', __FILE__),
      ]
    end

    option :access_log, ::File.expand_path(::File.join(process_environment.fetch('HOME'), '.local', 'share', 'test_server', 'log', 'access.log'))
    option :config_file, ::File.expand_path(::File.join(process_environment.fetch('HOME'), '.config', 'test_server', 'config.yaml'))
    option :debug_mode, false
    option :environment, 'development'
    option :executable, ::File.expand_path(::File.expand_path('../../../bin/test_server', __FILE__))
    option :gem_path, Gem.path.collect {|p|::File.expand_path(p) }
    option :listen, 'tcp://127.0.0.1:8000'
    option :log_level, :info
    option :pid_file, ::File.expand_path(::File.join(process_environment.fetch('HOME'), '.local', 'share', 'test_server', 'run', 'pid'))
    option :reload_config_signal, :USR1
    option :reload_storage_signal, :USR2
    option :sass_cache, ::File.expand_path(::File.join(process_environment.fetch('HOME'), '.local', 'share', 'test_server', 'cache'))

    private

    def available_config_file
      allowed_config_file_paths.find { |f| ::File.exists? f }
    end

  end
end
