# encoding: utf-8
module TestServer
  @config      = TestServer::Config.new
  @ui_logger   = TestServer::UiLogger.new

  class << self
    attr_accessor :environment, :config, :ui_logger

    def root_path
      ::File.expand_path('../../..', __FILE__)
    end

    def enable_debug_mode
      TestServer.ui_logger.info "Activating debug mode."

      require 'pry'
      require 'debugger'
    rescue LoadError
      TestServer.ui_logger.error "You tried to enable debug-mode, but either 'pry'- or 'debugger'-gem are not installed. Please fix that before using the debug-switch again."
    end

    def configure_i18n
      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.load_path = Dir[::File.join(TestServer.root_path, 'lib', 'test_server', 'locales', '*.yml')]
      I18n.backend.load_translations
      I18n.enforce_available_locales = true
    end
  end
end

TestServer.configure_i18n
