$LOAD_PATH <<::File.expand_path('../lib/', __FILE__)

require 'sass'
require 'test_server'
require 'bundler'

if %w{ development test }.include? ENV['RACK_ENV']
  Bundler.require :default, :test, :development
else
  Bundler.require :default
end

TestServer.config.debug_mode = true if ENV['DEBUG']
TestServer.config.log_level = ENV['LOG_LEVEL'] if ENV['LOG_LEVEL']
TestServer.config.access_log = ENV['ACCESS_LOG'] if ENV['ACCESS_LOG']

TestServer.ui_logger.level = TestServer.config.log_level

require File.expand_path('../app/controllers/application_controller.rb', __FILE__)
Dir.glob(::File.expand_path('../app/controllers/*.rb', __FILE__)).each { |f| require f }


trap TestServer.config.reload_config_signal do
  begin
    TestServer.ui_logger.warn 'Reload of configuration requested'
    TestServer::Actions::ReloadConfiguration.new.run
    TestServer.ui_logger.info 'Reload of configuration successful'
  rescue Exceptions::ReloadOfConfigurationFailed => e
    TestServer.ui_logger.fatal "Reload of configuration failed: #{e.message}"
  end
end

#map '/v1/testrating/' do
#  run TestServer::App::TestRatingController
#end

map '/v1/test/' do
  run TestServer::App::TestController
end

map TestServer::App::AssetsController.assets_prefix do
  run TestServer::App::AssetsController.assets
end
